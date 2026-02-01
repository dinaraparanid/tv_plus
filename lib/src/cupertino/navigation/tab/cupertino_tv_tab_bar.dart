part of 'tab.dart';

const _colorTabFocusedLight = Color(0xFFFFFFFF);
const _colorTabSelectedLight = Color(0x5E000000);
const _colorTabFocusedDark = Color(0xFFD0D1D3);
const _colorTabSelectedDark = Color(0x80D0D1D3);

final class CupertinoTvTabBar extends StatefulWidget {
  CupertinoTvTabBar({
    super.key,
    required this.tabs,
    required this.animationDuration,
    this.indicatorBuilder,
    this.indicatorMargin = const EdgeInsets.symmetric(vertical: 4),
    this.indicatorPadding = const EdgeInsets.symmetric(horizontal: 12),
    this.controller,
    this.scrollController,
    this.isScrollable = false,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing = 0.0,
    this.padding = const EdgeInsets.symmetric(vertical: 4, horizontal: 32),
    this.decorationBuilder,
    this.focusScopeNode,
    this.parentNode,
    this.autofocus = false,
    this.canRequestFocus = true,
    FocusTraversalPolicy? policy,
    this.descendantsAreFocusable = true,
    this.descendantsAreTraversable = true,
    this.onUp,
    this.onDown,
    this.onLeft,
    this.onRight,
    this.onBack,
    this.onFocusChanged,
    this.onFocusDisabledWhenWasFocused,
  }) : policy = policy ?? ReadingOrderTraversalPolicy();

  final List<Widget> tabs;
  final Duration animationDuration;
  final Widget Function(BuildContext, Offset, Size, bool)? indicatorBuilder;
  final EdgeInsets indicatorMargin;
  final EdgeInsets indicatorPadding;
  final TvTabBarController? controller;
  final ScrollController? scrollController;
  final bool isScrollable;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;
  final EdgeInsets padding;
  final Widget Function(BuildContext, Widget)? decorationBuilder;
  final FocusScopeNode? focusScopeNode;
  final FocusNode? parentNode;
  final bool autofocus;
  final bool canRequestFocus;
  final FocusTraversalPolicy policy;
  final bool descendantsAreFocusable;
  final bool descendantsAreTraversable;
  final ScrollGroupDpadEventCallback? onUp;
  final ScrollGroupDpadEventCallback? onDown;
  final ScrollGroupDpadEventCallback? onLeft;
  final ScrollGroupDpadEventCallback? onRight;
  final DpadEventCallback? onBack;
  final void Function(FocusScopeNode, bool)? onFocusChanged;
  final void Function(FocusScopeNode)? onFocusDisabledWhenWasFocused;

  @override
  State<StatefulWidget> createState() => CupertinoTvTabBarState();
}

final class CupertinoTvTabBarState extends State<CupertinoTvTabBar> {
  static final _tabBarKey = GlobalKey();
  static final _indicatorKey = GlobalKey();

  late TvTabBarController _controller;
  var _ownsController = false;

  TvTabBarController get controller => _controller;

  late ScrollController _scrollController;
  var _ownsScrollController = false;

  ScrollController get scrollController => _scrollController;

  late FocusScopeNode _focusScopeNode;
  var _ownsNode = false;

  FocusScopeNode get focusScopeNode => _focusScopeNode;

  late var _currentIndex = _controller.selectedIndex;
  int get currentIndex => _currentIndex;

  var _tabBarHasFocus = false;
  bool get tabBarHasFocus => _tabBarHasFocus;

  Offset? _selectedOffset;
  Size? _selectedSize;
  double? _scrollOffset;

  late var _tabsKeys = _buildTabKeys();

  var _isTabKeyAttached = false;
  var _isIndicatorKeyAttached = false;

