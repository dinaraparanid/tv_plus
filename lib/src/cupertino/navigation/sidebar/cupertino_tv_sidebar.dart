part of 'sidebar.dart';

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
  State<StatefulWidget> createState() => CupertinoTvSidebarState();
}

final class CupertinoTvSidebarState extends State<CupertinoTvSidebar> {
  late TvNavigationMenuController controller;
  var _ownsController = false;

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
        this.controller = controller;

      case (null, final TvNavigationMenuSelectionEntry entry):
        controller = TvNavigationMenuController(initialEntry: entry);
        _ownsController = true;
    }

    controller.addListener(_controllerListener);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CupertinoTvSidebar oldWidget) {
    final passedController = widget.controller;

    if (passedController != null && oldWidget.controller != passedController) {
      controller.removeListener(_controllerListener);

      if (_ownsController) {
        controller.dispose();
      }

      controller = passedController..addListener(_controllerListener);
      _ownsController = false;
    }

    super.didUpdateWidget(oldWidget);
  }

  void _controllerListener() => setState(() {});

  @override
  void dispose() {
    controller.removeListener(_controllerListener);

    if (_ownsController) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: widget.backgroundColor),
      child: switch (widget.alignment) {
        TvNavigationMenuAlignment.start => Stack(
          children: [
            const SizedBox.expand(),

            Positioned.fill(
              left: widget.constraints.minWidth,
              child: widget.builder(context, controller.selectedEntry),
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
              child: widget.builder(context, controller.selectedEntry),
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
      focusNode: controller.mediatorFocusNode,
      onFocusChanged: (_, hasFocus) {
        if (hasFocus) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.selectedFocusNode.requestFocus();
          });
        }
      },
      builder: (context, node) {
        return AnimatedCrossFade(
          duration: widget.drawerAnimationsDuration,
          crossFadeState: controller.hasFocus
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
                controller.selectedEntry,
                _buildSidebarMenuItem(),
              ) ??
              CupertinoTvSidebarFloatingHeader(
                controller: controller,
                selectedItem: _buildSidebarMenuItem(),
              ),
        );
      },
    );
  }

  TvNavigationMenuItem _buildSidebarMenuItem() {
    return switch (controller.selectedEntry) {
      HeaderEntry() => widget.header!,

      ItemEntry(key: final key) => widget.menuItems.firstWhere(
        (it) => it.key == key,
      ),

      FooterEntry() => widget.footer!,
    };
  }
}
