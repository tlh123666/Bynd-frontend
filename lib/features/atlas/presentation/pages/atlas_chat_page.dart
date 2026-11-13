import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../application/atlas_chat_controller.dart';
import '../../application/atlas_scope.dart';
import '../../data/models/conversation.dart';
import 'insights_page.dart';

/// ATLAS 聊天页：对话流 + 流式回复 + 发送/停止。
///
/// 界面刻意朴素：这不是营销页，是每天会用的工具页。气泡配色与圆角
/// 取 design_system 令牌，无本地魔法值。
class AtlasChatPage extends StatefulWidget {
  const AtlasChatPage({super.key});

  @override
  State<AtlasChatPage> createState() => _AtlasChatPageState();
}

class _AtlasChatPageState extends State<AtlasChatPage> {
  late final AtlasChatController _controller;
  bool _controllerReady = false;
  final _input = TextEditingController();
  final _scroll = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 取 InheritedWidget 只能在这里，不能在 initState：那时祖先还没挂稳。
    // AtlasScope.repository 由 auth_gate 创建、应用生命周期内不变，这里只取一次。
    if (!_controllerReady) {
      _controller = AtlasChatController(AtlasScope.of(context));
      _controllerReady = true;
    }
  }

  @override
  void dispose() {
    if (_controllerReady) _controller.dispose();
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _jumpToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send() async {
    final text = _input.text;
    _input.clear();
    await _controller.send(text);
    _jumpToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(strings.chatTitle, style: AppTypography.homeTitle),
        actions: [
          IconButton(
            tooltip: strings.insightsTitle,
            icon: const Icon(Icons.insights_outlined),
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute(builder: (_) => const InsightsPage()),
            ),
          ),
          IconButton(
            tooltip: strings.chatNew,
            icon: const Icon(Icons.add_comment_outlined),
            onPressed: () => _controller.startNewConversation(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  if (_controller.loadingHistory) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scroll.hasClients &&
                        _scroll.position.maxScrollExtent > 0) {
                      _scroll.jumpTo(_scroll.position.maxScrollExtent);
                    }
                  });
                  final children = <Widget>[
                    for (final message in _controller.messages)
                      _Bubble(message: message),
                    if (_controller.streamingText.isNotEmpty)
                      _Bubble(
                        message: AtlasMessage(
                          id: 'streaming',
                          role: 'assistant',
                          content: _controller.streamingText,
                          status: _controller.phase,
                          createdAt: '',
                        ),
                        streaming: true,
                      ),
                  ];
                  return ListView(
                    controller: _scroll,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    children: [
                      if (_controller.error != null)
                        _ErrorBanner(message: _controller.error!),
                      if (children.isEmpty)
                        _EmptyState(hint: strings.chatEmptyHint)
                      else
                        ...children,
                      if (_controller.isStreaming &&
                          _controller.streamingText.isEmpty)
                        const _TypingIndicator(),
                    ],
                  );
                },
              ),
            ),
            _InputBar(
              controller: _input,
              enabled: !_controller.isStreaming,
              streaming: _controller.isStreaming,
              onSend: _send,
              onStop: () => _controller.stop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message, this.streaming = false});

  final AtlasMessage message;
  final bool streaming;

  @override
  Widget build(BuildContext context) {
    final mine = message.isUser;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        decoration: BoxDecoration(
          color: mine ? AppColors.surfaceDock : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(mine ? 18 : 6),
            bottomRight: Radius.circular(mine ? 6 : 18),
          ),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              message.content,
              style: AppTypography.listItem.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            if (streaming)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text('▍', style: TextStyle(color: AppColors.textDim)),
              ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.error),
    ),
    child: Text(
      message,
      style: AppTypography.caption.copyWith(color: AppColors.textPrimary),
    ),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
    child: Text(
      hint,
      textAlign: TextAlign.center,
      style: AppTypography.caption.copyWith(color: AppColors.textDim),
    ),
  );
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) => const Align(
    alignment: Alignment.centerLeft,
    child: SizedBox(
      width: 36,
      height: 18,
      child: LinearProgressIndicator(minHeight: 2),
    ),
  );
}

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.enabled,
    required this.streaming,
    required this.onSend,
    required this.onStop,
  });

  final TextEditingController controller;
  final bool enabled;
  final bool streaming;
  final VoidCallback onSend;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              style: AppTypography.listItem.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: strings.chatInputHint,
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: const BorderSide(color: AppColors.glassBorder),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: streaming ? onStop : onSend,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.action,
                shape: BoxShape.circle,
              ),
              child: Icon(
                streaming ? Icons.stop : Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
