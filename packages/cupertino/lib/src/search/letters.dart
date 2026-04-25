part of 'search.dart';

final class _Letters extends StatelessWidget {
  const _Letters({required this.controller, required this.opacity});
  final CupertinoTvSearchController controller;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTvSearchBarTheme.of(context);
    final localization = controller.localization;
    final currentLocale = controller.currentLocale;
    final keyboardType = controller.keyboardType;

    final alphabet = switch (keyboardType) {
      CupertinoTvSearchBarKeyboardType.letters =>
        localization.supportedAlphabets[currentLocale]!,

      CupertinoTvSearchBarKeyboardType.numbers => const [
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        '0',
      ],

      CupertinoTvSearchBarKeyboardType.special => const [
        '`',
        "'",
        '"',
        ';',
        ':',
        '~',
        '=',
        '*',
        '+',
        '-',
        ',',
        '.',
        '?',
        '!',
        '@',
        '#',
        '\$',
        '%',
        '^',
        '&',
        '|',
        '/',
        '\\',
        '(',
        ')',
        '[',
        ']',
        '{',
        '}',
        '<',
        '>',
      ],
    };

    return Opacity(
      opacity: 1 - opacity / 2,
      child: ShaderMask(
        shaderCallback: (bounds) => RadialGradient(
          center: Alignment.center,
          radius: theme.switchLanguageRadialOpacityAnimationRadius,
          stops: const [0, 1],
          colors: [
            Color.lerp(
              CupertinoColors.transparent,
              CupertinoColors.black,
              1 - opacity,
            )!,
            CupertinoColors.black,
          ],
        ).createShader(bounds),
        blendMode: BlendMode.dstIn,
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
    );
  }
}
