part of 'menu.dart';

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
    this.viewportAlignment = 0.5,
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
  final double? viewportAlignment;
  final DpadScopeEventCallback? onUp;
  final DpadScopeEventCallback? onDown;
  final DpadScopeEventCallback? onLeft;
  final DpadScopeEventCallback? onRight;
  final void Function(FocusScopeNode, bool)? onFocusChanged;
  final void Function(FocusScopeNode)? onFocusDisabledWhenWasFocused;

  @override
  State<StatefulWidget> createState() => _TvNavigationMenuContentState();
}

final class _TvNavigationMenuContentState
    extends State<TvNavigationMenuContent> {
  late TvNavigationMenuController _controller;
  var _ownsController = false;

  void _patchController(TvNavigationMenuController controller) {
    if (widget.header != null && controller.headerNode == null) {
      controller._headerNode = FocusNode();
    }

    if (widget.footer != null && controller.footerNode == null) {
      controller._footerNode = FocusNode();
    }

    if (widget.menuItems.length != controller.itemsNodes.length) {
      final patchedNodes = widget.menuItems.indexed.map((indexedItem) {
        final (index, item) = indexedItem;
        final key = item.key ?? ValueKey(index);
        final node = controller.itemsNodes[key] ?? FocusNode();
        return (key, node);
      });

      controller._itemsNodes = {
        for (final (key, node) in patchedNodes) key: node,
      };
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
        _patchController(controller);
        _controller = controller;

      case (null, final TvNavigationMenuSelectionEntry entry):
        _controller = TvNavigationMenuController(
          initialEntry: entry,
          headerNode: widget.header == null ? null : FocusNode(),
          footerNode: widget.footer == null ? null : FocusNode(),
          itemsNodes: {
            for (final (index, item) in widget.menuItems.indexed)
              (item.key ?? ValueKey(index)): FocusNode(),
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
      if (_ownsController) {
        _controller.dispose();
      }

      _patchController(passedController);
      _controller = passedController;
      _ownsController = false;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final header = widget.header;
    final footer = widget.footer;

    return DpadFocusScope(
      focusScopeNode: _controller._focusScopeNode,
      autofocus: widget.autofocus,
      rebuildOnFocusChange: true,
      policy: widget.policy,
      descendantsAreFocusable: widget.descendantsAreFocusable,
      descendantsAreTraversable: widget.descendantsAreTraversable,
      onUp: widget.onUp,
      onDown: widget.onDown,
      onLeft: widget.onLeft,
      onRight: widget.onRight,
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: widget.itemsAlignment,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (header != null)
                  _Header(
                    controller: _controller,
                    drawerAutofocus: widget.autofocus,
                    drawerExpandDuration: widget.drawerAnimationsDuration,
                    isDrawerExpanded: _controller.hasFocus,
                    item: header,
                    viewportAlignment: widget.viewportAlignment,
                  ),

                for (final (index, child) in widget.menuItems.indexed) ...[
                  if (index != 0) ?widget.separatorBuilder?.call(index),

                  _Item(
                    index: index,
                    item: child,
                    controller: _controller,
                    drawerAutofocus: widget.autofocus,
                    isDrawerExpanded: _controller.hasFocus,
                    drawerExpandDuration: widget.drawerAnimationsDuration,
                    viewportAlignment: widget.viewportAlignment,
                  ),
                ],

                if (footer != null)
                  _Footer(
                    item: footer,
                    controller: _controller,
                    drawerAutofocus: widget.autofocus,
                    isDrawerExpanded: _controller.hasFocus,
                    drawerExpandDuration: widget.drawerAnimationsDuration,
                    viewportAlignment: widget.viewportAlignment,
                  ),
              ],
            ),
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
    required this.viewportAlignment,
    required this.item,
  });

  final TvNavigationMenuController controller;
  final bool drawerAutofocus;
  final Duration drawerExpandDuration;
  final bool isDrawerExpanded;
  final double? viewportAlignment;
  final TvNavigationMenuItem item;

  @override
  Widget build(BuildContext context) {
    final entry = const HeaderEntry();
    final isSelected = controller.selectedEntry == entry;

    return _TvNavigationDrawerItem(
      item: item,
      focusNode: controller.headerNode!,
      canRequestFocus: item.canRequestFocus,
      isSelected: isSelected,
      isDrawerExpanded: isDrawerExpanded,
      drawerAnimationsDuration: drawerExpandDuration,
      autofocus: drawerAutofocus && isSelected,
      viewportAlignment: viewportAlignment,
      onSelect: (_, _) {
        if (!item.isSelectable) {
          return KeyEventResult.ignored;
        }

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
    required this.viewportAlignment,
  });

  final int index;
  final TvNavigationMenuItem item;
  final TvNavigationMenuController controller;
  final bool drawerAutofocus;
  final bool isDrawerExpanded;
  final Duration drawerExpandDuration;
  final double? viewportAlignment;

  @override
  Widget build(BuildContext context) {
    final entryKey = item.key ?? ValueKey(index);
    final entry = ItemEntry(key: entryKey);
    final isSelected = controller.selectedEntry == entry;

    return _TvNavigationDrawerItem(
      item: item,
      focusNode: controller.itemsNodes[entryKey]!,
      canRequestFocus: item.canRequestFocus,
      isSelected: isSelected,
      isDrawerExpanded: isDrawerExpanded,
      drawerAnimationsDuration: drawerExpandDuration,
      autofocus: drawerAutofocus && isSelected,
      viewportAlignment: viewportAlignment,
      onSelect: (_, _) {
        if (!item.isSelectable) {
          return KeyEventResult.ignored;
        }

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
    required this.viewportAlignment,
  });

  final TvNavigationMenuItem item;
  final TvNavigationMenuController controller;
  final bool drawerAutofocus;
  final bool isDrawerExpanded;
  final Duration drawerExpandDuration;
  final double? viewportAlignment;

  @override
  Widget build(BuildContext context) {
    final entry = const FooterEntry();
    final isSelected = controller.selectedEntry == entry;

    return _TvNavigationDrawerItem(
      item: item,
      focusNode: controller.footerNode!,
      canRequestFocus: item.canRequestFocus,
      isSelected: isSelected,
      isDrawerExpanded: isDrawerExpanded,
      drawerAnimationsDuration: drawerExpandDuration,
      autofocus: drawerAutofocus && isSelected,
      viewportAlignment: viewportAlignment,
      onSelect: (_, _) {
        if (!item.isSelectable) {
          return KeyEventResult.ignored;
        }

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
    required this.canRequestFocus,
    this.isSelected = false,
    required this.isDrawerExpanded,
    required this.drawerAnimationsDuration,
    this.autofocus = false,
    required this.viewportAlignment,
    this.onSelect,
  });

  final TvNavigationMenuItem item;
  final FocusNode focusNode;
  final bool canRequestFocus;
  final bool isSelected;
  final bool isDrawerExpanded;
  final Duration drawerAnimationsDuration;
  final bool autofocus;
  final double? viewportAlignment;
  final KeyEventResult Function(FocusNode, KeyDownEvent)? onSelect;

  @override
  Widget build(BuildContext context) {
    return ScrollGroupDpadFocus(
      focusNode: focusNode,
      canRequestFocus: canRequestFocus,
      autofocus: autofocus,
      onSelect: onSelect,
      key: item.key,
      viewportAlignment: viewportAlignment,
      builder: (context, node) {
        final Set<WidgetState> focusedState = node.hasFocus
            ? {WidgetState.focused}
            : {};

        final widgetState = isSelected
            ? {WidgetState.selected, ...focusedState}
            : focusedState;

        final icon = item.icon;

        return AnimatedContainer(
          duration: drawerAnimationsDuration,
          padding: item.contentPadding,
          decoration: item.decoration?.resolve(widgetState),
          child: Row(
            children: [
              if (icon != null)
                Flexible(flex: 0, child: icon.resolve(widgetState)),

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
