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
    this.onOutOfScopeUp,
    this.onOutOfScopeDown,
    this.onOutOfScopeLeft,
    this.onOutOfScopeRight,
    this.onSelect,
    this.onBack,
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
    this.onOutOfScopeUp,
    this.onOutOfScopeDown,
    this.onOutOfScopeLeft,
    this.onOutOfScopeRight,
    this.onSelect,
    this.onBack,
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
  final DpadEventCallback? onOutOfScopeUp;
  final DpadEventCallback? onOutOfScopeDown;
  final DpadEventCallback? onOutOfScopeLeft;
  final DpadEventCallback? onOutOfScopeRight;
  final DpadEventCallback? onSelect;
  final DpadEventCallback? onBack;

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
      onSelect: onSelect,
      onBack: onBack,
      builder: (_) => super.build(context),
    );
  }
}
