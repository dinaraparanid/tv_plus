import 'package:flutter/material.dart';
import 'package:tv_plus/material/navigation/tab/tv_tab_bar_mode.dart';

import '../../../foundation/foundation.dart';

final class TvTabBar extends StatefulWidget {
  TvTabBar({
    super.key,
    required this.tabs,
    required this.animationDuration,
    required this.indicatorBuilder,
    this.indicatorMargin = EdgeInsets.zero,
    this.controller,
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
  final ScrollGroupDpadEventCallback? onUp;
  final ScrollGroupDpadEventCallback? onDown;
  final ScrollGroupDpadEventCallback? onLeft;
  final ScrollGroupDpadEventCallback? onRight;
  final DpadEventCallback? onBack;
  final void Function(FocusNode)? onFocusChanged;
  final void Function()? onFocusDisabledWhenWasFocused;

  @override
  State<StatefulWidget> createState() => _TvTabBarState();
}

final class _TvTabBarState extends State<TvTabBar> {
  static final _tabBarKey = GlobalKey();
  static final _indicatorKey = GlobalKey();

  late final TvTabBarController _controller;
  var _ownsController = false;

  late final FocusScopeNode _focusScopeNode;
  var _ownsNode = false;

  late final TvTabBarMode _mode = widget.mode;

  late var _currentIndex = _controller.selectedIndex;

  var _tabBarHasFocus = false;

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

  @override
  void dispose() {
    _focusScopeNode.removeListener(_focusListener);

    if (_ownsNode) {
      _focusScopeNode.dispose();
    }

    _controller.removeListener(_tabListener);

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
          child: widget.isScrollable
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
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
      onLeft: widget.onLeft,
      onRight: widget.onRight,
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
    return _mode == TvTabBarMode.primary
        ? _buildPrimaryIndicator(context)
        : _buildSecondaryIndicator(context);
  }

  Widget? _buildPrimaryIndicator(BuildContext context) {
    final (selectedOffset, selectedSize) = _getSelectionConstraints();

    if (selectedOffset == null || selectedSize == null) {
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
      left: selectedOffset.dx + widget.indicatorMargin.left,
      child: widget.indicatorBuilder(
        context,
        selectedOffset,
        selectedSize,
        _tabBarHasFocus,
      ),
    );
  }

  Widget? _buildSecondaryIndicator(BuildContext context) {
    final (selectedOffset, selectedSize) = _getSelectionConstraints();

    if (selectedOffset == null || selectedSize == null) {
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
      top: selectedSize.height + widget.indicatorMargin.top,
      left: selectedOffset.dx + widget.indicatorMargin.left,
      child: widget.indicatorBuilder(
        context,
        selectedOffset,
        selectedSize,
        _tabBarHasFocus,
      ),
    );
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

    final size = hasSize ? box?.size : null;

    return (localOffset, size);
  }
}
