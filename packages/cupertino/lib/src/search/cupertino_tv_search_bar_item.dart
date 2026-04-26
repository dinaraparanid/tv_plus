part of 'search.dart';

final class _CupertinoTvSearchBarItem extends StatelessWidget {
  const _CupertinoTvSearchBarItem({
    this.autofocus = false,
    required this.onSelect,
    this.onLongSelect,
    this.focusPadding,
    required this.builder,
  });

  final bool autofocus;
  final VoidCallback onSelect;
  final VoidCallback? onLongSelect;
  final EdgeInsetsGeometry? focusPadding;
  final Widget Function(BuildContext context, bool isFocused) builder;

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTvSearchBarTheme.of(context);
    final onLong = onLongSelect;

    return DpadFocus(
      autofocus: autofocus,
      onSelect: (_, _) {
        onSelect();
        return KeyEventResult.handled;
      },
      onLongSelect: onLong == null
          ? null
          : (_, _) {
              onLong();
              return KeyEventResult.handled;
            },
      builder: (context, node) => DecoratedBox(
        decoration:
            theme.letterDecoration?.resolve(
              node.hasFocus ? {WidgetState.focused} : {},
            ) ??
            const BoxDecoration(),
        child: GestureDetector(
          onTap: onSelect,
          onLongPress: onLongSelect,
          child: Padding(
            padding: focusPadding ?? EdgeInsets.zero,
            child: builder(context, node.hasFocus),
          ),
        ),
      ),
    );
  }
}
