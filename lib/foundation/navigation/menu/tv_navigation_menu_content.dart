import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tv_plus/foundation/dpad/dpad.dart';

import '../../scroll/scroll_group_dpad_focus.dart';
import 'tv_navigation_menu_selection_entry.dart';
import 'tv_navigation_menu_item.dart';
import 'tv_navigation_menu_controller.dart';

final class TvNavigationMenuContent extends StatefulWidget {
  TvNavigationMenuContent({
    super.key,
    this.initialEntry,
    this.controller,
    this.header,
    this.footer,
    required this.constraints,
    this.itemsAlignment = MainAxisAlignment.center,
    required this.animateDrawerExpansion,
    this.drawerAnimationsDuration = const Duration(milliseconds: 300),
    required this.menuItems,
    this.separatorBuilder,
    FocusTraversalPolicy? policy,
    this.descendantsAreFocusable = true,
    this.descendantsAreTraversable = true,
    this.autofocus = false,
    this.onUp,
    this.onDown,
    this.onLeft,
    this.onRight,
    this.onFocusChanged,
    this.onFocusDisabledWhenWasFocused,
  }) : policy = policy ?? ReadingOrderTraversalPolicy();

  final TvNavigationMenuSelectionEntry? initialEntry;
  final TvNavigationMenuController? controller;
  final TvNavigationMenuItem? header;
  final TvNavigationMenuItem? footer;
  final BoxConstraints constraints;
  final MainAxisAlignment itemsAlignment;
  final bool animateDrawerExpansion;
  final Duration drawerAnimationsDuration;
  final List<TvNavigationMenuItem> menuItems;
  final Widget Function(int index)? separatorBuilder;
  final FocusTraversalPolicy policy;
  final bool descendantsAreFocusable;
  final bool descendantsAreTraversable;
  final bool autofocus;
  final ScrollGroupDpadEventCallback? onUp;
  final ScrollGroupDpadEventCallback? onDown;
  final ScrollGroupDpadEventCallback? onLeft;
  final ScrollGroupDpadEventCallback? onRight;
  final void Function(FocusScopeNode)? onFocusChanged;
  final void Function(FocusScopeNode)? onFocusDisabledWhenWasFocused;

  @override
  State<StatefulWidget> createState() => _TvNavigationMenuContentState();
}

