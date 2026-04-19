part of 'search.dart';

final class _CupertinoTvSearchBarInput extends StatelessWidget {
  const _CupertinoTvSearchBarInput({required this.controller});
  final CupertinoTvSearchController controller;

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTvSearchBarTheme.of(context);
    final localization = controller.localization;
    final currentLocale = controller.currentLocale;
    final space = localization.spaceTranslation[currentLocale] ?? 'SPACE';
    final alphabet = localization.supportedAlphabets[currentLocale]!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: theme.letterSpacing ?? 0,
      children: [
        _LangChanger(onSelect: controller.switchToNextLocale),

        _Rect(text: space, onSelect: () => controller.append(' ')),

        Flexible(
          child: DpadFocusScope(
            focusScopeNode: controller.lettersScopeNode,
            builder: (_, _) => Wrap(
              alignment: WrapAlignment.center,
              spacing: theme.letterSpacing ?? 0,
              runSpacing: theme.letterSpacing ?? 0,
              children: [
                for (final letter in alphabet)
                  _CupertinoTvSearchBarLetter(
                    letter: letter,
                    onSelect: () => controller.append(letter),
                  ),
              ],
            ),
          ),
        ),

        _Eraser(onSelect: controller.removeLast),
      ],
    );
  }
}

final class _LangChanger extends StatelessWidget {
  const _LangChanger({required this.onSelect});
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

final class _Rect extends StatelessWidget {
  const _Rect({required this.text, required this.onSelect});

  final String text;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTvSearchBarTheme.of(context);

    return _CupertinoTvSearchBarItem(
      onSelect: onSelect,
      focusPadding: theme.buttonFocusPadding,
      builder: (context, isFocused) {
        final theme = CupertinoTvSearchBarTheme.of(context);
        final Set<WidgetState> states = isFocused ? {WidgetState.focused} : {};

        return Container(
          padding: theme.buttonFillPadding ?? EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: theme.buttonRadius,
            color: isFocused
                ? theme.letterTextStyle?.resolve(states).color
                : null,
          ),
          child: Text(text, style: theme.buttonTextStyle?.resolve(states)),
        );
      },
    );
  }
}

final class _Eraser extends StatelessWidget {
  const _Eraser({required this.onSelect});
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
          CupertinoIcons.delete_left_fill,
          size: theme.switchLocaleIconSize,
          color: theme.letterTextStyle?.resolve(states).color,
        );
      },
    );
  }
}
