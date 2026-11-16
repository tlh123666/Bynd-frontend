import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/network/api_client.dart';
import '../data/atlas_repository.dart';
import '../data/models/greeting.dart';

/// Atlas 开场白的页面级预取缓存。
///
/// 用户点开弹窗之前就在宿主页面准备好（prepare 由首页/日记页在加载与
/// 切 tab 时调用），弹窗打开时开场白已经存在——打字机多半在宿主页面就
/// 跑完了，打开即全文。单例：每个 origin 缓存一条，跨弹窗打开复用。
class AtlasGreetingStore extends ChangeNotifier {
  AtlasGreetingStore._();
  static final AtlasGreetingStore instance = AtlasGreetingStore._();

  final Map<String, AtlasGreeting?> _greetings = {};
  final Set<String> _fetching = {};
  final Map<String, int> _reveal = {};
  Timer? _typeTimer;
  String _typingOrigin = '';

  AtlasGreeting? greetingFor(String origin) => _greetings[origin];

  bool isReady(String origin) {
    final greeting = _greetings[origin];
    return greeting != null &&
        (_reveal[origin] ?? 0) >= greeting.summary.length;
  }

  String revealedSummaryFor(String origin) {
    final greeting = _greetings[origin];
    if (greeting == null) return '';
    final reveal = (_reveal[origin] ?? 0).clamp(0, greeting.summary.length);
    return greeting.summary.substring(0, reveal);
  }

  /// 宿主页面在变得可见时调用（首页各 tab / 日记页）。幂等：同 origin
  /// 已取过（含取过但为空）就不重复请求。
  Future<void> prepare(String origin, AtlasRepository repository) async {
    if (_greetings.containsKey(origin) || _fetching.contains(origin)) return;
    _fetching.add(origin);
    try {
      final greeting = await repository.fetchGreeting(context: origin);
      if (greeting == null) {
        // 失败/无数据也缓存空值：避免每次切 tab 都重试打后端。
        _greetings[origin] = null;
        notifyListeners();
        return;
      }
      _greetings[origin] = greeting;
      _reveal[origin] = 0;
      _startTyping(origin);
      notifyListeners();
    } on ApiException {
      _greetings[origin] = null;
      notifyListeners();
    } finally {
      _fetching.remove(origin);
    }
  }

  void _startTyping(String origin) {
    _typingOrigin = origin;
    _typeTimer?.cancel();
    _typeTimer = Timer.periodic(const Duration(milliseconds: 18), (timer) {
      if (_typingOrigin.isEmpty) {
        timer.cancel();
        return;
      }
      final greeting = _greetings[_typingOrigin];
      if (greeting == null) {
        timer.cancel();
        return;
      }
      final reveal = (_reveal[_typingOrigin] ?? 0) + 1;
      if (reveal >= greeting.summary.length) {
        _reveal[_typingOrigin] = greeting.summary.length;
        timer.cancel();
        notifyListeners();
        return;
      }
      _reveal[_typingOrigin] = reveal;
      notifyListeners();
    });
  }

  /// 弹窗把开场白并入对话历史后调用：打字进度拉满，避免残留光标。
  void completeTyping(String origin) {
    final greeting = _greetings[origin];
    if (greeting != null) {
      _reveal[origin] = greeting.summary.length;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    super.dispose();
  }
}
