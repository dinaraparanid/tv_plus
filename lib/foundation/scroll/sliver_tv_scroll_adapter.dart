import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tv_plus/foundation/dpad/dpad.dart';

final class SliverTVScrollAdapter extends StatelessWidget with DpadEvents {
  SliverTVScrollAdapter({
    super.key,
    this.focusScopeNode,
    FocusTraversalPolicy? policy,
    this.descendantsAreFocusable = true,
    this.descendantsAreTraversable = true,
    this.autofocus = false,
    this.onOutOfScopeUp,
    this.onOutOfScopeDown,
    this.onOutOfScopeLeft,
    this.onOutOfScopeRight,
    required this.sliver,
  }) : policy = policy ?? ReadingOrderTraversalPolicy();

  final FocusScopeNode? focusScopeNode;
  final FocusTraversalPolicy policy;
  final bool descendantsAreFocusable;
  final bool descendantsAreTraversable;
  final bool autofocus;
  final DpadEventCallback? onOutOfScopeUp;
  final DpadEventCallback? onOutOfScopeDown;
  final DpadEventCallback? onOutOfScopeLeft;
  final DpadEventCallback? onOutOfScopeRight;
  final Widget sliver;

  @override
  KeyEventResult onUpEvent(FocusNode node, KeyDownEvent event) {
    if (policy.inDirection(node, TraversalDirection.up)) {
      return KeyEventResult.handled;
    }

    return onOutOfScopeUp?.call(node, event) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onDownEvent(FocusNode node, KeyDownEvent event) {
    if (policy.inDirection(node, TraversalDirection.down)) {
      return KeyEventResult.handled;
    }

    return onOutOfScopeDown?.call(node, event) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onLeftEvent(FocusNode node, KeyDownEvent event) {
    if (policy.inDirection(node, TraversalDirection.left)) {
      return KeyEventResult.handled;
    }

    return onOutOfScopeLeft?.call(node, event) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onRightEvent(FocusNode node, KeyDownEvent event) {
    if (policy.inDirection(node, TraversalDirection.right)) {
      return KeyEventResult.handled;
    }

    return onOutOfScopeRight?.call(node, event) ?? KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return DpadFocusScope(
      focusScopeNode: focusScopeNode,
      autofocus: autofocus,
      onUp: onUpEvent,
      onDown: onDownEvent,
      onLeft: onLeftEvent,
      onRight: onRightEvent,
      includeSemantics: false,
      builder: (_) => sliver,
    );
  }
}
