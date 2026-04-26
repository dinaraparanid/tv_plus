part of 'search.dart';

final class _KeyboardTypeButton extends StatefulWidget {
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
  State<StatefulWidget> createState() => _KeyboardTypeButtonState();
}

final class _KeyboardTypeButtonState extends State<_KeyboardTypeButton> {
  final _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  OverlayEntry _createOverlayEntry() {
    final theme = CupertinoTvSearchBarTheme.of(context);

    final nextKeyboards = CupertinoTvSearchBarKeyboardType.values
        .where((e) => e != widget.keyboardType)
        .toList(growable: false);

    return OverlayEntry(
      builder: (context) => CupertinoTvSearchBarTheme(
        data: theme,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          child: Wrap(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color:
                      theme.keyboardTypeExpandedBackgroundColor ??
                      CupertinoColors.systemGrey,
                  borderRadius: theme.keyboardTypeExpandedRadius,
                ),
                child: DpadFocusScope(
                  autofocus: true,
                  builder: (_, _) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final (i, keyboard) in nextKeyboards.indexed) ...[
                        _KeyboardTypeButtonExpand(
                          autofocus: i == 0,
                          keyboardType: keyboard,
                          localization: widget.localization,
                          currentLocale: widget.currentLocale,
                          onSelect: () {
                            widget.onSelect();
                            _hideOverlay();
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: _KeyboardTypeContent(
        keyboardType: widget.keyboardType.next,
        localization: widget.localization,
        currentLocale: widget.currentLocale,
        onSelect: widget.onSelect,
        onLongSelect: () {
          _overlayEntry = _createOverlayEntry();
          Overlay.of(context).insert(_overlayEntry!);
        },
      ),
    );
  }
}

final class _KeyboardTypeContent extends StatelessWidget {
  const _KeyboardTypeContent({
    required this.keyboardType,
    required this.localization,
    required this.currentLocale,
    required this.onSelect,
    this.onLongSelect,
  });

  final CupertinoTvSearchBarKeyboardType keyboardType;
  final CupertinoTvSearchBarLocalization localization;
  final Locale currentLocale;
  final VoidCallback onSelect;
  final VoidCallback? onLongSelect;

  @override
  Widget build(BuildContext context) {
    return _Rect(
      onSelect: onSelect,
      onLongSelect: onLongSelect,
      text: switch (keyboardType) {
        CupertinoTvSearchBarKeyboardType.letters =>
          localization.keyboardTypeTranslation[currentLocale]!,

        CupertinoTvSearchBarKeyboardType.numbers => '123',

        CupertinoTvSearchBarKeyboardType.special => '#+=',
      },
    );
  }
}

final class _KeyboardTypeButtonExpand extends StatelessWidget {
  const _KeyboardTypeButtonExpand({
    required this.keyboardType,
    required this.localization,
    required this.currentLocale,
    this.autofocus = false,
    required this.onSelect,
  });

  final CupertinoTvSearchBarKeyboardType keyboardType;
  final CupertinoTvSearchBarLocalization localization;
  final Locale currentLocale;
  final bool autofocus;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTvSearchBarTheme.of(context);

    return _CupertinoTvSearchBarItem(
      autofocus: autofocus,
      onSelect: onSelect,
      focusPadding: theme.buttonFocusPadding,
      builder: (context, isFocused) {
        final theme = CupertinoTvSearchBarTheme.of(context);
        final Set<WidgetState> states = isFocused ? {WidgetState.focused} : {};

        return Container(
          padding: theme.buttonFillPadding ?? EdgeInsets.zero,
          decoration: theme.keyboardTypeExpandedDecoration?.resolve(states),
          child: Text(switch (keyboardType) {
            CupertinoTvSearchBarKeyboardType.letters =>
              localization.keyboardTypeTranslation[currentLocale]!,

            CupertinoTvSearchBarKeyboardType.numbers => '123',

            CupertinoTvSearchBarKeyboardType.special => '#+=',
          }, style: theme.keyboardTypeExpandedTextStyle?.resolve(states)),
        );
      },
    );
  }
}
