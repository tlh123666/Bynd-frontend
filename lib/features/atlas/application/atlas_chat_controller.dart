import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../../core/network/api_client.dart';
import '../data/atlas_repository.dart';
import '../data/models/conversation.dart';

/// ATLAS 聊天的状态机。
///
/// SSE 事件协议（后端 assistant/handler streamMessage）：
/// `start` {conversationId, requestId, generationId} →
/// `status` {phase: preparing|generating|validating|saving|completed…} →
/// `delta` {content}* → `content_done` → `done` {conversationId, message,
/// title} 或 `error` {code, message}。
///
/// 两个容易踩的坑都集中在这里处理：
/// * 同一回合的 generationId 就是发送时给的 clientRequestId（后端为对账
///   归一化过），取消接口必须用同一个值；
/// * error 事件里带业务码（如每日配额），必须透传给 UI，不能吞成「生成失败」。
class AtlasChatController extends ChangeNotifier {
  AtlasChatController(this._repository);

  final AtlasRepository _repository;
  StreamSubscription<String>? _subscription;

  String? _conversationId;
  String? _generationId;
  final List<AtlasMessage> _messages = [];
  String _streamingText = '';
  String _phase = 'idle';
  String? _error;
  bool _loadingHistory = false;

  List<AtlasMessage> get messages => List.unmodifiable(_messages);
  String get streamingText => _streamingText;
  String get phase => _phase;
  String? get error => _error;
  bool get loadingHistory => _loadingHistory;
  bool get hasConversation => _conversationId != null;

  bool get isStreaming =>
      _subscription != null || _phase == 'preparing' || _phase == 'generating';

  Future<List<AtlasConversation>> loadHistory() async =>
      (await _repository.fetchConversations()).items;

  /// 打开一段已有对话并拉取历史消息。
  Future<void> openConversation(String conversationId) async {
    if (_subscription != null) return; // 流式进行中不切换，避免交错写
    _conversationId = conversationId;
    _loadingHistory = true;
    _messages.clear();
    _streamingText = '';
    _error = null;
    notifyListeners();
    try {
      final history = await _repository.fetchMessages(conversationId);
      _messages
        ..clear()
        ..addAll(history);
    } on ApiException catch (error) {
      _error = error.message;
    } finally {
      _loadingHistory = false;
      notifyListeners();
    }
  }

  /// 新开一段对话：清空本地视图；conversationId 在第一次发送时才创建，
  /// 避免产生一堆空对话。
  void startNewConversation() {
    if (_subscription != null) return;
    _conversationId = null;
    _messages.clear();
    _streamingText = '';
    _error = null;
    notifyListeners();
  }

  /// 发送一条消息。返回值仅用于测试断言；UI 不依赖。
  Future<void> send(String content) async {
    final text = content.trim();
    if (text.isEmpty || isStreaming) return;
    _error = null;
    try {
      _conversationId ??= (await _repository.createConversation()).id;
    } on ApiException catch (error) {
      _error = error.message;
      notifyListeners();
      return;
    }
    _messages.add(
      AtlasMessage(
        id: 'local-user-${DateTime.now().microsecondsSinceEpoch}',
        role: 'user',
        content: text,
        status: 'completed',
        createdAt: DateTime.now().toUtc().toIso8601String(),
      ),
    );
    final requestId =
        'flutter-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(1 << 32)}';
    _generationId = requestId;
    _streamingText = '';
    _phase = 'preparing';
    notifyListeners();

    final buffer = StringBuffer();
    String? event;
    try {
      final lines = _repository.sendMessageSse(
        conversationId: _conversationId!,
        content: text,
        clientRequestId: requestId,
      );
      await for (final line in lines) {
        if (line.startsWith('event:')) {
          event = line.substring(6).trim();
          continue;
        }
        if (!line.startsWith('data:')) continue;
        final payload = _safeDecode(line.substring(5).trim());
        switch (event) {
          case 'start':
            final generation = payload?['generationId'] as String?;
            if (generation != null && generation.isNotEmpty) {
              _generationId = generation;
            }
          case 'status':
            _phase = (payload?['phase'] as String?) ?? _phase;
          case 'delta':
            buffer.write(payload?['content'] as String? ?? '');
            _streamingText = buffer.toString();
          case 'content_done':
            break;
          case 'error':
            _error = _errorText(payload);
            _phase = 'idle';
          case 'done':
            final turn = payload == null
                ? null
                : AtlasTurnResult.fromJson(payload);
            if (turn != null && turn.assistantMessage.content.isNotEmpty) {
              _messages.add(turn.assistantMessage);
            } else if (_streamingText.isNotEmpty) {
              // 后端保证了 done 里带最终内容；缺省时把缓冲直接落成消息。
              _messages.add(
                AtlasMessage(
                  id: 'local-assistant-$requestId',
                  role: 'assistant',
                  content: _streamingText,
                  status: 'completed',
                  createdAt: DateTime.now().toUtc().toIso8601String(),
                ),
              );
            }
            _streamingText = '';
            _phase = 'idle';
        }
        notifyListeners();
      }
      // 服务端正常关流但没发 done：缓冲内容照样交付，不丢回复。
      if (_streamingText.isNotEmpty) {
        _messages.add(
          AtlasMessage(
            id: 'local-assistant-$requestId',
            role: 'assistant',
            content: _streamingText,
            status: 'completed',
            createdAt: DateTime.now().toUtc().toIso8601String(),
          ),
        );
        _streamingText = '';
        _phase = 'idle';
        notifyListeners();
      }
    } on ApiException catch (error) {
      // 配额、权限这类准入错误发生在流打开之前——透传业务码给 UI 分支。
      _error = error.message;
      _phase = 'idle';
      notifyListeners();
    } catch (error) {
      _error = error.toString();
      _phase = 'idle';
      notifyListeners();
    } finally {
      _subscription = null;
    }
  }

  /// 停止生成：掐断本地流并通知服务端取消（generationId 是对账键）。
  Future<void> stop() async {
    final generation = _generationId;
    final conversation = _conversationId;
    _subscription?.cancel();
    _subscription = null;
    _phase = 'idle';
    if (_streamingText.isNotEmpty) {
      _messages.add(
        AtlasMessage(
          id: 'local-assistant-stopped-$generation',
          role: 'assistant',
          content: _streamingText,
          status: 'stopped',
          createdAt: DateTime.now().toUtc().toIso8601String(),
        ),
      );
      _streamingText = '';
    }
    notifyListeners();
    if (conversation == null || generation == null) return;
    try {
      await _repository.cancelGeneration(conversation, generation);
    } on ApiException {
      // 取消失败不阻塞 UI：服务端的请求会自然结束并落库。
    }
  }

  String _errorText(Map<String, dynamic>? payload) {
    final message = payload?['message'] as String?;
    if (message != null && message.isNotEmpty) return message;
    return 'A geração falhou. Tente novamente.';
  }

  Map<String, dynamic>? _safeDecode(String raw) {
    if (raw.isEmpty) return null;
    try {
      return jsonDecodeObject(raw);
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

Map<String, dynamic>? jsonDecodeObject(String raw) {
  // 独立小函数便于阅读：data: 行必须是 JSON 对象才算事件负载。
  final decoded = const JsonDecoder().convert(raw);
  return decoded is Map<String, dynamic> ? decoded : null;
}
