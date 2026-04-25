part of 'search.dart';

final class _KeyboardTypeButton extends StatelessWidget {
  const _KeyboardTypeButton({
    required this.keyboardType,
    required this.localization,
    required this.currentLocale,
    required this.onSelect,
  });

  final CupertinoTvSearchBarKeyboardType keyboardType;
  final CupertinoTvSearchBarLocalization localization;
  final Locale currentLocale;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return _Rect(
      text: switch (keyboardType) {
        CupertinoTvSearchBarKeyboardType.letters => '123',
        CupertinoTvSearchBarKeyboardType.numbers => '#+=',
        CupertinoTvSearchBarKeyboardType.special =>
          localization.keyboardTypeTranslation[currentLocale]!,
      },
      onSelect: onSelect,
    );
  }
}
