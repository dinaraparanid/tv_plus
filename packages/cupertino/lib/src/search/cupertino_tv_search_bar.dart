part of 'search.dart';

final class CupertinoTvSearchBar extends StatelessWidget {
  CupertinoTvSearchBar({
    super.key,
    this.controller,
    this.focusScopeNode,
    this.parentNode,
    this.autofocus = false,
    this.canRequestFocus = true,
    this.skipTraversal,
    this.rebuildOnFocusChange = true,
    FocusTraversalPolicy? policy,
    this.descendantsAreFocusable = true,
    this.descendantsAreTraversable = true,
    this.includeSemantics = true,
    this.onUp,
    this.onDown,
    this.onLeft,
    this.onRight,
    this.onSelect,
    this.onBack,
    this.onKeyEvent,
    this.onFocusChanged,
    this.onFocusDisabledWhenWasFocused,
    required this.placeholder,
    this.queryStyle,
    this.placeholderStyle,
    this.searchIcon,
  }) : policy = policy ?? ReadingOrderTraversalPolicy();

  final TVSearchController? controller;
  final FocusScopeNode? focusScopeNode;
  final FocusNode? parentNode;
  final bool autofocus;
  final bool canRequestFocus;
  final bool? skipTraversal;
  final bool rebuildOnFocusChange;
  final FocusTraversalPolicy policy;
  final bool descendantsAreFocusable;
  final bool descendantsAreTraversable;
  final bool includeSemantics;
  final DpadScopeEventCallback? onUp;
  final DpadScopeEventCallback? onDown;
  final DpadScopeEventCallback? onLeft;
  final DpadScopeEventCallback? onRight;
  final DpadEventCallback? onSelect;
  final DpadEventCallback? onBack;
  final KeyEventResult Function(FocusNode, KeyEvent)? onKeyEvent;
  final void Function(FocusScopeNode, bool)? onFocusChanged;
  final void Function(FocusScopeNode)? onFocusDisabledWhenWasFocused;
  final TextStyle? queryStyle;
  final String placeholder;
  final TextStyle? placeholderStyle;
  final Widget? searchIcon;

  @override
  Widget build(BuildContext context) {
    return DpadFocusScope(
      focusScopeNode: focusScopeNode,
      parentNode: parentNode,
      autofocus: autofocus,
      canRequestFocus: canRequestFocus,
      skipTraversal: skipTraversal,
      rebuildOnFocusChange: rebuildOnFocusChange,
      policy: policy,
      descendantsAreFocusable: descendantsAreFocusable,
      descendantsAreTraversable: descendantsAreTraversable,
      includeSemantics: includeSemantics,
      onUp: onUp,
      onDown: onDown,
      onLeft: onLeft,
      onRight: onRight,
      onSelect: onSelect,
      onBack: onBack,
      onKeyEvent: onKeyEvent,
      onFocusChanged: onFocusChanged,
      onFocusDisabledWhenWasFocused: onFocusDisabledWhenWasFocused,
      builder: (context, _) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SearchField(
            controller: controller,
            placeholder: placeholder,
            queryStyle: queryStyle,
            placeholderStyle: placeholderStyle,
            searchIcon: searchIcon,
          ),
        ],
      ),
    );
  }
}

final class _SearchField extends StatefulWidget {
  const _SearchField({
    required this.controller,
    required this.placeholder,
    required this.queryStyle,
    required this.placeholderStyle,
    required this.searchIcon,
  });

  final TVSearchController? controller;
  final TextStyle? queryStyle;
  final String placeholder;
  final TextStyle? placeholderStyle;
  final Widget? searchIcon;

  @override
  State<StatefulWidget> createState() => _SearchFieldState();
}

final class _SearchFieldState extends State<_SearchField> {
  late TVSearchController _controller;
  var _ownsController = false;

  late final _inputNode = FocusNode(canRequestFocus: false);

  @override
  void initState() {
    _controller = widget.controller ?? TVSearchController();
    _ownsController = widget.controller == null;

    _controller.addListener(_controllerListener);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant _SearchField oldWidget) {
    final passedController = widget.controller;

    if (passedController != null && passedController != oldWidget.controller) {
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

    _inputNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ?widget.searchIcon,

        Expanded(
          child: CupertinoTextField(
            controller: _controller.textEditingController,
            focusNode: _inputNode,
            decoration: null,
            padding: EdgeInsets.zero,
            placeholder: widget.placeholder,
            placeholderStyle: widget.placeholderStyle,
            style: widget.queryStyle,
            readOnly: true,
            showCursor: false,
            textAlignVertical: TextAlignVertical.center,
          ),
        ),

        // TODO(paranid5): press hint
      ],
    );
  }
}
