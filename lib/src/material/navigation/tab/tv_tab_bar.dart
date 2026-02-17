part of 'tab.dart';

final class TvTabBar extends StatefulWidget {
  TvTabBar({
    super.key,
    required this.tabs,
    required this.animationDuration,
    required this.indicatorBuilder,
    this.indicatorMargin = EdgeInsets.zero,
    this.controller,
    this.scrollController,
    this.isScrollable = false,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing = 0.0,
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
  }) : policy = policy ?? ReadingOrderTraversalPolicy(),
       mode = TvTabBarMode.primary;

  TvTabBar.secondary({
    super.key,
    required this.tabs,
    required this.animationDuration,
    required this.indicatorBuilder,
    this.indicatorMargin = EdgeInsets.zero,
    this.controller,
    this.scrollController,
    this.isScrollable = false,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing = 0.0,
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
  }) : policy = policy ?? ReadingOrderTraversalPolicy(),
       mode = TvTabBarMode.secondary;

  final List<Widget> tabs;
  final Duration animationDuration;
  final Widget Function(BuildContext, Offset, Size, bool) indicatorBuilder;
  final EdgeInsets indicatorMargin;
  final TvTabBarController? controller;
  final ScrollController? scrollController;
  final TvTabBarMode mode;
  final bool isScrollable;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;
  final FocusScopeNode? focusScopeNode;
  final FocusNode? parentNode;
  final bool autofocus;
  final bool canRequestFocus;
  final FocusTraversalPolicy policy;
  final bool descendantsAreFocusable;
  final bool descendantsAreTraversable;
  final DpadScopeEventCallback? onUp;
  final DpadScopeEventCallback? onDown;
  final DpadScopeEventCallback? onLeft;
  final DpadScopeEventCallback? onRight;
  final DpadEventCallback? onBack;
  final void Function(FocusScopeNode, bool)? onFocusChanged;
  final void Function(FocusScopeNode)? onFocusDisabledWhenWasFocused;

  @override
  State<StatefulWidget> createState() => TvTabBarState();
}

final class TvTabBarState extends State<TvTabBar> {
  final _tabBarKey = GlobalKey();
  final _indicatorKey = GlobalKey();

  late TvTabBarController _controller;
  var _ownsController = false;

  TvTabBarController get controller => _controller;

  late ScrollController _scrollController;
  var _ownsScrollController = false;

  ScrollController get scrollController => _scrollController;

  late FocusScopeNode _focusScopeNode;
  var _ownsNode = false;

  FocusScopeNode get focusScopeNode => _focusScopeNode;

  late final TvTabBarMode mode = widget.mode;

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
  void didUpdateWidget(covariant TvTabBar oldWidget) {
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

    return Stack(
      children: [
        ?_buildIndicator(context),

        ConstrainedBox(
          constraints: BoxConstraints(minHeight: indicatorSize?.height ?? 0),
          child: widget.isScrollable
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: _buildTabBar(),
                )
              : _buildTabBar(),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return TvTabBarFoundation(
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
    );
  }

  Widget? _buildIndicator(BuildContext context) {
    return mode == TvTabBarMode.primary
        ? _buildPrimaryIndicator(context)
        : _buildSecondaryIndicator(context);
  }

  Widget? _buildPrimaryIndicator(BuildContext context) {
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

    return AnimatedPositioned(
      key: _indicatorKey,
      duration: widget.animationDuration,
      top: widget.indicatorMargin.top,
      bottom: widget.indicatorMargin.bottom,
      left: offset.dx + widget.indicatorMargin.left,
      child: widget.indicatorBuilder(context, offset, sz, _tabBarHasFocus),
    );
  }

  Widget? _buildSecondaryIndicator(BuildContext context) {
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

    return AnimatedPositioned(
      key: _indicatorKey,
      duration: widget.animationDuration,
      bottom: widget.indicatorMargin.bottom,
      left: offset.dx + widget.indicatorMargin.left,
      child: widget.indicatorBuilder(context, offset, sz, _tabBarHasFocus),
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
