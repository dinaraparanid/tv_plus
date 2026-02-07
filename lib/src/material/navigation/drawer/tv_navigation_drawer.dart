part of 'drawer.dart';

final class TvNavigationDrawer extends StatefulWidget {
  TvNavigationDrawer({
    super.key,
    this.controller,
    this.header,
    this.footer,
    this.backgroundColor,
    this.constraints = const BoxConstraints(minWidth: 64, maxWidth: 280),
    this.drawerExpandDuration = const Duration(milliseconds: 300),
    this.alignment = TvNavigationMenuAlignment.start,
    this.mode = TvNavigationDrawerMode.standard,
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
    this.onFocusChanged,
    this.onFocusDisabledWhenWasFocused,
    required this.drawerBuilder,
    required this.builder,
  }) : assert(menuItems.isNotEmpty),
       policy = policy ?? ReadingOrderTraversalPolicy();

  final TvNavigationMenuController? controller;
  final TvNavigationMenuItem? header;
  final TvNavigationMenuItem? footer;
  final Color? backgroundColor;
  final BoxConstraints constraints;
  final Duration drawerExpandDuration;
  final TvNavigationMenuAlignment alignment;
  final TvNavigationDrawerMode mode;
  final TvNavigationMenuSelectionEntry? initialEntry;
  final List<TvNavigationMenuItem> menuItems;
  final Widget Function(int index)? separatorBuilder;
  final FocusTraversalPolicy policy;
  final bool descendantsAreFocusable;
  final bool descendantsAreTraversable;
  final bool autofocus;
  final DpadScopeEventCallback? onUp;
  final DpadScopeEventCallback? onDown;
  final DpadScopeEventCallback? onLeft;
  final DpadScopeEventCallback? onRight;
  final void Function(FocusScopeNode, bool)? onFocusChanged;
  final void Function(FocusScopeNode)? onFocusDisabledWhenWasFocused;
  final Widget Function(BuildContext context, Widget child) drawerBuilder;
  final Widget Function(
    BuildContext context,
    TvNavigationMenuSelectionEntry? entry,
  )
  builder;

  @override
  State<StatefulWidget> createState() => TvNavigationDrawerState();
}

final class TvNavigationDrawerState extends State<TvNavigationDrawer> {
  late TvNavigationMenuController _controller;
  var _ownsController = false;

  TvNavigationMenuController get controller => _controller;

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
        _controller = controller;

      case (null, final TvNavigationMenuSelectionEntry entry):
        _controller = TvNavigationMenuController(initialEntry: entry);
        _ownsController = true;
    }

    _controller.addListener(_controllerListener);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TvNavigationDrawer oldWidget) {
    final passedController = widget.controller;

    if (passedController != null && oldWidget.controller != passedController) {
      _controller.removeListener(_controllerListener);

      if (_ownsController) {
        _controller.dispose();
      }

      _controller = passedController..addListener(_controllerListener);
      _ownsController = false;
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
    return Material(
      color: widget.backgroundColor,
      child: switch (widget.mode) {
        TvNavigationDrawerMode.standard => _buildStandard(),
        TvNavigationDrawerMode.modal => _buildModal(),
      },
    );
  }

  Widget _buildStandard() {
    return Row(
      children: [
        if (widget.alignment == TvNavigationMenuAlignment.start)
          _buildContent(),

        Expanded(child: widget.builder(context, _controller.selectedEntry)),

        if (widget.alignment == TvNavigationMenuAlignment.end) _buildContent(),
      ],
    );
  }

  Widget _buildModal() {
    return switch (widget.alignment) {
      TvNavigationMenuAlignment.start => Stack(
        children: [
          Positioned.fill(
            left: widget.constraints.minWidth,
            child: widget.builder(context, _controller.selectedEntry),
          ),

          Align(alignment: Alignment.centerLeft, child: _buildContent()),
        ],
      ),

      TvNavigationMenuAlignment.end => Stack(
        children: [
          Positioned.fill(
            right: widget.constraints.minWidth,
            child: widget.builder(context, _controller.selectedEntry),
          ),

          Align(alignment: Alignment.centerRight, child: _buildContent()),
        ],
      ),
    };
  }

  Widget _buildContent() {
    return DpadFocus(
      focusNode: _controller.mediatorNode,
      onFocusChanged: (_, hasFocus) {
        if (hasFocus) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _controller.selectedFocusNodeOrNull?.requestFocus();
          });
        }
      },
      builder: (context, node) => widget.drawerBuilder(
        context,
        TvNavigationMenuContent(
          controller: widget.controller,
          header: widget.header,
          footer: widget.footer,
          constraints: widget.constraints,
          animateDrawerExpansion: true,
          drawerAnimationsDuration: widget.drawerExpandDuration,
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
          onFocusChanged: widget.onFocusChanged,
          onFocusDisabledWhenWasFocused: widget.onFocusDisabledWhenWasFocused,
        ),
      ),
    );
  }
}