  @override
  void initState() {
    _controller = widget.controller ?? TvTabBarController();
    _ownsController = widget.controller == null;

    _scrollController = widget.scrollController ?? ScrollController();
    _ownsScrollController = widget.scrollController == null;

    _focusScopeNode = widget.focusScopeNode ?? FocusScopeNode();
    _ownsNode = widget.focusScopeNode == null;

    _controller.addListener(_tabListener);
    _focusScopeNode.addListener(_focusListener);
    _scrollController.addListener(_scrollListener);

    // Required for _buildIndicator() in order to update
    // selected tab's RenderBox position and constraints.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSelectionConstraints();
    });

    super.initState();
  }

  @override
  void didUpdateWidget(covariant CupertinoTvTabBar oldWidget) {
    final passedController = widget.controller;

    if (passedController != null && oldWidget.controller != passedController) {
      passedController.removeListener(_tabListener);

      if (_ownsController) {
        _controller.dispose();
      }

      _controller = passedController..addListener(_tabListener);
      _ownsController = false;
    }

    final passedNode = widget.focusScopeNode;

    if (passedNode != null && oldWidget.focusScopeNode != passedNode) {
      passedNode.removeListener(_focusListener);

      if (_ownsNode) {
        _focusScopeNode.dispose();
      }

      _focusScopeNode = passedNode..addListener(_focusListener);
      _ownsNode = false;
    }

    final passedScrollController = widget.scrollController;

    if (passedScrollController != null &&
        oldWidget.scrollController != passedScrollController) {
      passedScrollController.removeListener(_scrollListener);

      if (_ownsScrollController) {
        _scrollController.dispose();
      }

      _scrollController = passedScrollController;
      _ownsScrollController = false;
    }

    final passedTabs = widget.tabs;

    if (passedTabs.length != _tabsKeys.length) {
      _tabsKeys = _buildTabKeys();
    }

    super.didUpdateWidget(oldWidget);
  }

  List<GlobalKey> _buildTabKeys() =>
      List.generate(widget.tabs.length, (_) => GlobalKey());

  void _tabListener() {
    if (_currentIndex != _controller.selectedIndex) {
      setState(() => _currentIndex = _controller.selectedIndex);
    }
  }

  void _focusListener() {
    if (_tabBarHasFocus != _focusScopeNode.hasFocus) {
      setState(() => _tabBarHasFocus = _focusScopeNode.hasFocus);
    }
  }

  void _scrollListener() {
    if (_scrollController.hasClients &&
        _scrollOffset != _scrollController.offset) {
      _scrollOffset = _scrollController.offset;
      _updateSelectionConstraints();
    }
  }

  @override
  void dispose() {
    _focusScopeNode.removeListener(_focusListener);
    _controller.removeListener(_tabListener);
    _scrollController.removeListener(_scrollListener);

    if (_ownsNode) {
      _focusScopeNode.dispose();
    }

    if (_ownsController) {
      _controller.dispose();
    }

    if (_ownsScrollController) {
      _scrollController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final indicatorObj = _indicatorKey.currentContext?.findRenderObject();
    final indicatorBox = indicatorObj is RenderBox ? indicatorObj : null;
    final indicatorHasSize = indicatorBox?.hasSize ?? false;
    final indicatorSize = indicatorHasSize ? indicatorBox?.size : null;

    if (indicatorSize == null && !_isIndicatorKeyAttached) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }

    if (indicatorSize != null && !_isIndicatorKeyAttached) {
      _isIndicatorKeyAttached = true;
    }

    final decorBuilder = widget.decorationBuilder ?? _defaultDecorationBuilder;

    return decorBuilder(
      context,
      Stack(
        children: [
          ?_buildIndicator(context),

          ConstrainedBox(
            constraints: BoxConstraints(minHeight: indicatorSize?.height ?? 0),
            child: widget.isScrollable
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    child: _buildTabBar(context),
                  )
                : _buildTabBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: widget.padding.left),
        TvTabBarFoundation(
          key: _tabBarKey,
          controller: _controller,
          mainAxisSize: widget.isScrollable
              ? MainAxisSize.min
              : widget.mainAxisSize,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: widget.crossAxisAlignment,
          spacing: widget.spacing,
          focusScopeNode: _focusScopeNode,
          parentNode: widget.parentNode,
          autofocus: widget.autofocus,
          canRequestFocus: widget.canRequestFocus,
          policy: widget.policy,
          descendantsAreFocusable: widget.descendantsAreFocusable,
          descendantsAreTraversable: widget.descendantsAreTraversable,
          onUp: widget.onUp,
          onDown: widget.onDown,
          onLeft: (node, event, isOutOfScope) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _updateSelectionConstraints();
            });

            return widget.onLeft?.call(node, event, isOutOfScope) ??
                KeyEventResult.handled;
          },
          onRight: (node, event, isOutOfScope) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _updateSelectionConstraints();
            });

            return widget.onRight?.call(node, event, isOutOfScope) ??
                KeyEventResult.handled;
          },
          onBack: widget.onBack,
          onFocusChanged: widget.onFocusChanged,
          onFocusDisabledWhenWasFocused: widget.onFocusDisabledWhenWasFocused,
          tabs: [
            for (var i = 0; i < widget.tabs.length; ++i)
              SizedBox(key: _tabsKeys[i], child: widget.tabs[i]),
          ],
        ),
        SizedBox(width: widget.padding.right),
      ],
    );
  }

  Widget? _buildIndicator(BuildContext context) {
    final offset = _selectedOffset;
    final sz = _selectedSize;

    if (offset == null || sz == null) {
      if (!_isTabKeyAttached) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {});
        });
      }

      return null;
    }

    if (!_isTabKeyAttached) {
      _isTabKeyAttached = true;
    }

    final indicBuilder = widget.indicatorBuilder ?? _defaultIndicatorBuilder;
    final indicatorPadding = widget.indicatorPadding;

    return AnimatedPositioned(
      key: _indicatorKey,
      duration: widget.animationDuration,
      top: widget.indicatorMargin.top,
      bottom: widget.indicatorMargin.bottom,
      left: offset.dx - widget.indicatorPadding.left + widget.padding.left,
      child: indicBuilder(
        context,
        offset,
        Size(
          sz.width + indicatorPadding.left + indicatorPadding.right,
          sz.height + indicatorPadding.top + indicatorPadding.bottom,
        ),
        _tabBarHasFocus,
      ),
    );
  }

  Widget _defaultDecorationBuilder(BuildContext context, Widget child) {
    const radius = BorderRadius.all(Radius.circular(34));
    final theme = CupertinoTheme.of(context);

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: CupertinoTvConstants.blurSigma,
          sigmaY: CupertinoTvConstants.blurSigma,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.barBackgroundColor,
            borderRadius: radius,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: widget.padding.top,
              bottom: widget.padding.bottom,
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _defaultIndicatorBuilder(
    BuildContext context,
    Offset offset,
    Size size,
    bool hasFocus,
  ) {
    const radius = BorderRadius.all(Radius.circular(28));
    final brightness = CupertinoTheme.brightnessOf(context);

    final focusedColor = switch (brightness) {
      Brightness.dark => _colorTabFocusedDark,
      Brightness.light => _colorTabFocusedLight,
    };

    final selectedColor = switch (brightness) {
      Brightness.dark => _colorTabSelectedDark,
      Brightness.light => _colorTabSelectedLight,
    };

    return AnimatedContainer(
      duration: widget.animationDuration,
      decoration: BoxDecoration(
        color: hasFocus ? focusedColor : selectedColor,
        borderRadius: radius,
        boxShadow: const [
          BoxShadow(
            color: CupertinoTvConstants.shadowColor,
            offset: Offset(3, 3),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: SizedBox(height: size.height, width: size.width),
    );
  }

  void _updateSelectionConstraints() {
    final (offset, size) = _getSelectionConstraints();

    if (offset != null && size != null) {
      setState(() {
        _selectedOffset = offset;
        _selectedSize = size;
      });
    }
  }

  (Offset?, Size?) _getSelectionConstraints() {
    final obj = _tabsKeys[_currentIndex].currentContext?.findRenderObject();
    final box = obj is RenderBox ? obj : null;

    final parentObj = _tabBarKey.currentContext?.findRenderObject();
    final parentBox = parentObj is RenderBox ? parentObj : null;

    final hasSize = (box?.hasSize ?? false) && box?.size.width != 0;
    final globalOffset = hasSize ? box?.localToGlobal(Offset.zero) : null;

    final localOffset = globalOffset != null
        ? parentBox?.globalToLocal(globalOffset)
        : null;

    final scrollOffset = _scrollController.hasClients
        ? _scrollController.offset
        : 0;

    final visibleOffset = localOffset == null
        ? null
        : Offset(localOffset.dx - scrollOffset, localOffset.dy);

    final size = hasSize ? box?.size : null;

    return (visibleOffset, size);
  }
}
