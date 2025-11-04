import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

typedef DpadEventCallback = KeyEventResult Function(FocusNode, KeyDownEvent);

final class DpadFocus extends StatefulWidget {
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
}

final class _DpadFocusState extends State<DpadFocus> {
  late final FocusNode _focusNode;

  bool ownsFocusNode = false;

  @override
  void initState() {
    _focusNode = widget.focusNode ??
        FocusNode(canRequestFocus: widget.canRequestFocus);

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

      _focusNode = nextFocusNode
        ..canRequestFocus = widget.canRequestFocus;

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
          KeyDownEvent() when event.logicalKey ==
              LogicalKeyboardKey.arrowUp =>
          widget.onUp?.call(_focusNode, event) ?? KeyEventResult.ignored,

          KeyDownEvent() when event.logicalKey ==
              LogicalKeyboardKey.arrowDown =>
          widget.onDown?.call(_focusNode, event) ?? KeyEventResult.ignored,

          KeyDownEvent() when event.logicalKey ==
              LogicalKeyboardKey.arrowLeft =>
          widget.onLeft?.call(_focusNode, event) ?? KeyEventResult.ignored,

          KeyDownEvent() when event.logicalKey ==
              LogicalKeyboardKey.arrowRight =>
          widget.onRight?.call(_focusNode, event) ?? KeyEventResult.ignored,

          KeyDownEvent() when event.logicalKey ==
              LogicalKeyboardKey.select =>
          widget.onSelect?.call(_focusNode, event) ?? KeyEventResult.ignored,

          KeyDownEvent() when event.logicalKey ==
              LogicalKeyboardKey.goBack =>
          widget.onBack?.call(_focusNode, event) ?? KeyEventResult.ignored,

          _ => KeyEventResult.ignored
        };
      },
      child: widget.builder(_focusNode),
    );
  }
}
