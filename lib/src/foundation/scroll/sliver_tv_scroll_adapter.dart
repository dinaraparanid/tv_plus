part of 'scroll.dart';

final class SliverTVScrollAdapter extends StatelessWidget with DpadScopeEvents {
  SliverTVScrollAdapter({
    super.key,
    this.focusScopeNode,
    FocusTraversalPolicy? policy,
    this.descendantsAreFocusable = true,
    this.descendantsAreTraversable = true,
    this.autofocus = false,
    this.onUp,
    this.onDown,
    this.onLeft,
    this.onRight,
    required this.sliver,
  }) : policy = policy ?? ReadingOrderTraversalPolicy();

  final FocusScopeNode? focusScopeNode;
  final FocusTraversalPolicy policy;
  final bool descendantsAreFocusable;
  final bool descendantsAreTraversable;
  final bool autofocus;
  final ScrollGroupDpadEventCallback? onUp;
  final ScrollGroupDpadEventCallback? onDown;
  final ScrollGroupDpadEventCallback? onLeft;
  final ScrollGroupDpadEventCallback? onRight;
  final Widget sliver;

  @override
  Widget build(BuildContext context) {
    return DpadFocusScope(
      focusScopeNode: focusScopeNode,
      autofocus: autofocus,
      onUp: onUp,
      onDown: onDown,
      onLeft: onLeft,
      onRight: onRight,
      includeSemantics: false,
      builder: (_) => sliver,
    );
  }
}
