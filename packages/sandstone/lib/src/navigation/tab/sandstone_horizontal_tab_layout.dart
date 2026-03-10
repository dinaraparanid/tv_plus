part of 'tab.dart';

final class SandstoneHorizontalTabLayout extends StatefulWidget {
  SandstoneHorizontalTabLayout({
    super.key,
    required this.tabs,
    required this.indicatorBuilder,
    this.indicatorMargin = EdgeInsets.zero,
    this.controller,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.separatorBuilder,
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
  final Widget Function(BuildContext, Offset, Size, bool) indicatorBuilder;
  final EdgeInsets indicatorMargin;
  final TvTabBarController? controller;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Widget Function(BuildContext, int)? separatorBuilder;
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
  State<StatefulWidget> createState() => SandstoneHorizontalTabLayoutState();
}

final class SandstoneHorizontalTabLayoutState
    extends State<SandstoneHorizontalTabLayout> {
  final _tabBarKey = GlobalKey();
  final _indicatorKey = GlobalKey();

  late TvTabBarController _controller;
  var _ownsController = false;

  TvTabBarController get controller => _controller;

  late FocusScopeNode _focusScopeNode;
  var _ownsNode = false;

  FocusScopeNode get focusScopeNode => _focusScopeNode;

  late var _currentIndex = _controller.selectedIndex;
  int get currentIndex => _currentIndex;

  var _hasFocus = false;
  bool get tabBarHasFocus => _hasFocus;

  Offset? _selectedOffset;
  Size? _selectedSize;

  late var _tabsKeys = _buildTabKeys();

  var _isTabKeyAttached = false;
  var _isIndicatorKeyAttached = false;

  @override
  void initState() {
    _controller = widget.controller ?? TvTabBarController();
    _ownsController = widget.controller == null;

    _focusScopeNode = widget.focusScopeNode ?? FocusScopeNode();
    _ownsNode = widget.focusScopeNode == null;

    _controller.addListener(_tabListener);
    _focusScopeNode.addListener(_focusListener);

    // Required for _buildIndicator() in order to update
    // selected tab's RenderBox position and constraints.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSelectionConstraints();
    });

    super.initState();
  }

  @override
  void didUpdateWidget(covariant SandstoneHorizontalTabLayout oldWidget) {
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

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateSelectionConstraints();
      });
    }
  }

  void _focusListener() {
    if (_hasFocus != _focusScopeNode.hasFocus) {
      setState(() => _hasFocus = _focusScopeNode.hasFocus);
    }
  }

  @override
  void dispose() {
    _focusScopeNode.removeListener(_focusListener);
    _controller.removeListener(_tabListener);

    if (_ownsNode) {
      _focusScopeNode.dispose();
    }

    if (_ownsController) {
      _controller.dispose();
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
          child: _buildTabBar(),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return TvTabBarFoundation(
      key: _tabBarKey,
      controller: _controller,
      mainAxisSize: widget.mainAxisSize,
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      separatorBuilder: widget.separatorBuilder,
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
        return widget.onLeft?.call(node, event, isOutOfScope) ??
            KeyEventResult.handled;
      },
      onRight: (node, event, isOutOfScope) {
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
    return _hasFocus
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

    return Positioned(
      key: _indicatorKey,
      top: widget.indicatorMargin.top,
      bottom: widget.indicatorMargin.bottom,
      left: offset.dx + widget.indicatorMargin.left,
      child: widget.indicatorBuilder(context, offset, sz, _hasFocus),
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

    return Positioned(
      key: _indicatorKey,
      bottom: widget.indicatorMargin.bottom,
      left: offset.dx + widget.indicatorMargin.left,
      child: widget.indicatorBuilder(context, offset, sz, _hasFocus),
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

    final visibleOffset = localOffset == null
        ? null
        : Offset(localOffset.dx, localOffset.dy);

    final size = hasSize ? box?.size : null;

    return (visibleOffset, size);
  }
}
