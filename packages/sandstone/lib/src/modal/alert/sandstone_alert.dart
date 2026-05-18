part of 'alert.dart';

final class SandstoneAlert {
  const SandstoneAlert._();

  static void hide(BuildContext context) {
    maybeOf(context)?.dismiss();
  }

  static SandstoneAlertState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<SandstoneAlertState>();

  static SandstoneAlertState of(BuildContext context) => maybeOf(context)!;

  static void show({
    required BuildContext context,
    SandstoneAlertType type = SandstoneAlertType.fullscreen,
    Duration duration = const Duration(milliseconds: 200),
    bool autoDismiss = false,
    Duration dismissAfter = const Duration(seconds: 3),
    FocusScopeNode? focusScopeNode,
    FocusNode? parentNode,
    bool autofocus = false,
    bool canRequestFocus = true,
    bool? skipTraversal,
    bool rebuildOnFocusChange = true,
    FocusTraversalPolicy? policy,
    bool descendantsAreFocusable = true,
    bool descendantsAreTraversable = true,
    bool includeSemantics = true,
    DpadScopeEventCallback? onUp,
    DpadScopeEventCallback? onDown,
    DpadScopeEventCallback? onLeft,
    DpadScopeEventCallback? onRight,
    DpadEventCallback? onSelect,
    DpadEventCallback? onLongSelect,
    DpadEventCallback? onBack,
    KeyEventResult Function(FocusNode, KeyEvent)? onKeyEvent,
    void Function(FocusScopeNode, bool)? onFocusChanged,
    void Function(FocusScopeNode)? onFocusDisabledWhenWasFocused,
    Duration longPressDuration = kLongPressTimeout,
    required Widget Function(BuildContext, FocusScopeNode) builder,
  }) {
    final overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _AnimatedOverlayWrapper(
        type: type,
        duration: duration,
        autoDismiss: autoDismiss,
        dismissAfter: dismissAfter,
        onDismissed: overlayEntry.remove,
        focusScopeNode: focusScopeNode,
        parentNode: parentNode,
        autofocus: autofocus,
        canRequestFocus: canRequestFocus,
        skipTraversal: skipTraversal,
        rebuildOnFocusChange: rebuildOnFocusChange,
        policy: policy ?? ReadingOrderTraversalPolicy(),
        descendantsAreFocusable: descendantsAreFocusable,
        descendantsAreTraversable: descendantsAreTraversable,
        includeSemantics: includeSemantics,
        onUp: onUp,
        onDown: onDown,
        onLeft: onLeft,
        onRight: onRight,
        onSelect: onSelect,
        onLongSelect: onLongSelect,
        onBack: onBack,
        onKeyEvent: onKeyEvent,
        onFocusChanged: onFocusChanged,
        onFocusDisabledWhenWasFocused: onFocusDisabledWhenWasFocused,
        longPressDuration: longPressDuration,
        builder: builder,
      ),
    );

    overlayState.insert(overlayEntry);
  }
}

final class _AnimatedOverlayWrapper extends StatefulWidget {
  const _AnimatedOverlayWrapper({
    required this.type,
    required this.duration,
    required this.autoDismiss,
    required this.dismissAfter,
    required this.onDismissed,
    required this.focusScopeNode,
    required this.parentNode,
    required this.autofocus,
    required this.canRequestFocus,
    required this.skipTraversal,
    required this.rebuildOnFocusChange,
    required this.policy,
    required this.descendantsAreFocusable,
    required this.descendantsAreTraversable,
    required this.includeSemantics,
    required this.onUp,
    required this.onDown,
    required this.onLeft,
    required this.onRight,
    required this.onSelect,
    required this.onLongSelect,
    required this.onBack,
    required this.onKeyEvent,
    required this.onFocusChanged,
    required this.onFocusDisabledWhenWasFocused,
    required this.longPressDuration,
    required this.builder,
  });

  final SandstoneAlertType type;
  final Duration duration;
  final bool autoDismiss;
  final Duration dismissAfter;
  final VoidCallback onDismissed;
  final FocusScopeNode? focusScopeNode;
  final FocusNode? parentNode;
  final bool autofocus;
  final bool canRequestFocus;
  final bool? skipTraversal;
  final bool rebuildOnFocusChange;
  final FocusTraversalPolicy policy;
  final bool descendantsAreFocusable;
  final bool descendantsAreTraversable;
  final bool includeSemantics;
  final DpadScopeEventCallback? onUp;
  final DpadScopeEventCallback? onDown;
  final DpadScopeEventCallback? onLeft;
  final DpadScopeEventCallback? onRight;
  final DpadEventCallback? onSelect;
  final DpadEventCallback? onLongSelect;
  final DpadEventCallback? onBack;
  final KeyEventResult Function(FocusNode, KeyEvent)? onKeyEvent;
  final void Function(FocusScopeNode, bool)? onFocusChanged;
  final void Function(FocusScopeNode)? onFocusDisabledWhenWasFocused;
  final Duration longPressDuration;
  final Widget Function(BuildContext, FocusScopeNode) builder;

  @override
  State<StatefulWidget> createState() => SandstoneAlertState();
}

final class SandstoneAlertState extends State<_AnimatedOverlayWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);

    const startOffset = Offset(0, 1);

    _animation = switch (widget.type) {
      SandstoneAlertType.fullscreen => Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn)),

      SandstoneAlertType.overlay => Tween<Offset>(
        begin: startOffset,
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear)),
    };

    _controller.forward();

    if (widget.autoDismiss) {
      Future.delayed(widget.dismissAfter, () async {
        if (mounted) {
          await dismiss();
        }
      });
    }

    super.initState();
  }

  Future<void> dismiss() async {
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = DpadFocusScope(
      focusScopeNode: widget.focusScopeNode,
      parentNode: widget.parentNode,
      autofocus: widget.autofocus,
      canRequestFocus: widget.canRequestFocus,
      skipTraversal: widget.skipTraversal,
      rebuildOnFocusChange: widget.rebuildOnFocusChange,
      policy: widget.policy,
      descendantsAreFocusable: widget.descendantsAreFocusable,
      descendantsAreTraversable: widget.descendantsAreTraversable,
      includeSemantics: widget.includeSemantics,
      onUp: widget.onUp,
      onDown: widget.onDown,
      onLeft: widget.onLeft,
      onRight: widget.onRight,
      onSelect: widget.onSelect,
      onLongSelect: widget.onLongSelect,
      onBack: widget.onBack,
      onKeyEvent: widget.onKeyEvent,
      onFocusChanged: widget.onFocusChanged,
      onFocusDisabledWhenWasFocused: widget.onFocusDisabledWhenWasFocused,
      longPressDuration: widget.longPressDuration,
      builder: widget.builder,
    );

    return SafeArea(
      child: Align(
        alignment: switch (widget.type) {
          SandstoneAlertType.fullscreen => Alignment.center,
          SandstoneAlertType.overlay => Alignment.bottomCenter,
        },
        child: switch (widget.type) {
          SandstoneAlertType.fullscreen => FadeTransition(
            opacity: _animation as Animation<double>,
            child: child,
          ),
          SandstoneAlertType.overlay => SlideTransition(
            position: _animation as Animation<Offset>,
            child: child,
          ),
        },
      ),
    );
  }
}
