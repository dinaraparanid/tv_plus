import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tv_plus/foundation/foundation.dart';

final class SliverTVScrollAdapter extends StatelessWidget with DpadEvents {
  SliverTVScrollAdapter({
    super.key,
    this.focusScopeNode,
    FocusTraversalPolicy? policy,
    this.descendantsAreFocusable = true,
    this.descendantsAreTraversable = true,
    this.autofocus = false,
    this.onUp,
    this.onDown,
    this.onLeft,
    this.onRight,
    required this.sliver,
  }) : policy = policy ?? ReadingOrderTraversalPolicy();

  final FocusScopeNode? focusScopeNode;
  final FocusTraversalPolicy policy;
  final bool descendantsAreFocusable;
  final bool descendantsAreTraversable;
  final bool autofocus;
  final ScrollGroupDpadEventCallback? onUp;
  final ScrollGroupDpadEventCallback? onDown;
  final ScrollGroupDpadEventCallback? onLeft;
  final ScrollGroupDpadEventCallback? onRight;
  final Widget sliver;

  @override
  KeyEventResult onUpEvent(FocusNode node, KeyDownEvent event) {
    if (policy.inDirection(node, TraversalDirection.up)) {
      return onUp?.call(node, event, false) ?? KeyEventResult.handled;
    }

    return onUp?.call(node, event, true) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onDownEvent(FocusNode node, KeyDownEvent event) {
    if (policy.inDirection(node, TraversalDirection.down)) {
      return onDown?.call(node, event, false) ?? KeyEventResult.handled;
    }

    return onDown?.call(node, event, true) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onLeftEvent(FocusNode node, KeyDownEvent event) {
    if (policy.inDirection(node, TraversalDirection.left)) {
      return onLeft?.call(node, event, false) ?? KeyEventResult.handled;
    }

    return onLeft?.call(node, event, true) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onRightEvent(FocusNode node, KeyDownEvent event) {
    if (policy.inDirection(node, TraversalDirection.right)) {
      return onRight?.call(node, event, false) ?? KeyEventResult.handled;
    }

    return onRight?.call(node, event, true) ?? KeyEventResult.ignored;
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
