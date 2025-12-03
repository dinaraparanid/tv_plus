import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:tv_plus/foundation/foundation.dart';
import 'package:tv_plus/material/navigation/tab/tv_tab_bar_controller.dart';

final class TvTabBar extends StatefulWidget {
  TvTabBar({
    super.key,
    required this.tabs,
    this.controller,
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
  }) : policy = policy ?? ReadingOrderTraversalPolicy();

  final List<Widget> tabs;
  final TvTabBarController? controller;
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

final class _TvTabBarState extends State<TvTabBar> with DpadEvents {
  late final TvTabBarController _controller;
  var _ownsController = false;

  late final FocusScopeNode _focusScopeNode;
  var _ownsNode = false;

  @override
  void initState() {
    _controller = widget.controller ?? TvTabBarController();

    if (widget.controller == null) {
      _ownsController = true;
    }

    _focusScopeNode = widget.focusScopeNode ?? FocusScopeNode();

    if (widget.focusScopeNode == null) {
      _ownsNode = true;
    }

    _launchListener();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant TvTabBar oldWidget) {
    final passedController = widget.controller;

    if (oldWidget.controller != passedController && passedController != null) {
      if (_ownsController) {
        _controller.dispose();
      }

      _controller = passedController;
      _ownsController = false;
      _relaunchListener();
    }

    final passedNode = widget.focusScopeNode;

    if (oldWidget.focusScopeNode != passedNode && passedNode != null) {
      if (_ownsNode) {
        _focusScopeNode.dispose();
      }

      _focusScopeNode = passedNode;
      _ownsNode = false;
    }

    super.didUpdateWidget(oldWidget);
  }

  void _relaunchListener() {
    _controller.removeListener(_listener);
    _launchListener();
  }

  void _launchListener() {
    _controller.addListener(_listener);
  }

  void _listener() {
    setState(() {});
  }

  @override
  KeyEventResult onUpEvent(FocusNode node, KeyDownEvent event) {
    if (widget.policy.inDirection(node, TraversalDirection.up)) {
      return widget.onUp?.call(node, event, false) ?? KeyEventResult.handled;
    }

    return widget.onUp?.call(node, event, true) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onDownEvent(FocusNode node, KeyDownEvent event) {
    if (widget.policy.inDirection(node, TraversalDirection.down)) {
      return widget.onDown?.call(node, event, false) ?? KeyEventResult.handled;
    }

    return widget.onDown?.call(node, event, true) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onLeftEvent(FocusNode node, KeyDownEvent event) {
    if (widget.policy.inDirection(node, TraversalDirection.left)) {
      _controller.selectIndex(_controller.selectedIndex - 1);
      return widget.onLeft?.call(node, event, false) ?? KeyEventResult.handled;
    }

    return widget.onLeft?.call(node, event, true) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onRightEvent(FocusNode node, KeyDownEvent event) {
    if (widget.policy.inDirection(node, TraversalDirection.right)) {
      _controller.selectIndex(_controller.selectedIndex + 1);
      return widget.onRight?.call(node, event, false) ?? KeyEventResult.handled;
    }

    return widget.onRight?.call(node, event, true) ?? KeyEventResult.ignored;
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }

    if (_ownsNode) {
      _focusScopeNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DpadFocusScope(
      focusScopeNode: _focusScopeNode,
      parentNode: widget.parentNode,
      autofocus: widget.autofocus,
      canRequestFocus: widget.canRequestFocus,
      policy: widget.policy,
      descendantsAreFocusable: widget.descendantsAreFocusable,
      descendantsAreTraversable: widget.descendantsAreTraversable,
      onUp: onUpEvent,
      onDown: onDownEvent,
      onLeft: onLeftEvent,
      onRight: onRightEvent,
      onBack: widget.onBack,
      onFocusChanged: widget.onFocusChanged,
      onFocusDisabledWhenWasFocused: widget.onFocusDisabledWhenWasFocused,
      builder: (_) {
        return Row(
          mainAxisSize: widget.mainAxisSize,
          mainAxisAlignment: widget.mainAxisAlignment,
          crossAxisAlignment: widget.crossAxisAlignment,
          spacing: widget.spacing,
          children: widget.tabs,
        );
      },
    );
  }
}
