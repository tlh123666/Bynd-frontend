import 'dart:io' show Platform;
import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../application/atlas_chat_controller.dart';
import '../../application/atlas_scope.dart';
import '../../data/models/conversation.dart';
import 'atlas_conversations_sheet.dart';
import 'atlas_memory_page.dart';
import 'system_gesture_zone.dart';

/// ATLAS 对话浮层 —— 按 BYND UI 源码复刻（src/screens/Assistente.jsx +
/// src/styles/atlas-caixa.css 的 folha 模式）：
///
/// * 底部 Tab 的 Atlas 不切页，而是从底部滑出一张浮层卡片
///   （`.page.chat.folha`）：顶部与安全区之间留 34px 间距、圆角 28、
///   底后景被 `.atlas-embaca` 毛玻璃遮罩盖住（含首页 tabbar）；
/// * 头部：X 关闭（左）/ Atlas（中）/ Memória 脑图标（右），可下滑关闭；
/// * 背景 `.page.chat`：linear-gradient(#222C38 → #1A2029 → #121418)；
/// * AI 回复无卡片（正文 #F4F5F7 92%、15.5 行高 1.6），流式末尾蓝点光标；
/// * 用户气泡 `.bubble-me`：#2B2E33、圆角 16/16/5/16；
/// * 建议条 `.at-sug`：玻璃胶囊，流式中淡出、完成后浮现；
/// * 输入区 `.gx-caixa`：圆角 26、两团蓝光叠深底；动作钮 `.gx-acao`：
///   白圆 38 —— 空文案=麦克风、有文案=上箭头、流式=停止方块；
/// * 反应 `.reac`：复制/赞/踩，灰 45%，选中变白。
class AtlasSheetRoute extends PageRouteBuilder<void> {
  AtlasSheetRoute()
    : super(
        opaque: false,
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 420),
        reverseTransitionDuration: const Duration(milliseconds: 380),
        pageBuilder: (_, _, _) =>
            const AtlasChatPage(),
        transitionsBuilder: (_, animation, _, child) => SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
            CurvedAnimation(
              parent: animation,
              curve: const Cubic(0.32, 0.72, 0, 1),
            ),
          ),
          child: child,
        ),
      );
}

/// 源码的 Memória 脑图标（Assistente.jsx `IC.lampada`，24 viewBox 描边）。
const String _memoriaBrainSvg =
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"'
    ' stroke="#F4F5F7" stroke-width="1.7" stroke-linecap="round"'
    ' stroke-linejoin="round"><path d="M12 5.2a3 3 0 0 0-5.7 1.3A3 3 0 0 0 '
    '4.2 11a3.2 3.2 0 0 0 1.6 5.4A3 3 0 0 0 12 18.4z"/><path d="M12 5.2a3 3 '
    '0 0 1 5.7 1.3 3 3 0 0 1 2.1 4.5 3.2 3.2 0 0 1-1.6 5.4A3 3 0 0 1 12 '
    '18.4z"/><path d="M12 5.2v13.2M8.3 9.6c.9 0 1.6.6 1.6 1.4M15.7 9.6c-.9 0 '
    '-1.6.6-1.6 1.4M7.6 14.2h1.6M14.8 14.2h1.6"/></svg>';

/// 客户源码里的定稿色值（atlas-caixa.css），集中放这里避免散落的魔法数。
class _AtlasCss {
  /// Android 上禁用 BackdropFilter：Impeller Vulkan（Flutter 3.47 已无法
  /// 通过 manifest opt-out）对「透明路由跨层背景采样」有黑帧 bug——真机
  /// (2510DRK44C / Android 16 / Adreno Vulkan) 实测全屏与露出条两种范围
  /// 均复现黑屏（应用仍在前台、无异常）。iOS/macOS/web 保留真毛玻璃。
  static final bool canBlur = kIsWeb || !Platform.isAndroid;

