import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import '../dpad/dpad_focus.dart';

typedef ScrollGroupDpadEventCallback =
    KeyEventResult Function(
      FocusNode node,
      KeyDownEvent event,
      bool isOutOfScope,
    );

final class ScrollGroupDpadFocus extends StatefulWidget {
  const ScrollGroupDpadFocus({
    super.key,
    this.focusNode,
    this.parentNode,
    this.autofocus = false,
    this.canRequestFocus = true,
    this.viewportAlignment = 0.5,
    this.upHandler,
    this.downHandler,
    this.leftHandler,
    this.rightHandler,
    this.onSelect,
    this.onBack,
    this.onFocusChanged,
    this.onFocusDisabledWhenWasFocused,
    this.scrollToNextNodeDuration,
    required this.builder,
  });

  final FocusNode? focusNode;
  final FocusNode? parentNode;
  final bool autofocus;
  final bool canRequestFocus;
  final double viewportAlignment;
  final ScrollGroupDpadEventHandler? upHandler;
  final ScrollGroupDpadEventHandler? downHandler;
  final ScrollGroupDpadEventHandler? leftHandler;
  final ScrollGroupDpadEventHandler? rightHandler;
  final DpadEventCallback? onSelect;
  final DpadEventCallback? onBack;
  final void Function(FocusNode)? onFocusChanged;
  final void Function()? onFocusDisabledWhenWasFocused;
  final Duration? scrollToNextNodeDuration;
  final Widget Function(FocusNode) builder;

  @override
  State<StatefulWidget> createState() => _ScrollGroupDpadFocusState();
}

final class _ScrollGroupDpadFocusState extends State<ScrollGroupDpadFocus> {
  late final FocusNode _focusNode;

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
      onUp: (node, event) =>
          _handleEvent(handler: widget.upHandler, node: node, event: event),
      onDown: (node, event) =>
          _handleEvent(handler: widget.downHandler, node: node, event: event),
      onLeft: (node, event) =>
          _handleEvent(handler: widget.leftHandler, node: node, event: event),
      onRight: (node, event) =>
          _handleEvent(handler: widget.rightHandler, node: node, event: event),
      onSelect: widget.onSelect,
      onBack: widget.onBack,
      onFocusChanged: (node) async {
        final context = node.context;

        if (context != null && node.hasFocus) {
          await Scrollable.ensureVisible(
            node.context!,
            alignment: widget.viewportAlignment,
            duration:
                widget.scrollToNextNodeDuration ??
                const Duration(milliseconds: 100),
          );
        }

        widget.onFocusChanged?.call(node);
      },
      onFocusDisabledWhenWasFocused: widget.onFocusDisabledWhenWasFocused,
      builder: (node) => widget.builder(node),
    );
  }

  KeyEventResult _handleEvent({
    required ScrollGroupDpadEventHandler? handler,
    required FocusNode node,
    required KeyDownEvent event,
  }) {
    if (handler == null) {
      return KeyEventResult.ignored;
    }

    final nextNode = handler.nextNode?..requestFocus();
    final nextContext = nextNode?.context;

    if (nextContext == null) {
      return handler.onEvent?.call(node, event) ?? KeyEventResult.ignored;
    }

    return handler.onEvent?.call(node, event) ?? KeyEventResult.handled;
  }
}

@immutable
final class ScrollGroupDpadEventHandler {
  const ScrollGroupDpadEventHandler({this.nextNode, this.onEvent});

  final FocusNode? nextNode;
  final DpadEventCallback? onEvent;
}
