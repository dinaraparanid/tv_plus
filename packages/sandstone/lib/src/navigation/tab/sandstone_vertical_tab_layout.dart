part of 'tab.dart';

final class SandstoneVerticalTabLayout extends StatefulWidget {
  SandstoneVerticalTabLayout({
    super.key,
    this.controller,
    this.backgroundColor,
    this.drawerExpandDuration = const Duration(milliseconds: 300),
    this.initialEntry,
    required this.tabs,
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
    required this.tabsBuilder,
    required this.builder,
  }) : assert(tabs.isNotEmpty),
       policy = policy ?? ReadingOrderTraversalPolicy();

  final TvNavigationMenuController? controller;
  final Color? backgroundColor;
  final Duration drawerExpandDuration;
  final TvNavigationMenuEntry? initialEntry;
  final List<SandstoneVerticalTab> tabs;
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

  final Widget Function(TvNavigationMenuEntry item, bool isExpanded)?
  separatorBuilder;

  final Widget Function(BuildContext context, bool isExpanded, Widget child)
  tabsBuilder;

  final Widget Function(
    BuildContext context,
    bool isExpanded,
    TvNavigationMenuEntry? entry,
  )
  builder;

  static SandstoneVerticalTabLayoutState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<SandstoneVerticalTabLayoutState>();
  }

  static SandstoneVerticalTabLayoutState of(BuildContext context) =>
      maybeOf(context)!;

  @override
  State<StatefulWidget> createState() => SandstoneVerticalTabLayoutState();
}

final class SandstoneVerticalTabLayoutState
    extends State<SandstoneVerticalTabLayout> {
  late TvNavigationMenuController _controller;
  var _ownsController = false;

  TvNavigationMenuController get controller => _controller;

  var _isExpanded = false;
  bool get isExpanded => _isExpanded;

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

      case (null, final TvNavigationMenuEntry entry):
        _controller = TvNavigationMenuController(initialEntry: entry);
        _ownsController = true;
    }

    _controller.addListener(_controllerListener);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SandstoneVerticalTabLayout oldWidget) {
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
      child: Row(
        children: [
          Align(alignment: Alignment.topLeft, child: _buildContent()),
          Expanded(
            child: widget.builder(
              context,
              _isExpanded,
              _controller.selectedEntry,
            ),
          ),
        ],
      ),
    );
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
      builder: (context, node) => widget.tabsBuilder(
        context,
        _isExpanded,
        AnimatedSwitcher(
          duration: widget.drawerExpandDuration,
          transitionBuilder: (child, animation) {
            final offsetAnimation = animation.drive(
              Tween(begin: const Offset(-1, 0), end: Offset.zero),
            );

            return SlideTransition(position: offsetAnimation, child: child);
          },
          child: _buildMenu(isExpanded: _isExpanded),
        ),
      ),
    );
  }

  Widget _buildMenu({required bool isExpanded}) {
    final separator = widget.separatorBuilder;

    return Builder(
      key: ValueKey(isExpanded),
      builder: (context) => IntrinsicWidth(
        child: TvNavigationMenuContent(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          controller: widget.controller,
          menuItems: [
            for (final tab in widget.tabs)
              tab.toMenuItem(isExpanded: isExpanded),
          ],
          separatorBuilder: separator == null
              ? null
              : (i) {
                  return separator(i, isExpanded);
                },
          policy: widget.policy,
          descendantsAreFocusable: widget.descendantsAreFocusable,
          descendantsAreTraversable: widget.descendantsAreTraversable,
          autofocus: widget.autofocus,
          onUp: widget.onUp,
          onDown: widget.onDown,
          onLeft: widget.onLeft,
          onRight: widget.onRight,
          onFocusChanged: (node, hasFocus) {
            setState(() => _isExpanded = hasFocus);
            widget.onFocusChanged?.call(node, hasFocus);
          },
          onFocusDisabledWhenWasFocused: widget.onFocusDisabledWhenWasFocused,
          menuItemsBuilder: (context, menu) => menu,
        ),
      ),
    );
  }
}