  static const bgTop = Color(0xFF222C38);
  static const bgMid = Color(0xFF1A2029);
  static const bgBottom = Color(0xFF121418);
  static const text = Color(0xF2F4F5F7); // rgba(244,245,247,.92)
  static const textFull = Color(0xFFF4F5F7);
  static const textDim = Color(0x73F4F5F7); // rgba(244,245,247,.45)
  static const bubbleMe = Color(0xFF2B2E33);
  static const whiteLine = Color(0x14FFFFFF); // rgba(255,255,255,.08)
  static const chipBg = Color(0x8C282C34); // rgba(40,44,52,.55)
  static const inputBase = Color(0xE61E222A); // rgba(30,34,42,.9)
  static const inputGlow = Color(0x593A5270); // rgba(58,82,112,.35)
  static const cursorBlue = Color(0xFF8FBCF0);
  static const handle = Color(0x47FFFFFF); // rgba(255,255,255,.28)
}

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
  bool _atBottom = true;
  bool _listAtTop = true;

  /// Memória 子层是否展开（脑图标切换；‹/下滑收回）。
  bool _memoryOpen = false;

  // ── 整卡跟手下滑关闭（源码 useFolha：头部或列表在顶部时可拖）──────
  double _dragDy = 0;
  bool _dragging = false;
  bool _dragArmed = false;
  double _velocity = 0;
  Duration? _lastMoveAt;
  double? _lastMoveDy;

  void _onSheetPointerDown(PointerDownEvent event) {
    _dragDy = 0;
    _dragging = false;
    _velocity = 0;
    _lastMoveAt = null;
    _lastMoveDy = null;
    // 系统手势区（左右边缘/底部）内不起手：同一次滑动会被系统判定为
    // 返回/回桌面，卡片刚关掉应用就被退到后台（黑屏之谜的真相）。
    final inGestureZone = pointerStartsInSystemGestureZone(event, context);
    // 从头部（含把手）按下即可拖；列表区域只有在顶部才可拖
    _dragArmed = !inGestureZone && _listAtTop;
  }

  void _onSheetPointerMove(PointerMoveEvent event) {
    if (_memoryOpen || !_dragArmed) return;
    final delta = event.delta.dy;
    if (delta <= 0 && _dragDy <= 0) return;
    final dt = _lastMoveAt == null
        ? null
        : (event.timeStamp - _lastMoveAt!).inMicroseconds / 1e6;
    if (dt != null && dt > 0 && _lastMoveDy != null) {
      _velocity = (delta - _lastMoveDy!) / dt;
    }
    _lastMoveAt = event.timeStamp;
    _lastMoveDy = delta;
    if (delta > 0 || _dragDy > 0) {
      setState(() {
        _dragging = true;
        _dragDy = (_dragDy + delta).clamp(0.0, double.infinity);
      });
    }
  }

  void _onSheetPointerUp() {
    if (_memoryOpen || !_dragging) return;
    // 阈值故意调低（源码 useFolha 更宽松）：滑动起手若落在屏幕底部系统
    // 手势条（约 27 逻辑 px）会被 MIUI 整个吃掉、卡片纹丝不动，用户会
    // 反复重试并触发「上滑清理」杀进程（黑屏真因，logcat 五次实锤），
    // 因此让第一次有效滑动尽量容易成功。
    final close = _dragDy > 110 || _velocity > 700;
    if (close) {
      // 卡片先滑出屏幕（跟手动画的延续），再关路由（路由自身的下滑
      // 退场动画此刻作用在已离屏的卡片上，不可见，不会双重动画）
      setState(() {
        _dragging = false;
        _dragDy = 1400;
      });
      Future.delayed(const Duration(milliseconds: 240), () {
        if (mounted) Navigator.of(context).pop();
      });
    } else {
      setState(() {
        _dragging = false;
        _dragDy = 0;
      });
    }
  }

  /// 麦克风的「语音输入」演示（源码 ouvir）：逐字把默认问题写进输入框
  /// 再发送；进行中动作钮变停止方块。
  bool _voiceTyping = false;

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

  void _jumpToBottom({bool smooth = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: Duration(milliseconds: smooth ? 180 : 60),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send() async {
    final text = _input.text;
    _input.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    await _controller.send(text);
    _jumpToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final media = MediaQuery.of(context);
    // .page.chat.folha：顶部 = max(安全区, 47) + 间距（源码 --folha-topo
    // 为 34；按反馈收窄到 20，卡片整体显得更高）。
    final sheetTop = (media.padding.top > 47 ? media.padding.top : 47.0) + 20;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Listener(
        onPointerDown: _onSheetPointerDown,
        onPointerMove: _onSheetPointerMove,
        onPointerUp: (_) => _onSheetPointerUp(),
        onPointerCancel: (_) => _onSheetPointerUp(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // .atlas-embaca：盖住底后景的暗纱（含首页 tabbar），随卡片下滑
            // 衰减，露出上一个页面（源码 .atlas-embaca { opacity:0 }）。
            // Android 无真模糊，用略深的暗纱营造层次（黑帧 bug 见
            // _AtlasCss.canBlur 注释）。
            Positioned.fill(
              child: ColoredBox(
                color: const Color(0xFF0A0E14).withValues(
                  alpha: (_AtlasCss.canBlur ? 0.55 : 0.72) * _veilFade,
                ),
              ),
            ),
            if (_AtlasCss.canBlur)
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: sheetTop + 8,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: _veilSigma,
                      sigmaY: _veilSigma,
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.only(top: sheetTop),
              child: AnimatedSlide(
                duration: _dragging
                    ? Duration.zero
                    : const Duration(milliseconds: 240),
                curve: Curves.easeOut,
                offset: Offset(0, _dragDy / media.size.height),
                child: DecoratedBox(
                  // 注意：这里刻意不加 BoxShadow/模糊——大半径模糊阴影在
                  // 拖动与退场动画期间每帧重画，是 Android Impeller 黑屏
                  // 的触发源（真机踩过两次）；层次感由遮罩层提供。
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                    child: ColoredBox(
                      color: _AtlasCss.bgBottom,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0, 0.2, 0.55],
                            colors: [
                              _AtlasCss.bgTop,
                              _AtlasCss.bgMid,
                              _AtlasCss.bgBottom,
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            // 主对话 tela：Memória 打开时左移淡出
                            IgnorePointer(
                              ignoring: _memoryOpen,
                              child: AnimatedOpacity(
                                opacity: _memoryOpen ? 0 : 1,
                                duration: const Duration(milliseconds: 300),
                                child: AnimatedSlide(
                                  offset: _memoryOpen
                                      ? const Offset(-0.22, 0)
                                      : Offset.zero,
                                  duration: const Duration(milliseconds: 420),
                                  curve: const Cubic(0.32, 0.72, 0, 1),
                                  child: Column(
                                    children: [
                                      _buildHeader(strings),
                                      Expanded(
                                        child: AnimatedBuilder(
                                          animation: _controller,
                                          builder: (context, _) =>
                                              _buildList(strings),
                                        ),
                                      ),
                                      _buildSuggestions(strings),
                                      _buildComposer(strings),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Memória 子 tela：从右滑入盖住对话
                            AnimatedSlide(
                              offset: _memoryOpen
                                  ? Offset.zero
                                  : const Offset(1, 0),
                              duration: const Duration(milliseconds: 420),
                              curve: const Cubic(0.32, 0.72, 0, 1),
                              child: IgnorePointer(
                                ignoring: !_memoryOpen,
                                child: AtlasMemoryLayer(
                                  onClose: () =>
                                      setState(() => _memoryOpen = false),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// `.atlas-embaca`：静止时毛玻璃 sigma 与暗色 tint 都取满值；拖动中随
  /// 位移衰减（>300px 全清），卡片滑走时直接露出清晰的上一个页面。
  double get _veilFade => (1 - _dragDy / 300).clamp(0.0, 1.0);
  double get _veilSigma => 12 * _veilFade;

  /// 头部拖拽起手是否被系统手势区拦下（X 按钮贴着左边缘，易误触系统返回）。
  bool _headerDragBlocked = false;

  /// `.at-cab`：把手居中、X 左、Atlas 中、Memória 右；头部支持下滑关闭
  /// （useFolha：alça/头部拖拽，往下甩出即关）。
  ///
  /// 布局用 Row 三段等宽（44/1fr/44）：不能用 Stack 收缩布局——Stack 会
  /// 收缩到标题宽度，Positioned 的 X/脑图标就全挤到标题周围（真机踩过）。
  Widget _buildHeader(AppLocalizations strings) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragStart: (details) =>
          _headerDragBlocked = offsetInSystemGestureZone(
            details.globalPosition,
            context,
          ),
      onVerticalDragUpdate: (details) {
        if (_headerDragBlocked || _memoryOpen) return;
        final delta = details.primaryDelta ?? 0;
        if (delta > 0 || _dragDy > 0) {
          setState(() {
            _dragging = true;
            _dragDy = (_dragDy + delta).clamp(0.0, double.infinity);
          });
        }
      },
      onVerticalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (_headerDragBlocked || _memoryOpen) {
          _headerDragBlocked = false;
          return;
        }
        final close = _dragDy > 110 || velocity > 700;
        if (close) {
          setState(() {
            _dragging = false;
            _dragDy = 1400;
          });
          Future.delayed(const Duration(milliseconds: 240), () {
            if (mounted) Navigator.of(context).pop();
          });
        } else {
          setState(() {
            _dragging = false;
            _dragDy = 0;
          });
        }
      },
      child: Column(
        children: [
          // .at-alca：把手
          Container(
            width: 38,
            height: 5,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: _AtlasCss.handle,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          SizedBox(
            height: 48,
            child: Row(
              children: [
                // .at-x：左上关闭
                IconButton(
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  icon: const Icon(Icons.close, size: 24),
                  color: _AtlasCss.textFull.withValues(alpha: .85),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Text(
                    strings.chatTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _AtlasCss.textFull,
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.01,
                    ),
                  ),
                ),
                // .at-mem：Memória 子层开关（与源码一致：setTela(['mem'])，
                // 子层在浮层内从右滑入）
                IconButton(
                  tooltip: strings.memoriaTitle,
                  onPressed: () => setState(() => _memoryOpen = true),
                  icon: SvgPicture.string(
                    _memoriaBrainSvg,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Color(0xD9F4F5F7),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(AppLocalizations strings) {
    final controller = _controller;
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final metrics = notification.metrics;
        final far = metrics.maxScrollExtent - metrics.pixels > 160;
        if (far != _atBottom) setState(() => _atBottom = !far);
        final atTop = metrics.pixels <= 0.5;
        if (atTop != _listAtTop) setState(() => _listAtTop = atTop);
        return false;
      },
      child: ListView(
        controller: _scroll,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        children: [
          if (controller.error != null)
            _ErrorBanner(message: controller.error!),
          if (controller.loadingHistory)
            const Center(child: _TypingDots())
          else if (controller.messages.isEmpty &&
              controller.streamingText.isEmpty &&
              !controller.isStreaming)
            _EmptyState(hint: strings.chatEmptyHint)
          else ...[
            for (final message in controller.messages) ...[
              if (message.isUser)
                _UserBubble(message: message)
              else ...[
                _BotReply(content: message.content),
                // 完成态的回复才有反应行（流式中不显示）
                if (message == controller.messages.last &&
                    !controller.isStreaming)
                  _ReactionRow(content: message.content),
              ],
            ],
            if (controller.streamingText.isNotEmpty)
              _BotReply(content: controller.streamingText, streaming: true)
            else if (controller.isStreaming)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _TypingDots(),
                ),
              ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSuggestions(AppLocalizations strings) {
    final showChips = !_controller.isStreaming && !_voiceTyping && _atBottom;
    // .at-sug：流式进行中淡出，完成后浮现（opacity 0 → 1 + 位移）
    return AnimatedOpacity(
      opacity: showChips ? 1 : 0,
      duration: const Duration(milliseconds: 350),
      child: SizedBox(
        height: 38,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          children: [
            for (final suggestion in [
              strings.chatSug1,
              strings.chatSug2,
              strings.chatSug3,
            ])
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _SuggestionChip(
                  label: suggestion,
                  onTap: showChips ? () async => _sendText(suggestion) : null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendText(String text) async {
    await _controller.send(text);
    _jumpToBottom();
  }

  /// `ouvir`：逐字把默认问题写进输入框（每 45ms 一个字符），停 300ms 后
  /// 发送。进行中再点动作钮 = 取消（源码 parar 的语义）。
  Future<void> _voiceAsk(AppLocalizations strings) async {
    if (_voiceTyping || _controller.isStreaming) return;
    setState(() => _voiceTyping = true);
    final phrase = strings.chatSug1;
    _input.clear();
    for (var i = 1; i <= phrase.length; i++) {
      if (!mounted || !_voiceTyping) return;
      _input.value = TextEditingValue(
        text: phrase.substring(0, i),
        selection: TextSelection.collapsed(offset: i),
      );
      await Future<void>.delayed(const Duration(milliseconds: 45));
    }
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() => _voiceTyping = false);
    await _send();
  }

  void _cancelVoice() {
    setState(() => _voiceTyping = false);
    _input.clear();
  }

  Widget _buildComposer(AppLocalizations strings) {
    return Padding(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      child: _ComposerBox(
        controller: _input,
        streaming: _controller.isStreaming,
        voiceTyping: _voiceTyping,
        onSend: _send,
        onStop: () => _controller.stop(),
        onMic: () => _voiceAsk(strings),
        onStopVoice: _cancelVoice,
        onHistory: () => _openConversations(strings),
      ),
    );
  }

  Future<void> _openConversations(AppLocalizations strings) async {
    final conversation = await showModalBottomSheet<AtlasConversation>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AtlasConversationsSheet(loader: _controller.loadHistory),
    );
    if (conversation == null) return;
    await _controller.openConversation(conversation.id);
    _jumpToBottom(smooth: false);
  }
}

/// AI 回复：无卡片、纯文本（`.chat-list .bubble-bot`），流式时末尾带蓝点光标
/// （`.at-cursor`）。
class _BotReply extends StatelessWidget {
  const _BotReply({required this.content, this.streaming = false});

  final String content;
  final bool streaming;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              content,
              style: const TextStyle(
                color: _AtlasCss.text,
                fontSize: 15.5,
                height: 1.6,
              ),
            ),
            if (streaming)
              const Padding(
                padding: EdgeInsets.only(top: 3),
                child: _CursorDot(),
              ),
          ],
        ),
      ),
    );
  }
}

/// `.at-cursor > :last-child::after`：7px 蓝点，1s 闪烁。
class _CursorDot extends StatefulWidget {
  const _CursorDot();

  @override
  State<_CursorDot> createState() => _CursorDotState();
}

class _CursorDotState extends State<_CursorDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: Tween(begin: .25, end: 1.0).animate(_pulse),
    child: Container(
      width: 7,
      height: 7,
      decoration: const BoxDecoration(
        color: _AtlasCss.cursorBlue,
        shape: BoxShape.circle,
      ),
    ),
  );
}

/// `.bubble-me`：#2B2E33、圆角 16/16/5/16、右边贴齐，最宽 78%。
class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.message});

  final AtlasMessage message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78,
          ),
          decoration: BoxDecoration(
            color: _AtlasCss.bubbleMe,
            border: Border.all(color: _AtlasCss.whiteLine),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(5),
            ),
          ),
          child: Text(
            message.content,
            style: const TextStyle(color: _AtlasCss.textFull, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

/// `.reac`：复制 / 赞 / 踩，灰色小图标，选中变白。视觉反馈本地保存——
/// 后端目前没有反馈端点，不伪装上报。
class _ReactionRow extends StatefulWidget {
  const _ReactionRow({required this.content});

  final String content;

  @override
  State<_ReactionRow> createState() => _ReactionRowState();
}

class _ReactionRowState extends State<_ReactionRow> {
  int _vote = 0;
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, left: 2),
      child: Row(
        children: [
          _ReactionButton(
            icon: _copied ? Icons.check : Icons.copy_outlined,
            active: _copied,
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: widget.content));
              setState(() => _copied = true);
              await Future<void>.delayed(const Duration(milliseconds: 1400));
              if (mounted) setState(() => _copied = false);
            },
          ),
          const SizedBox(width: 6),
          _ReactionButton(
            icon: Icons.thumb_up_alt_outlined,
            active: _vote == 1,
            onTap: () => setState(() => _vote = _vote == 1 ? 0 : 1),
          ),
          const SizedBox(width: 6),
          _ReactionButton(
            icon: Icons.thumb_down_alt_outlined,
            active: _vote == -1,
            onTap: () => setState(() => _vote = _vote == -1 ? 0 : -1),
          ),
        ],
      ),
    );
  }
}

class _ReactionButton extends StatelessWidget {
  const _ReactionButton({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => IconButton(
    visualDensity: VisualDensity.compact,
    constraints: const BoxConstraints(minWidth: 32, minHeight: 28),
    padding: EdgeInsets.zero,
    iconSize: 15,
    icon: Icon(icon),
    color: active ? _AtlasCss.textFull : _AtlasCss.textDim,
    onPressed: onTap,
  );
}

/// `.at-sug button`：玻璃胶囊，横排。
class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? 0 : 1,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _AtlasCss.chipBg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: _AtlasCss.whiteLine),
          ),
          child: Text(
            label,
            style: const TextStyle(color: _AtlasCss.textFull, fontSize: 13.5),
          ),
        ),
      ),
    );
  }
}

/// `.gx-caixa`：圆角 26 深底 + 两团蓝光（右上 / 左下）+ 细白边。
class _ComposerBox extends StatelessWidget {
  const _ComposerBox({
    required this.controller,
    required this.streaming,
    required this.voiceTyping,
    required this.onSend,
    required this.onStop,
    required this.onMic,
    required this.onStopVoice,
    required this.onHistory,
  });

  final TextEditingController controller;
  final bool streaming;
  final bool voiceTyping;
  final VoidCallback onSend;
  final VoidCallback onStop;
  final VoidCallback onMic;
  final VoidCallback onStopVoice;
  final VoidCallback onHistory;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: Stack(
        children: [
          Positioned.fill(child: Container(color: _AtlasCss.inputBase)),
          // 两团蓝光：radial(90% 120% at 100% 0) 与 radial(90% 120% at 0% 100%)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.2,
                  colors: [
                    _AtlasCss.inputGlow,
                    _AtlasCss.inputGlow.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.bottomLeft,
                  radius: 1.2,
                  colors: [
                    _AtlasCss.inputGlow.withValues(alpha: .86),
                    _AtlasCss.inputGlow.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: _AtlasCss.whiteLine),
            ),
            padding: const EdgeInsets.fromLTRB(14, 12, 8, 8),
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSend(),
                  style: const TextStyle(
                    color: _AtlasCss.textFull,
                    fontSize: 16,
                    height: 1.45,
                  ),
                  cursorColor: _AtlasCss.cursorBlue,
                  decoration: InputDecoration(
                    hintText: strings.chatInputHint,
                    hintStyle: const TextStyle(color: _AtlasCss.textDim),
                    border: InputBorder.none,
                    filled: false,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _ComposerIcon(
                      icon: Icons.attach_file,
                      tooltip: strings.chatTitle,
                      onTap: onHistory,
                    ),
                    const SizedBox(width: 10),
                    const Spacer(),
                    _SendButton(
                      controller: controller,
                      streaming: streaming,
                      voiceTyping: voiceTyping,
                      onSend: onSend,
                      onStop: onStop,
                      onMic: onMic,
                      onStopVoice: onStopVoice,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// `.gx-red`：无底色的 34 图标钮。
class _ComposerIcon extends StatelessWidget {
  const _ComposerIcon({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    onPressed: onTap,
    iconSize: 19,
    icon: Icon(icon),
    color: _AtlasCss.textFull.withValues(alpha: .85),
  );
}

/// `.gx-acao`：38 白圆——四态（源码 `{escrevendo || ouvindo ? parar : text ?
/// enviar : mic}`）：真实流式/语音打字中=停止方块、有文案=上箭头、
/// 空文案=麦克风。
class _SendButton extends StatefulWidget {
  const _SendButton({
    required this.controller,
    required this.streaming,
    required this.voiceTyping,
    required this.onSend,
    required this.onStop,
    required this.onMic,
    required this.onStopVoice,
  });

  final TextEditingController controller;
  final bool streaming;
  final bool voiceTyping;
  final VoidCallback onSend;
  final VoidCallback onStop;
  final VoidCallback onMic;
  final VoidCallback onStopVoice;

  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(_SendButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_refresh);
      widget.controller.addListener(_refresh);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final busy = widget.streaming || widget.voiceTyping;
    final hasText = widget.controller.text.trim().isNotEmpty;
    return SizedBox(
      width: 38,
      height: 38,
      child: Material(
        color: _AtlasCss.textFull,
        borderRadius: BorderRadius.circular(19),
        child: InkWell(
          borderRadius: BorderRadius.circular(19),
          onTap: widget.streaming
              ? widget.onStop
              : widget.voiceTyping
              ? widget.onStopVoice
              : hasText
              ? widget.onSend
              : widget.onMic,
          child: Center(
            child: busy
                ? Container(
                    // .gx-quad：12x12 圆角 3 的深色方块
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF14181D),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  )
                : Icon(
                    hasText ? Icons.arrow_upward : Icons.mic_none,
                    size: 18,
                    color: hasText
                        ? const Color(0xFF14181D)
                        : const Color(0x5A14181D),
                  ),
          ),
        ),
      ),
    );
  }
}

/// `.typing`：三个跳动的小点。
class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 3; i++)
          FadeTransition(
            opacity: CurveTween(
              curve: Interval(i * .2, (i + 3) * .3, curve: Curves.easeInOut),
            ).animate(_pulse),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: _AtlasCss.textDim,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
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
      color: _AtlasCss.bubbleMe,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.error),
    ),
    child: Text(
      message,
      style: const TextStyle(color: _AtlasCss.textFull, fontSize: 14),
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
      style: const TextStyle(color: _AtlasCss.textDim, fontSize: 14.5),
    ),
  );
}
