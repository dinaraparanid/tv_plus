part of 'search.dart';

final class _LangButton extends StatelessWidget {
  const _LangButton({required this.onSelect});
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTvSearchBarTheme.of(context);

    return _CupertinoTvSearchBarItem(
      onSelect: onSelect,
      focusPadding: theme.letterFocusPadding,
      builder: (context, isFocused) {
        final Set<WidgetState> states = isFocused ? {WidgetState.focused} : {};

        return Icon(
          CupertinoIcons.globe,
          size: theme.switchLocaleIconSize,
          color: theme.letterTextStyle?.resolve(states).color,
        );
      },
    );
  }
}

final class _LangLabel extends StatelessWidget {
  const _LangLabel({required this.currentLocale, required this.localization});

  final Locale currentLocale;
  final CupertinoTvSearchBarLocalization localization;

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTvSearchBarTheme.of(context);
    final keyboardLayout =
        localization.keyboardLayoutTranslation[currentLocale] ??
        currentLocale.languageCode;

    return Padding(
      padding: theme.letterFocusPadding ?? EdgeInsets.zero,
      child: Text(keyboardLayout, style: theme.letterTextStyle?.resolve({})),
    );
  }
}
