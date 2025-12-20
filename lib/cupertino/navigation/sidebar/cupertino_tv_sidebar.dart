import 'package:flutter/cupertino.dart';

import '../../../foundation/foundation.dart';
import 'cupertino_tv_sidebar_floating_header.dart';

final class CupertinoTvSidebar extends StatefulWidget {
  CupertinoTvSidebar({
    super.key,
    this.controller,
    this.header,
    this.footer,
    this.backgroundColor,
    this.constraints = const BoxConstraints(minWidth: 90, maxWidth: 200),
    this.drawerMargin = const EdgeInsets.all(16),
    required this.drawerAnimationsDuration,
    this.alignment = TvNavigationMenuAlignment.start,
    this.initialEntry,
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
    this.collapsedHeaderBuilder,
    required this.sidebarBuilder,
    required this.builder,
  }) : assert(menuItems.isNotEmpty),
       policy = policy ?? ReadingOrderTraversalPolicy();

  final TvNavigationMenuController? controller;
  final TvNavigationMenuItem? header;
  final TvNavigationMenuItem? footer;
  final Color? backgroundColor;
  final BoxConstraints constraints;
  final EdgeInsets drawerMargin;
  final Duration drawerAnimationsDuration;
  final TvNavigationMenuAlignment alignment;
  final TvNavigationMenuSelectionEntry? initialEntry;
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
  final Widget Function(
    BuildContext context,
    TvNavigationMenuSelectionEntry? selectedEntry,
    TvNavigationMenuItem selectedItem,
  )?
  collapsedHeaderBuilder;
  final Widget Function(BuildContext context, Widget child) sidebarBuilder;
  final Widget Function(
    BuildContext context,
    TvNavigationMenuSelectionEntry? selectedEntry,
  )
  builder;

  @override
  State<StatefulWidget> createState() => _CupertinoTvSidebarState();
}

final class _CupertinoTvSidebarState extends State<CupertinoTvSidebar> {
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

    _controller.addListener(_controllerListener);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CupertinoTvSidebar oldWidget) {
    final passedController = widget.controller;

    if (passedController != null && oldWidget.controller != passedController) {
      _validateController(passedController);
      _controller.removeListener(_controllerListener);

      if (_ownsController) {
        _controller.dispose();
      }

      _controller = passedController..addListener(_controllerListener);
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

  void _controllerListener() => setState(() {});

  @override
  void dispose() {
    _controller.removeListener(_controllerListener);

    if (_ownsController) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: widget.key,
      decoration: BoxDecoration(color: widget.backgroundColor),
      child: switch (widget.alignment) {
        TvNavigationMenuAlignment.start => Stack(
          children: [
            const SizedBox.expand(),

            Positioned.fill(
              left: widget.constraints.minWidth,
              child: widget.builder(context, _controller.selectedEntry),
            ),

            Positioned(
              top: widget.drawerMargin.top,
              bottom: widget.drawerMargin.bottom,
              left: widget.drawerMargin.left,
              child: _buildContent(),
            ),
          ],
        ),

        TvNavigationMenuAlignment.end => Stack(
          children: [
            const SizedBox.expand(),

            Positioned.fill(
              right: widget.constraints.minWidth,
              child: widget.builder(context, _controller.selectedEntry),
            ),

            Positioned(
              top: widget.drawerMargin.top,
              bottom: widget.drawerMargin.bottom,
              right: widget.drawerMargin.right,
              child: _buildContent(),
            ),
          ],
        ),
      },
    );
  }

  Widget _buildContent() {
    final height =
        MediaQuery.of(context).size.height -
        widget.drawerMargin.top -
        widget.drawerMargin.bottom;

    return DpadFocus(
      focusNode: _controller.mediatorFocusNode,
      onFocusChanged: (node) {
        if (node.hasFocus) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _controller.selectedFocusNode.requestFocus();
          });
        }
      },
      builder: (_) {
        return AnimatedCrossFade(
          duration: widget.drawerAnimationsDuration,
          crossFadeState: _controller.hasFocus
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: ConstrainedBox(
            constraints: widget.constraints,
            child: SizedBox(
              height: height,
              child: widget.sidebarBuilder(
                context,
                TvNavigationMenuContent(
                  controller: widget.controller,
                  header: widget.header,
                  footer: widget.footer,
                  constraints: widget.constraints,
                  itemsAlignment: MainAxisAlignment.start,
                  animateDrawerExpansion: false,
                  drawerAnimationsDuration: widget.drawerAnimationsDuration,
                  menuItems: widget.menuItems,
                  separatorBuilder: widget.separatorBuilder,
                  policy: widget.policy,
                  descendantsAreFocusable: widget.descendantsAreFocusable,
                  descendantsAreTraversable: widget.descendantsAreTraversable,
                  autofocus: widget.autofocus,
                  onUp: widget.onUp,
                  onDown: widget.onDown,
                  onLeft: widget.onLeft,
                  onRight: widget.onRight,
                ),
              ),
            ),
          ),
          secondChild:
              widget.collapsedHeaderBuilder?.call(
                context,
                _controller.selectedEntry,
                _buildSidebarMenuItem(),
              ) ??
              CupertinoTvSidebarFloatingHeader(
                controller: _controller,
                selectedItem: _buildSidebarMenuItem(),
              ),
        );
      },
    );
  }

  TvNavigationMenuItem _buildSidebarMenuItem() {
    return switch (_controller.selectedEntry) {
      HeaderEntry() => widget.header!,

      ItemEntry(key: final key) => widget.menuItems.firstWhere(
        (it) => it.key == key,
      ),

      FooterEntry() => widget.footer!,
    };
  }
}
