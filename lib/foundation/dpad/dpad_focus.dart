import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'dpad_events.dart';

typedef DpadEventCallback = KeyEventResult Function(FocusNode, KeyDownEvent);

final class DpadFocus extends StatefulWidget with DpadEvents {
  const DpadFocus({
    super.key,
    this.focusNode,
    this.parentNode,
    this.autofocus = false,
    this.canRequestFocus = true,
    this.onUp,
    this.onDown,
    this.onLeft,
    this.onRight,
    this.onSelect,
    this.onBack,
    this.onFocusChanged,
    this.onFocusDisabledWhenWasFocused,
    required this.builder,
  });

  final FocusNode? focusNode;
  final FocusNode? parentNode;
  final bool autofocus;
  final bool canRequestFocus;
  final DpadEventCallback? onUp;
  final DpadEventCallback? onDown;
  final DpadEventCallback? onLeft;
  final DpadEventCallback? onRight;
  final DpadEventCallback? onSelect;
  final DpadEventCallback? onBack;
  final void Function(FocusNode)? onFocusChanged;
  final void Function()? onFocusDisabledWhenWasFocused;
  final Widget Function(FocusNode) builder;

  @override
  State<StatefulWidget> createState() => _DpadFocusState();

  @override
  KeyEventResult onUpEvent(FocusNode node, KeyDownEvent event) {
    return onUp?.call(node, event) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onDownEvent(FocusNode node, KeyDownEvent event) {
    return onDown?.call(node, event) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onLeftEvent(FocusNode node, KeyDownEvent event) {
    return onLeft?.call(node, event) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onRightEvent(FocusNode node, KeyDownEvent event) {
    return onRight?.call(node, event) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onSelectEvent(FocusNode node, KeyDownEvent event) {
    return onSelect?.call(node, event) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onBackEvent(FocusNode node, KeyDownEvent event) {
    return onBack?.call(node, event) ?? KeyEventResult.ignored;
  }
}

final class _DpadFocusState extends State<DpadFocus> {
  late FocusNode _focusNode;

  bool ownsFocusNode = false;

  @override
  void initState() {
    _focusNode =
        widget.focusNode ?? FocusNode(canRequestFocus: widget.canRequestFocus);

    _focusNode.addListener(onFocusChange);

    ownsFocusNode = widget.focusNode == null;

    super.initState();
  }

  @override
  void didUpdateWidget(covariant DpadFocus oldWidget) {
    if (widget.canRequestFocus != oldWidget.canRequestFocus) {
      if (_focusNode.hasFocus && widget.canRequestFocus == false) {
        widget.onFocusDisabledWhenWasFocused?.call();
      }

      _focusNode.canRequestFocus = widget.canRequestFocus;
    }

    final nextFocusNode = widget.focusNode;

    if (nextFocusNode != _focusNode && nextFocusNode != null) {
      _focusNode.removeListener(onFocusChange);

      if (ownsFocusNode) {
        _focusNode.dispose();
      }

      _focusNode = nextFocusNode..canRequestFocus = widget.canRequestFocus;

      _focusNode.addListener(onFocusChange);

      ownsFocusNode = false;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _focusNode.removeListener(onFocusChange);

    if (ownsFocusNode) {
      _focusNode.dispose();
    }

    super.dispose();
  }

  void onFocusChange() {
    setState(() {});
    widget.onFocusChanged?.call(_focusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      parentNode: widget.parentNode,
      canRequestFocus: widget.canRequestFocus,
      autofocus: widget.autofocus,
      onKeyEvent: (node, event) {
        return switch (event) {
          KeyDownEvent() when event.logicalKey == LogicalKeyboardKey.arrowUp =>
            widget.onUpEvent(node, event),

          KeyDownEvent()
              when event.logicalKey == LogicalKeyboardKey.arrowDown =>
            widget.onDownEvent(node, event),

          KeyDownEvent()
              when event.logicalKey == LogicalKeyboardKey.arrowLeft =>
            widget.onLeftEvent(node, event),

          KeyDownEvent()
              when event.logicalKey == LogicalKeyboardKey.arrowRight =>
            widget.onRightEvent(node, event),

          KeyDownEvent() when event.logicalKey == LogicalKeyboardKey.select =>
            widget.onSelectEvent(node, event),

          KeyDownEvent() when event.logicalKey == LogicalKeyboardKey.goBack =>
            widget.onBackEvent(node, event),

          _ => KeyEventResult.ignored,
        };
      },
      child: widget.builder(_focusNode),
    );
  }
}
