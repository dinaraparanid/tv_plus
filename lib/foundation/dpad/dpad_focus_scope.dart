import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tv_plus/foundation/dpad/dpad.dart';

final class DpadFocusScope extends StatefulWidget {
  const DpadFocusScope({
    super.key,
    this.focusScopeNode,
    this.parentNode,
    this.autofocus = false,
    this.canRequestFocus = true,
    this.skipTraversal,
    this.rebuildOnFocusChange = true,
    this.policy,
    this.descendantsAreFocusable = true,
    this.descendantsAreTraversable = true,
    this.includeSemantics = true,
    this.onUp,
    this.onDown,
    this.onLeft,
    this.onRight,
    this.onSelect,
    this.onBack,
    this.onKeyEvent,
    this.onFocusChanged,
    this.onFocusDisabledWhenWasFocused,
    required this.builder,
  });

  final FocusScopeNode? focusScopeNode;
  final FocusNode? parentNode;
  final bool autofocus;
  final bool canRequestFocus;
  final bool? skipTraversal;
  final bool rebuildOnFocusChange;
  final FocusTraversalPolicy? policy;
  final bool descendantsAreFocusable;
  final bool descendantsAreTraversable;
  final bool includeSemantics;
  final DpadEventCallback? onUp;
  final DpadEventCallback? onDown;
  final DpadEventCallback? onLeft;
  final DpadEventCallback? onRight;
  final DpadEventCallback? onSelect;
  final DpadEventCallback? onBack;
  final KeyEventResult Function(FocusNode, KeyEvent)? onKeyEvent;
  final void Function(FocusScopeNode, bool)? onFocusChanged;
  final void Function(FocusScopeNode)? onFocusDisabledWhenWasFocused;
  final Widget Function(FocusScopeNode) builder;

  @override
  State<StatefulWidget> createState() => _DpadFocusScopeState();
}

final class _DpadFocusScopeState extends State<DpadFocusScope> with DpadEvents {
  late FocusScopeNode _focusScopeNode;

  bool _ownsFocusNode = false;
  bool _canRequestFocus = false;
  bool _hasFocus = false;

  @override
  void initState() {
    _focusScopeNode =
        widget.focusScopeNode ??
        FocusScopeNode(canRequestFocus: widget.canRequestFocus);

    _focusScopeNode.addListener(_focusListener);

    _ownsFocusNode = widget.focusScopeNode == null;
    _canRequestFocus = _focusScopeNode.canRequestFocus;
    _hasFocus = _focusScopeNode.hasFocus;

    super.initState();
  }

  @override
  void didUpdateWidget(covariant DpadFocusScope oldWidget) {
    if (widget.canRequestFocus != oldWidget.canRequestFocus) {
      _focusScopeNode.canRequestFocus = widget.canRequestFocus;
    }

    final nextFocusNode = widget.focusScopeNode;

    if (nextFocusNode != _focusScopeNode && nextFocusNode != null) {
      _focusScopeNode.removeListener(_focusListener);

      if (_ownsFocusNode) {
        _focusScopeNode.dispose();
      }

      _focusScopeNode = nextFocusNode
        ..canRequestFocus = widget.canRequestFocus
        ..addListener(_focusListener);

      _ownsFocusNode = false;
      _canRequestFocus = _focusScopeNode.canRequestFocus;
      _hasFocus = _focusScopeNode.hasFocus;
    }

    super.didUpdateWidget(oldWidget);
  }

  void _focusListener() {
    if (_canRequestFocus != _focusScopeNode.canRequestFocus) {
      if (_hasFocus && !_focusScopeNode.canRequestFocus) {
        widget.onFocusDisabledWhenWasFocused?.call(_focusScopeNode);
      }
    }

    _hasFocus = _focusScopeNode.hasFocus;
    _canRequestFocus = _focusScopeNode.canRequestFocus;
  }

  @override
  void dispose() {
    _focusScopeNode.removeListener(_focusListener);

    if (_ownsFocusNode) {
      _focusScopeNode.dispose();
    }

    super.dispose();
  }

  @override
  KeyEventResult onUpEvent(FocusNode node, KeyDownEvent event) {
    return widget.onUp?.call(node, event) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onDownEvent(FocusNode node, KeyDownEvent event) {
    return widget.onDown?.call(node, event) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onLeftEvent(FocusNode node, KeyDownEvent event) {
    return widget.onLeft?.call(node, event) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onRightEvent(FocusNode node, KeyDownEvent event) {
    return widget.onRight?.call(node, event) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onSelectEvent(FocusNode node, KeyDownEvent event) {
    return widget.onSelect?.call(node, event) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onBackEvent(FocusNode node, KeyDownEvent event) {
    return widget.onBack?.call(node, event) ?? KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: widget.policy,
      descendantsAreFocusable: widget.descendantsAreFocusable,
      descendantsAreTraversable: widget.descendantsAreTraversable,
      child: FocusScope(
        node: _focusScopeNode,
        parentNode: widget.parentNode,
        canRequestFocus: widget.canRequestFocus,
        autofocus: widget.autofocus,
        includeSemantics: widget.includeSemantics,
        onFocusChange: (isFocused) {
          if (widget.rebuildOnFocusChange) {
            setState(() {});
          }

          widget.onFocusChanged?.call(_focusScopeNode, isFocused);
        },
        onKeyEvent: (node, event) {
          return switch (event) {
            KeyDownEvent(logicalKey: LogicalKeyboardKey.arrowUp) => onUpEvent(
              node,
              event,
            ),

            KeyDownEvent(logicalKey: LogicalKeyboardKey.arrowDown) =>
              onDownEvent(node, event),

            KeyDownEvent(logicalKey: LogicalKeyboardKey.arrowLeft) =>
              onLeftEvent(node, event),

            KeyDownEvent(logicalKey: LogicalKeyboardKey.arrowRight) =>
              onRightEvent(node, event),

            KeyDownEvent(logicalKey: LogicalKeyboardKey.select) =>
              onSelectEvent(node, event),

            KeyDownEvent(logicalKey: LogicalKeyboardKey.goBack) => onBackEvent(
              node,
              event,
            ),

            _ => widget.onKeyEvent?.call(node, event) ?? KeyEventResult.ignored,
          };
        },
        child: widget.builder(_focusScopeNode),
      ),
    );
  }
}
