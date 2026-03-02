part of 'drawer.dart';

final class OneUiTvNavigationDrawer extends StatefulWidget {
  OneUiTvNavigationDrawer({
    super.key,
    this.controller,
    this.header,
    this.footer,
    this.backgroundColor,
    this.constraints = const BoxConstraints(minWidth: 64, maxWidth: 280),
    this.drawerExpandDuration = const Duration(milliseconds: 300),
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
  final TvNavigationMenuEntry? initialEntry;
  final List<TvNavigationMenuItem> menuItems;
  final Widget Function(TvNavigationMenuEntry)? separatorBuilder;
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

  final Widget Function(
    BuildContext context,
    Animation<double> expandAnimation,
    Widget child,
  )
  drawerBuilder;

  final Widget Function(
    BuildContext context,
    Animation<double> expandAnimation,
    TvNavigationMenuEntry? entry,
  )
  builder;

  static TvNavigationMenuController? maybeOf(BuildContext context) {
    return context
        .findAncestorStateOfType<OneUiTvNavigationDrawerState>()
        ?.controller;
  }

  static TvNavigationMenuController of(BuildContext context) =>
      maybeOf(context)!;

  static Animation<double>? maybeAnimationOf(BuildContext context) {
    return context
        .findAncestorStateOfType<OneUiTvNavigationDrawerState>()
        ?.expandAnimation;
  }

  static Animation<double> animationOf(BuildContext context) =>
      maybeAnimationOf(context)!;

  @override
  State<StatefulWidget> createState() => OneUiTvNavigationDrawerState();
}

final class OneUiTvNavigationDrawerState extends State<OneUiTvNavigationDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;

  Animation<double> get expandAnimation => _expandAnimation;

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

      case (null, final TvNavigationMenuEntry entry):
        _controller = TvNavigationMenuController(initialEntry: entry);
        _ownsController = true;
    }

    _initExpandAnimation();

    _controller.addListener(_controllerListener);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant OneUiTvNavigationDrawer oldWidget) {
    final passedController = widget.controller;

    if (passedController != null && oldWidget.controller != passedController) {
      _controller.removeListener(_controllerListener);

      if (_ownsController) {
        _controller.dispose();
      }

      _controller = passedController..addListener(_controllerListener);
      _ownsController = false;
    }

    if (oldWidget.drawerExpandDuration != widget.drawerExpandDuration) {
      _expandController.dispose();
      _initExpandAnimation();
    }

    super.didUpdateWidget(oldWidget);
  }

  void _initExpandAnimation() {
    _expandController = AnimationController(
      vsync: this,
      duration: widget.drawerExpandDuration,
    );

    _expandAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_expandController);
  }

  void _controllerListener() => setState(() {});

  @override
  void dispose() {
    _controller.removeListener(_controllerListener);

    if (_ownsController) {
      _controller.dispose();
    }

    _expandController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AnimatedContent(
      expandAnimation: _expandAnimation,
      controller: _controller,
      backgroundColor: widget.backgroundColor,
      constraints: widget.constraints,
      alignment: widget.alignment,
      drawerBuilder: (_, animation) => _buildContent(animation),
      builder: widget.builder,
    );
  }

  Widget _buildContent(Animation<double> expandAnimation) {
    final collapsedConstraints = widget.constraints.copyWith(
      maxWidth: widget.constraints.minWidth,
    );

    final expandedConstraints = widget.constraints;

    return DpadFocus(
      focusNode: _controller.mediatorNode,
      onFocusChanged: (_, hasFocus) {
        if (hasFocus) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _controller.selectedFocusNodeOrNull?.requestFocus();
          });
        }
      },
      builder: (context, node) => ConstrainedBox(
        constraints: BoxConstraints.lerp(
          collapsedConstraints,
          expandedConstraints,
          expandAnimation.value,
        )!,
        child: widget.drawerBuilder(
          context,
          expandAnimation,
          TvNavigationMenuContent(
            controller: widget.controller,
            header: widget.header,
            footer: widget.footer,
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
            onFocusChanged: (node, hasFocus) {
              if (hasFocus) {
                _expandController.forward();
              } else {
                _expandController.reverse();
              }

              widget.onFocusChanged?.call(node, hasFocus);
            },
            onFocusDisabledWhenWasFocused: widget.onFocusDisabledWhenWasFocused,
          ),
        ),
      ),
    );
  }
}

final class _AnimatedContent extends AnimatedWidget {
  const _AnimatedContent({
    required Animation<double> expandAnimation,
    required this.controller,
    required this.backgroundColor,
    required this.constraints,
    required this.alignment,
    required this.drawerBuilder,
    required this.builder,
  }) : super(listenable: expandAnimation);

  final TvNavigationMenuController controller;
  final Color? backgroundColor;
  final BoxConstraints constraints;
  final TvNavigationMenuAlignment alignment;

  final Widget Function(BuildContext context, Animation<double> expandAnimation)
  drawerBuilder;

  final Widget Function(
    BuildContext context,
    Animation<double> expandAnimation,
    TvNavigationMenuEntry? entry,
  )
  builder;

  @override
  Widget build(BuildContext context) {
    final expandAnimation = listenable as Animation<double>;
    final expandOffset = lerpDouble(
      0,
      constraints.maxWidth,
      expandAnimation.value,
    );

    return Material(
      color: backgroundColor,
      child: switch (alignment) {
        TvNavigationMenuAlignment.start => Stack(
          children: [
            Positioned.fill(
              left: expandOffset,
              child: builder(
                context,
                expandAnimation,
                controller.selectedEntry,
              ),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Builder(
                builder: (context) => drawerBuilder(context, expandAnimation),
              ),
            ),
          ],
        ),

        TvNavigationMenuAlignment.end => Stack(
          children: [
            Positioned.fill(
              right: expandOffset,
              child: builder(
                context,
                expandAnimation,
                controller.selectedEntry,
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: Builder(
                builder: (context) => drawerBuilder(context, expandAnimation),
              ),
            ),
          ],
        ),
      },
    );
  }
}
