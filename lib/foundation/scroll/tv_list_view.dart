import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:tv_plus/foundation/scroll/scroll_group_dpad_focus.dart';
import 'package:tv_plus/foundation/scroll/types.dart';

import '../dpad/dpad.dart';

final class TvListView extends BoxScrollView with DpadEvents {
  TvListView({
    super.key,
    super.scrollDirection,
    super.reverse,
    super.controller,
    super.primary,
    super.physics,
    super.shrinkWrap,
    super.padding,
    this.itemExtent,
    this.itemExtentBuilder,
    this.prototypeItem,
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

  TvListView.builder({
    super.key,
    super.scrollDirection,
    super.reverse,
    super.controller,
    super.primary,
    super.physics,
    super.shrinkWrap,
    super.padding,
    this.itemExtent,
    this.itemExtentBuilder,
    this.prototypeItem,
    required TvScrollItemBuilder itemBuilder,
    int? Function(Key)? findChildIndexCallback,
    required Widget Function(BuildContext, int) separatorBuilder,
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

  TvListView.separated({
    super.key,
    super.scrollDirection,
    super.reverse,
    super.controller,
    super.primary,
    super.physics,
    super.shrinkWrap,
    super.padding,
    required TvScrollItemBuilder itemBuilder,
    int? Function(Key)? findChildIndexCallback,
    required Widget Function(BuildContext, int) separatorBuilder,
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
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    super.cacheExtent,
    super.dragStartBehavior,
    super.keyboardDismissBehavior,
    super.restorationId,
    super.clipBehavior,
    super.hitTestBehavior,
  }) : itemExtent = null,
       itemExtentBuilder = null,
       prototypeItem = null,
       policy = policy ?? ReadingOrderTraversalPolicy(),
       childrenDelegate = SliverChildBuilderDelegate(
         (context, index) {
           final int itemIndex = index ~/ 2;

           if (index.isEven) {
             return itemBuilder(context, itemIndex);
           }

           return separatorBuilder(context, itemIndex);
         },
         findChildIndexCallback: findChildIndexCallback,
         childCount: _computeActualChildCount(itemCount),
         addAutomaticKeepAlives: addAutomaticKeepAlives,
         addRepaintBoundaries: addRepaintBoundaries,
         addSemanticIndexes: addSemanticIndexes,
         semanticIndexCallback: (widget, index) =>
             index.isEven ? index ~/ 2 : null,
       );

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
  final double? itemExtent;
  final ItemExtentBuilder? itemExtentBuilder;
  final Widget? prototypeItem;

  static int _computeActualChildCount(int itemCount) {
    return max(0, itemCount * 2 - 1);
  }

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
    if (itemExtent != null) {
      return SliverFixedExtentList(
        delegate: childrenDelegate,
        itemExtent: itemExtent!,
      );
    }

    if (itemExtentBuilder != null) {
      return SliverVariedExtentList(
        delegate: childrenDelegate,
        itemExtentBuilder: itemExtentBuilder!,
      );
    }

    if (prototypeItem != null) {
      return SliverPrototypeExtentList(
        delegate: childrenDelegate,
        prototypeItem: prototypeItem!,
      );
    }

    return SliverList(delegate: childrenDelegate);
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
