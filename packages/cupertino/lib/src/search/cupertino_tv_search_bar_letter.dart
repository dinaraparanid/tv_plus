part of 'search.dart';

final class _CupertinoTvSearchBarLetter extends StatelessWidget {
  const _CupertinoTvSearchBarLetter({
    required this.letter,
    required this.onSelect,
  });

  final String letter;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTvSearchBarTheme.of(context);

    return _CupertinoTvSearchBarItem(
      onSelect: onSelect,
      focusPadding: theme.letterFocusPadding,
      builder: (context, isFocused) => Text(
        letter,
        style: theme.letterTextStyle?.resolve(
          isFocused ? {WidgetState.focused} : {},
        ),
      ),
    );
  }
}
