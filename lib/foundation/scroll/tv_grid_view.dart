import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tv_plus/foundation/dpad/dpad.dart';
import 'package:tv_plus/foundation/scroll/scroll_group_dpad_focus.dart';
import 'package:tv_plus/foundation/scroll/types.dart';

final class TvGridView extends BoxScrollView with DpadEvents {
  TvGridView({
    super.key,
    super.scrollDirection,
    super.reverse,
    super.controller,
    super.primary,
    super.physics,
    super.shrinkWrap,
    super.padding,
    required this.gridDelegate,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    super.cacheExtent,
    List<ScrollGroupDpadFocus> children = const [],
    int? semanticChildCount,
    this.focusScopeNode,
    FocusTraversalPolicy? policy,
    this.descendantsAreFocusable = true,
    this.descendantsAreTraversable = true,
    this.autofocus = false,
    this.onUp,
    this.onDown,
    this.onLeft,
    this.onRight,
    super.dragStartBehavior,
    super.keyboardDismissBehavior,
    super.restorationId,
    super.clipBehavior,
    super.hitTestBehavior,
  }) : childrenDelegate = SliverChildListDelegate(
         children,
         addAutomaticKeepAlives: addAutomaticKeepAlives,
         addRepaintBoundaries: addRepaintBoundaries,
         addSemanticIndexes: addSemanticIndexes,
       ),
       policy = policy ?? ReadingOrderTraversalPolicy(),
       super(semanticChildCount: semanticChildCount ?? children.length);

  TvGridView.builder({
    super.key,
    super.scrollDirection,
    super.reverse,
    super.controller,
    super.primary,
    super.physics,
    super.shrinkWrap,
    super.padding,
    required this.gridDelegate,
    required TvScrollItemBuilder itemBuilder,
    int? Function(Key)? findChildIndexCallback,
    required int itemCount,
    this.focusScopeNode,
    FocusTraversalPolicy? policy,
    this.descendantsAreFocusable = true,
    this.descendantsAreTraversable = true,
    this.autofocus = false,
    this.onUp,
    this.onDown,
    this.onLeft,
    this.onRight,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    super.cacheExtent,
    int? semanticChildCount,
    super.dragStartBehavior,
    super.keyboardDismissBehavior,
    super.restorationId,
    super.clipBehavior,
    super.hitTestBehavior,
  }) : childrenDelegate = SliverChildBuilderDelegate(
         itemBuilder,
         findChildIndexCallback: findChildIndexCallback,
         childCount: itemCount,
         addAutomaticKeepAlives: addAutomaticKeepAlives,
         addRepaintBoundaries: addRepaintBoundaries,
         addSemanticIndexes: addSemanticIndexes,
       ),
       policy = policy ?? ReadingOrderTraversalPolicy(),
       super(semanticChildCount: semanticChildCount ?? itemCount);

  final SliverGridDelegate gridDelegate;
  final SliverChildDelegate childrenDelegate;
  final FocusScopeNode? focusScopeNode;
  final FocusTraversalPolicy policy;
  final bool descendantsAreFocusable;
  final bool descendantsAreTraversable;
  final bool autofocus;
  final ScrollGroupDpadEventCallback? onUp;
  final ScrollGroupDpadEventCallback? onDown;
  final ScrollGroupDpadEventCallback? onLeft;
  final ScrollGroupDpadEventCallback? onRight;

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
  Widget buildChildLayout(BuildContext context) {
    return SliverGrid(delegate: childrenDelegate, gridDelegate: gridDelegate);
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
      builder: (_) => super.build(context),
    );
  }
}
