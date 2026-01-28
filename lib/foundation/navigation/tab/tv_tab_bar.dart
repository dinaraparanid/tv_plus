import 'package:flutter/widgets.dart';
import 'package:tv_plus/foundation/foundation.dart';

final class TvTabBarFoundation extends StatefulWidget {
  TvTabBarFoundation({
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
  final void Function(FocusScopeNode, bool)? onFocusChanged;
  final void Function(FocusScopeNode)? onFocusDisabledWhenWasFocused;

  @override
  State<StatefulWidget> createState() => _TvTabBarFoundationState();
}

final class _TvTabBarFoundationState extends State<TvTabBarFoundation> {
  late TvTabBarController _controller;
  var _ownsController = false;

  late FocusScopeNode _focusScopeNode;
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
  void didUpdateWidget(covariant TvTabBarFoundation oldWidget) {
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
      onUp: widget.onUp,
      onDown: widget.onDown,
      onLeft: widget.onLeft,
      onRight: widget.onRight,
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