final class _TvNavigationMenuContentState extends State<TvNavigationMenuContent>
    with DpadEvents {
  late TvNavigationMenuController _controller;
  var _ownsController = false;

  void _validateController(TvNavigationMenuController controller) {
    if (widget.header != null && controller.headerNode == null) {
      throw ArgumentError('Header was passed but focus node was not');
    }

    if (widget.footer != null && controller.footerNode == null) {
      throw ArgumentError('Footer was passed but focus node was not');
    }

    if (widget.menuItems.length != controller.itemsNodes.length) {
      throw ArgumentError('Menu items count does not match focus nodes count');
    }
  }

  @override
  void initState() {
    final passedController = widget.controller;
    final passedInitialEntry = widget.initialEntry;

    switch ((passedController, passedInitialEntry)) {
      case (null, null):
        throw ArgumentError(
          'Either controller or initialEntry must be provided',
        );

      case (final TvNavigationMenuController controller, _):
        _validateController(controller);
        _controller = controller;

      case (null, final TvNavigationMenuSelectionEntry entry):
        _controller = TvNavigationMenuController(
          initialEntry: entry,
          focusScopeNode: FocusScopeNode(),
          headerNode: widget.header == null ? null : FocusNode(),
          footerNode: widget.footer == null ? null : FocusNode(),
          itemsNodes: {
            for (final item in widget.menuItems) item.key: FocusNode(),
          },
        );
        _ownsController = true;
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant TvNavigationMenuContent oldWidget) {
    final passedController = widget.controller;

    if (passedController != null && oldWidget.controller != passedController) {
      _validateController(passedController);

      if (_ownsController) {
        _controller.dispose();
      }

      _controller = passedController;
      _ownsController = false;
    }

    if (widget.menuItems.length != oldWidget.menuItems.length &&
        _controller.itemsNodes.length != widget.menuItems.length) {
      throw ArgumentError(
        'Updated menu items count does not match focus nodes count. '
        'Recreate the controller with valid `itemsNodes` count.',
      );
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  KeyEventResult onUpEvent(FocusNode node, KeyDownEvent event) {
    if (widget.policy.inDirection(node, TraversalDirection.up)) {
      return widget.onUp?.call(node, event, false) ?? KeyEventResult.handled;
    }

    return widget.onUp?.call(node, event, true) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onDownEvent(FocusNode node, KeyDownEvent event) {
    if (widget.policy.inDirection(node, TraversalDirection.down)) {
      return widget.onDown?.call(node, event, false) ?? KeyEventResult.handled;
    }

    return widget.onDown?.call(node, event, true) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onLeftEvent(FocusNode node, KeyDownEvent event) {
    if (widget.policy.inDirection(node, TraversalDirection.left)) {
      return widget.onLeft?.call(node, event, false) ?? KeyEventResult.handled;
    }

    return widget.onLeft?.call(node, event, true) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onRightEvent(FocusNode node, KeyDownEvent event) {
    if (widget.policy.inDirection(node, TraversalDirection.right)) {
      return widget.onRight?.call(node, event, false) ?? KeyEventResult.handled;
    }

    return widget.onRight?.call(node, event, true) ?? KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final header = widget.header;
    final footer = widget.footer;

    return DpadFocusScope(
      focusScopeNode: _controller.focusScopeNode,
      autofocus: widget.autofocus,
      onUp: onUpEvent,
      onDown: onDownEvent,
      onLeft: onLeftEvent,
      onRight: onRightEvent,
      onFocusChanged: widget.onFocusChanged,
      onFocusDisabledWhenWasFocused: widget.onFocusDisabledWhenWasFocused,
      builder: (_) {
        return AnimatedContainer(
          duration: widget.drawerAnimationsDuration,
          constraints: widget.animateDrawerExpansion
              ? widget.constraints.copyWith(
                  maxWidth: _controller.hasFocus
                      ? null
                      : widget.constraints.minWidth,
                )
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (header != null)
                _Header(
                  controller: _controller,
                  drawerAutofocus: widget.autofocus,
                  drawerExpandDuration: widget.drawerAnimationsDuration,
                  isDrawerExpanded: _controller.hasFocus,
                  item: header,
                ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: widget.itemsAlignment,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final (index, child)
                          in widget.menuItems.indexed) ...[
                        if (index != 0) ?widget.separatorBuilder?.call(index),

                        _Item(
                          index: index,
                          item: child,
                          controller: _controller,
                          drawerAutofocus: widget.autofocus,
                          isDrawerExpanded: _controller.hasFocus,
                          drawerExpandDuration: widget.drawerAnimationsDuration,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              if (footer != null)
                _Footer(
                  item: footer,
                  controller: _controller,
                  drawerAutofocus: widget.autofocus,
                  isDrawerExpanded: _controller.hasFocus,
                  drawerExpandDuration: widget.drawerAnimationsDuration,
                ),
            ],
          ),
        );
      },
    );
  }
}

final class _Header extends StatelessWidget {
  const _Header({
    required this.controller,
    required this.drawerAutofocus,
    required this.drawerExpandDuration,
    required this.isDrawerExpanded,
    required this.item,
  });

  final TvNavigationMenuController controller;
  final bool drawerAutofocus;
  final Duration drawerExpandDuration;
  final bool isDrawerExpanded;
  final TvNavigationMenuItem item;

  @override
  Widget build(BuildContext context) {
    final entryKey = item.key;
    final entry = HeaderEntry(key: entryKey);
    final isSelected = controller.selectedEntry == entry;

    return _TvNavigationDrawerItem(
      item: item,
      focusNode: controller.headerNode!,
      isSelected: isSelected,
      isDrawerExpanded: isDrawerExpanded,
      drawerAnimationsDuration: drawerExpandDuration,
      autofocus: drawerAutofocus && isSelected,
      onSelect: (_, _) {
        controller.select(entry);
        item.onSelect?.call();
        return KeyEventResult.handled;
      },
    );
  }
}

final class _Item extends StatelessWidget {
  const _Item({
    required this.index,
    required this.item,
    required this.controller,
    required this.drawerAutofocus,
    required this.isDrawerExpanded,
    required this.drawerExpandDuration,
  });

  final int index;
  final TvNavigationMenuItem item;
  final TvNavigationMenuController controller;
  final bool drawerAutofocus;
  final bool isDrawerExpanded;
  final Duration drawerExpandDuration;

  @override
  Widget build(BuildContext context) {
    final entryKey = item.key;
    final entry = ItemEntry(key: entryKey);
    final isSelected = controller.selectedEntry == entry;

    return _TvNavigationDrawerItem(
      item: item,
      focusNode: controller.itemsNodes[entryKey]!,
      isSelected: isSelected,
      isDrawerExpanded: isDrawerExpanded,
      drawerAnimationsDuration: drawerExpandDuration,
      autofocus: drawerAutofocus && isSelected,
      onSelect: (_, _) {
        controller.select(entry);
        item.onSelect?.call();
        return KeyEventResult.handled;
      },
    );
  }
}

final class _Footer extends StatelessWidget {
  const _Footer({
    required this.item,
    required this.controller,
    required this.drawerAutofocus,
    required this.isDrawerExpanded,
    required this.drawerExpandDuration,
  });

  final TvNavigationMenuItem item;
  final TvNavigationMenuController controller;
  final bool drawerAutofocus;
  final bool isDrawerExpanded;
  final Duration drawerExpandDuration;

  @override
  Widget build(BuildContext context) {
    final entryKey = item.key;
    final entry = FooterEntry(key: entryKey);
    final isSelected = controller.selectedEntry == entry;

    return _TvNavigationDrawerItem(
      item: item,
      focusNode: controller.footerNode!,
      isSelected: isSelected,
      isDrawerExpanded: isDrawerExpanded,
      drawerAnimationsDuration: drawerExpandDuration,
      autofocus: drawerAutofocus && isSelected,
      onSelect: (_, _) {
        controller.select(entry);
        item.onSelect?.call();
        return KeyEventResult.handled;
      },
    );
  }
}

final class _TvNavigationDrawerItem extends StatelessWidget {
  const _TvNavigationDrawerItem({
    required this.item,
    required this.focusNode,
    this.isSelected = false,
    required this.isDrawerExpanded,
    required this.drawerAnimationsDuration,
    this.autofocus = false,
    this.onSelect,
  });

  final TvNavigationMenuItem item;
  final FocusNode focusNode;
  final bool isSelected;
  final bool isDrawerExpanded;
  final Duration drawerAnimationsDuration;
  final bool autofocus;
  final KeyEventResult Function(FocusNode, KeyDownEvent)? onSelect;

  @override
  Widget build(BuildContext context) {
    return ScrollGroupDpadFocus(
      focusNode: focusNode,
      autofocus: autofocus,
      onSelect: onSelect,
      key: item.key,
      builder: (node) {
        final Set<WidgetState> focusedState = node.hasFocus
            ? {WidgetState.focused}
            : {};

        final widgetState = isSelected
            ? {WidgetState.selected, ...focusedState}
            : focusedState;

        return AnimatedContainer(
          duration: drawerAnimationsDuration,
          padding: item.contentPadding,
          decoration: item.decoration.resolve(widgetState),
          child: Row(
            children: [
              Flexible(flex: 0, child: item.icon.resolve(widgetState)),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Padding(
                      padding: EdgeInsets.only(left: item.iconSpacing),
                      child: item.builder(context, constraints, widgetState),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
