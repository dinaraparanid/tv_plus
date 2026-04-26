part of 'search.dart';

final class CupertinoTvSearchBar extends StatelessWidget {
  CupertinoTvSearchBar({
    super.key,
    required this.controller,
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
    this.searchIcon,
    this.theme,
  }) : policy = policy ?? ReadingOrderTraversalPolicy();

  final CupertinoTvSearchController controller;
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
  final String placeholder;
  final Widget? searchIcon;
  final CupertinoTvSearchBarThemeData? theme;

  @override
  Widget build(BuildContext context) {
    return DpadFocusScope(
      focusScopeNode: controller.focusScopeNode,
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
      builder: (context, _) => CupertinoTvSearchBarTheme(
        data: theme,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: theme?.spaceBetweenQueryAndInput ?? 0,
          children: [
            _CupertinoTvSearchField(
              controller: controller,
              placeholder: placeholder,
              searchIcon: searchIcon,
            ),

            _CupertinoTvSearchBarInput(controller: controller),
          ],
        ),
      ),
    );
  }
}
