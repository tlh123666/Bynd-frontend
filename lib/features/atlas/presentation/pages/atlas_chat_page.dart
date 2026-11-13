import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../application/atlas_chat_controller.dart';
import '../../application/atlas_scope.dart';
import '../../data/models/conversation.dart';
import 'atlas_conversations_sheet.dart';
import 'insights_page.dart';

/// ATLAS 聊天页 —— 按 BYND UI 源码复刻（src/screens/Assistente.jsx +
/// src/styles/atlas-caixa.css，Luiz 2026-10/11 的 Whoop 模型定稿）。
///
/// 与源码 CSS 的对应关系（最终 rodada 的值为准）：
/// * 背景 `.page.chat`：linear-gradient(#222C38 → #1A2029 → #121418)；
/// * AI 回复无卡片（透明、正文 #F4F5F7 92%、15.5 行高 1.6）；
/// * 用户气泡 `.bubble-me`：#2B2E33、边线白 8%、圆角 16/16/5/16；
/// * 建议条 `.at-sug`：玻璃胶囊（40,44,52,55% / 白 12%），横滑；
/// * 输入区 `.gx-caixa`：圆角 26，两团蓝光（58,82,112）叠在深底上；
/// * 发送钮 `.gx-acao`：白圆 38，深色箭头/停止方块；
/// * 反应 `.reac`：复制/赞/踩，灰 45%，选中变白。
class AtlasChatPage extends StatefulWidget {
  const AtlasChatPage({super.key});

  @override
  State<AtlasChatPage> createState() => _AtlasChatPageState();
}

/// 客户源码里的定稿色值（atlas-caixa.css），集中放这里避免散落的魔法数。
class _AtlasCss {
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

class _AtlasChatPageState extends State<AtlasChatPage> {
  late final AtlasChatController _controller;
  bool _controllerReady = false;
  final _input = TextEditingController();
  final _scroll = ScrollController();
  bool _atBottom = true;

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
    return Scaffold(
      // .page.chat 背景：三段渐变，同客户定稿
      backgroundColor: _AtlasCss.bgBottom,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, 0.24, 0.58],
            colors: [_AtlasCss.bgTop, _AtlasCss.bgMid, _AtlasCss.bgBottom],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) => _buildList(strings),
                    ),
                  ),
                  _buildSuggestions(strings),
                  _buildComposer(strings),
                ],
              ),
              // 顶栏浮在对话上、带向下渐隐的毛玻璃（.page.chat.folha .at-cab）
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: _buildHeader(strings),
              ),
              if (!_atBottom)
                Positioned(
                  bottom: 196,
                  left: 0,
                  right: 0,
                  child: Center(child: _buildScrollDownButton()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations strings) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xC21A2029),
                Color(0x801A2029),
                Colors.transparent,
              ],
            ),
          ),
          padding: const EdgeInsets.only(top: 12),
          height: 62,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // .at-alca：顶部的拖拽把手形状，在 tab 形态里是纯粹的品牌形态
              Positioned(
                top: 2,
                child: Container(
                  width: 38,
                  height: 5,
                  decoration: BoxDecoration(
                    color: _AtlasCss.handle,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Text(
                strings.chatTitle,
                style: const TextStyle(
                  color: _AtlasCss.textFull,
                  fontSize: 19,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.01,
                ),
              ),
              Positioned(
                right: 2,
                top: 6,
                child: IconButton(
                  tooltip: strings.insightsTitle,
                  icon: const Icon(Icons.lightbulb_outline, size: 24),
                  color: _AtlasCss.textFull.withValues(alpha: .85),
                  onPressed: () => Navigator.of(context).push<void>(
                    MaterialPageRoute(builder: (_) => const InsightsPage()),
                  ),
                ),
              ),
            ],
          ),
        ),
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
        return false;
      },
      child: ListView(
        controller: _scroll,
        padding: const EdgeInsets.fromLTRB(16, 76, 16, 8),
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
    final showChips = !_controller.isStreaming && _atBottom;
    // .at-sug：流式进行中淡出，完成后浮现（opacity 0 → 1 + 位移）
    return AnimatedOpacity(
      opacity: showChips ? 1 : 0,
      duration: const Duration(milliseconds: 350),
      child: SizedBox(
        height: 44,
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

  Widget _buildComposer(AppLocalizations strings) {
    return Padding(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 6,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      child: _ComposerBox(
        controller: _input,
        streaming: _controller.isStreaming,
        onSend: _send,
        onStop: () => _controller.stop(),
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

  Widget _buildScrollDownButton() {
    // .at-desce：34 圆形玻璃，滚离底部 160px 以上才出现
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xBF282C34),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: _AtlasCss.whiteLine),
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_downward, size: 18),
        color: _AtlasCss.textFull,
        onPressed: () => _jumpToBottom(),
      ),
    );
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
    required this.onSend,
    required this.onStop,
    required this.onHistory,
  });

  final TextEditingController controller;
  final bool streaming;
  final VoidCallback onSend;
  final VoidCallback onStop;
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
                      enabled: controller.text.trim().isNotEmpty || streaming,
                      onSend: onSend,
                      onStop: onStop,
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

/// `.gx-acao`：38 白圆——发送=上箭头、流式=深色停止方块（`.gx-quad`）。
class _SendButton extends StatefulWidget {
  const _SendButton({
    required this.streaming,
    required this.enabled,
    required this.onSend,
    required this.onStop,
    required this.controller,
  });

  final bool streaming;
  final bool enabled;
  final VoidCallback onSend;
  final VoidCallback onStop;
  final TextEditingController controller;

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
              : hasText
              ? widget.onSend
              : null,
          child: Center(
            child: widget.streaming
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
                    Icons.arrow_upward,
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
