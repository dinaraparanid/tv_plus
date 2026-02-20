part of 'scroll.dart';

final class ScrollGroupDpadFocus extends StatefulWidget {
  const ScrollGroupDpadFocus({
    super.key,
    this.focusNode,
    this.parentNode,
    this.autofocus = false,
    this.canRequestFocus = true,
    this.rebuildOnFocusChange = true,
    this.viewportAlignment = 0.5,
    this.onUp,
    this.onDown,
    this.onLeft,
    this.onRight,
    this.onSelect,
    this.onBack,
    this.onKeyEvent,
    this.onFocusChanged,
    this.onFocusDisabledWhenWasFocused,
    this.scrollToNextNodeDuration,
    required this.builder,
  });

  final FocusNode? focusNode;
  final FocusNode? parentNode;
  final bool autofocus;
  final bool canRequestFocus;
  final bool rebuildOnFocusChange;
  final double? viewportAlignment;
  final DpadEventCallback? onUp;
  final DpadEventCallback? onDown;
  final DpadEventCallback? onLeft;
  final DpadEventCallback? onRight;
  final DpadEventCallback? onSelect;
  final DpadEventCallback? onBack;
  final KeyEventResult Function(FocusNode, KeyEvent)? onKeyEvent;
  final void Function(FocusNode, bool)? onFocusChanged;
  final void Function()? onFocusDisabledWhenWasFocused;
  final Duration? scrollToNextNodeDuration;
  final Widget Function(BuildContext, FocusNode) builder;

  @override
  State<StatefulWidget> createState() => _ScrollGroupDpadFocusState();
}

final class _ScrollGroupDpadFocusState extends State<ScrollGroupDpadFocus> {
  late FocusNode _focusNode;

  bool ownsFocusNode = false;

  @override
  void initState() {
    _focusNode =
        widget.focusNode ?? FocusNode(canRequestFocus: widget.canRequestFocus);

    ownsFocusNode = widget.focusNode == null;

    super.initState();
  }

  @override
  void didUpdateWidget(covariant ScrollGroupDpadFocus oldWidget) {
    if (widget.canRequestFocus != oldWidget.canRequestFocus) {
      if (_focusNode.hasFocus && widget.canRequestFocus == false) {
        widget.onFocusDisabledWhenWasFocused?.call();
      }

      _focusNode.canRequestFocus = widget.canRequestFocus;
    }

    final nextFocusNode = widget.focusNode;

    if (nextFocusNode != _focusNode && nextFocusNode != null) {
      if (ownsFocusNode) {
        _focusNode.dispose();
      }

      _focusNode = nextFocusNode..canRequestFocus = widget.canRequestFocus;

      ownsFocusNode = false;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (ownsFocusNode) {
      _focusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DpadFocus(
      focusNode: _focusNode,
      parentNode: widget.parentNode,
      autofocus: widget.autofocus,
      canRequestFocus: widget.canRequestFocus,
      rebuildOnFocusChange: widget.rebuildOnFocusChange,
      onUp: widget.onUp,
      onDown: widget.onDown,
      onLeft: widget.onLeft,
      onRight: widget.onRight,
      onSelect: widget.onSelect,
      onBack: widget.onBack,
      onKeyEvent: widget.onKeyEvent,
      onFocusChanged: (node, hasFocus) async {
        final viewportAlignment = widget.viewportAlignment;

        if (viewportAlignment != null) {
          final context = node.context;
          final obj = context?.findRenderObject();
          final box = obj is RenderBox ? obj : null;
          final hasSize = box?.hasSize ?? true;

          if (context != null && hasSize && hasFocus) {
            await Scrollable.ensureVisible(
              node.context!,
              alignment: viewportAlignment,
              duration:
                  widget.scrollToNextNodeDuration ??
                  const Duration(milliseconds: 100),
            );
          }
        }

        widget.onFocusChanged?.call(node, node.hasFocus);
      },
      onFocusDisabledWhenWasFocused: widget.onFocusDisabledWhenWasFocused,
      builder: (context, node) => widget.builder(context, node),
    );
  }
}
