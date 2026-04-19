part of 'search.dart';

final class _CupertinoTvSearchBarItem extends StatelessWidget {
  const _CupertinoTvSearchBarItem({
    required this.onSelect,
    this.focusPadding,
    required this.builder,
  });

  final VoidCallback onSelect;
  final EdgeInsetsGeometry? focusPadding;
  final Widget Function(BuildContext context, bool isFocused) builder;

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTvSearchBarTheme.of(context);

    return DpadFocus(
      onSelect: (_, _) {
        onSelect();
        return KeyEventResult.handled;
      },
      builder: (context, node) => DecoratedBox(
        decoration:
            theme.letterFocusDecoration?.resolve(
              node.hasFocus ? {WidgetState.focused} : {},
            ) ??
            const BoxDecoration(),
        child: GestureDetector(
          onTap: onSelect,
          child: Padding(
            padding: focusPadding ?? EdgeInsets.zero,
            child: builder(context, node.hasFocus),
          ),
        ),
      ),
    );
  }
}
