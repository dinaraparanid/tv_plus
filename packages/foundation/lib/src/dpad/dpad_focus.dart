part of 'dpad.dart';

typedef DpadEventCallback = KeyEventResult Function(FocusNode, KeyEvent);

final class DpadFocus extends StatefulWidget {
  const DpadFocus({
    super.key,
    this.focusNode,
    this.parentNode,
    this.autofocus = false,
    this.canRequestFocus = true,
    this.skipTraversal,
    this.rebuildOnFocusChange = true,
    this.onUp,
    this.onDown,
    this.onLeft,
    this.onRight,
    this.onSelect,
    this.onLongSelect,
    this.onBack,
    this.onKeyEvent,
    this.onFocusChanged,
    this.onFocusDisabledWhenWasFocused,
    this.longPressDuration = kLongPressTimeout,
    required this.builder,
  });

  final FocusNode? focusNode;
  final FocusNode? parentNode;
  final bool autofocus;
  final bool canRequestFocus;
  final bool? skipTraversal;
  final bool rebuildOnFocusChange;
  final DpadEventCallback? onUp;
  final DpadEventCallback? onDown;
  final DpadEventCallback? onLeft;
  final DpadEventCallback? onRight;
  final DpadEventCallback? onSelect;
  final DpadEventCallback? onLongSelect;
  final DpadEventCallback? onBack;
  final KeyEventResult Function(FocusNode, KeyEvent)? onKeyEvent;
  final void Function(FocusNode, bool)? onFocusChanged;
  final void Function()? onFocusDisabledWhenWasFocused;
  final Duration longPressDuration;
  final Widget Function(BuildContext, FocusNode) builder;

  @override
  State<StatefulWidget> createState() => _DpadFocusState();
}

final class _DpadFocusState extends State<DpadFocus> with DpadEvents {
  late FocusNode _focusNode;

  bool _ownsFocusNode = false;
  bool _canRequestFocus = false;
  bool _hasFocus = false;

  Duration? _lastSelectEventStartTimestamp;

  @override
  void initState() {
    _focusNode =
        widget.focusNode ?? FocusNode(canRequestFocus: widget.canRequestFocus);

    _focusNode.addListener(_focusListener);

    _ownsFocusNode = widget.focusNode == null;
    _canRequestFocus = _focusNode.canRequestFocus;
    _hasFocus = _focusNode.hasFocus;

    super.initState();
  }

  @override
  void didUpdateWidget(covariant DpadFocus oldWidget) {
    if (widget.canRequestFocus != oldWidget.canRequestFocus) {
      _focusNode.canRequestFocus = widget.canRequestFocus;
    }

    final nextFocusNode = widget.focusNode;

    if (nextFocusNode != _focusNode && nextFocusNode != null) {
      _focusNode.removeListener(_focusListener);

      if (_ownsFocusNode) {
        _focusNode.dispose();
      }

      _focusNode = nextFocusNode
        ..canRequestFocus = widget.canRequestFocus
        ..addListener(_focusListener);

      _ownsFocusNode = false;
      _canRequestFocus = _focusNode.canRequestFocus;
      _hasFocus = _focusNode.hasFocus;
    }

    super.didUpdateWidget(oldWidget);
  }

  void _focusListener() {
    if (_canRequestFocus != _focusNode.canRequestFocus) {
      if (_hasFocus && !_focusNode.canRequestFocus) {
        widget.onFocusDisabledWhenWasFocused?.call();
      }
    }

    _hasFocus = _focusNode.hasFocus;
    _canRequestFocus = _focusNode.canRequestFocus;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusListener);

    if (_ownsFocusNode) {
      _focusNode.dispose();
    }

    super.dispose();
  }

  @override
  KeyEventResult onUpEvent(FocusNode node, KeyEvent event) {
    return widget.onUp?.call(node, event) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onDownEvent(FocusNode node, KeyEvent event) {
    return widget.onDown?.call(node, event) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onLeftEvent(FocusNode node, KeyEvent event) {
    return widget.onLeft?.call(node, event) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onRightEvent(FocusNode node, KeyEvent event) {
    return widget.onRight?.call(node, event) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onSelectStartEvent(FocusNode node, KeyEvent event) {
    if (widget.onLongSelect == null) {
      return KeyEventResult.ignored;
    }

    _lastSelectEventStartTimestamp = event.timeStamp;

    Future.delayed(widget.longPressDuration, () {
      if (_lastSelectEventStartTimestamp == event.timeStamp) {
        widget.onLongSelect?.call(node, event);
      }
    });

    return KeyEventResult.handled;
  }

  @override
  KeyEventResult onSelectEndEvent(FocusNode node, KeyEvent event) {
    _lastSelectEventStartTimestamp = null;
    return widget.onSelect?.call(node, event) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onBackEvent(FocusNode node, KeyEvent event) {
    return widget.onBack?.call(node, event) ?? KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      parentNode: widget.parentNode,
      canRequestFocus: widget.canRequestFocus,
      skipTraversal: widget.skipTraversal,
      autofocus: widget.autofocus,
      onFocusChange: (isFocused) {
        if (widget.rebuildOnFocusChange) {
          setState(() {});
        }

        widget.onFocusChanged?.call(_focusNode, isFocused);
      },
      onKeyEvent: (node, event) {
        return switch (event) {
          KeyDownEvent(logicalKey: LogicalKeyboardKey.arrowUp) => onUpEvent(
            node,
            event,
          ),

          KeyDownEvent(logicalKey: LogicalKeyboardKey.arrowDown) => onDownEvent(
            node,
            event,
          ),

          KeyDownEvent(logicalKey: LogicalKeyboardKey.arrowLeft) => onLeftEvent(
            node,
            event,
          ),

          KeyDownEvent(logicalKey: LogicalKeyboardKey.arrowRight) =>
            onRightEvent(node, event),

          KeyDownEvent(
            logicalKey: LogicalKeyboardKey.select || LogicalKeyboardKey.enter,
          ) =>
            onSelectStartEvent(node, event),

          KeyUpEvent(
            logicalKey: LogicalKeyboardKey.select || LogicalKeyboardKey.enter,
          ) =>
            onSelectEndEvent(node, event),

          KeyDownEvent(logicalKey: LogicalKeyboardKey.goBack) => onBackEvent(
            node,
            event,
          ),

          _ => widget.onKeyEvent?.call(node, event) ?? KeyEventResult.ignored,
        };
      },
      child: Builder(builder: (context) => widget.builder(context, _focusNode)),
    );
  }
}
