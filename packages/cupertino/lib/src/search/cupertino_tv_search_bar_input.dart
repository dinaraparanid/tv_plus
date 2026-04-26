part of 'search.dart';

final class _CupertinoTvSearchBarInput extends StatefulWidget {
  const _CupertinoTvSearchBarInput({required this.controller});
  final CupertinoTvSearchController controller;

  @override
  State<StatefulWidget> createState() => _CupertinoTvSearchBarInputState();
}

final class _CupertinoTvSearchBarInputState
    extends State<_CupertinoTvSearchBarInput>
    with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: CupertinoTvSearchBarTheme.of(
      context,
    ).switchLanguageLabelShowDuration,
  );

  late var _currentLocale = widget.controller.currentLocale;
  late var _currentKeyboardType = widget.controller.keyboardType;

  @override
  void initState() {
    widget.controller.addListener(_listener);
    super.initState();
  }

  void _listener() async {
    final nextLocale = widget.controller._currentLocale;
    final nextKeyboardType = widget.controller._keyboardType;

    if (_currentLocale != nextLocale) {
      final theme = CupertinoTvSearchBarTheme.of(context);

      setState(() => _currentLocale = nextLocale);
      await _animationController.animateTo(1, duration: Duration.zero);
      await Future.delayed(theme.switchLanguageLabelShowDuration);
      await _animationController.animateTo(
        0,
        duration: theme.switchLanguageLabelHideDuration,
      );
    }

    if (_currentKeyboardType != nextKeyboardType) {
      setState(() => _currentKeyboardType = nextKeyboardType);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AnimatedContent(
      controller: widget.controller,
      animController: _animationController,
    );
  }
}

final class _AnimatedContent extends AnimatedWidget {
  const _AnimatedContent({
    required this.controller,
    required AnimationController animController,
  }) : super(listenable: animController);

  final CupertinoTvSearchController controller;

  Animation<double> get _opacityAnimation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTvSearchBarTheme.of(context);
    final localization = controller.localization;
    final currentLocale = controller.currentLocale;
    final space = localization.spaceTranslation[currentLocale] ?? 'SPACE';

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: theme.letterSpacing ?? 0,
      children: [
        _LangButton(onSelect: controller.switchToNextLocale),

        _KeyboardTypeButton(
          keyboardType: controller.keyboardType,
          localization: localization,
          currentLocale: currentLocale,
          onSelect: controller.switchToNextKeyboardType,
        ),

        _Rect(text: space, onSelect: () => controller.append(' ')),

        Flexible(
          child: Stack(
            children: [
              _Letters(
                controller: controller,
                opacity: _opacityAnimation.value,
              ),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Stack(
                  children: [
                    Align(
                      child: Opacity(
                        opacity: _opacityAnimation.value,
                        child: _LangLabel(
                          currentLocale: controller.currentLocale,
                          localization: controller.localization,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        _Eraser(onSelect: controller.removeLast),
      ],
    );
  }
}

final class _Rect extends StatelessWidget {
  const _Rect({required this.text, required this.onSelect, this.onLongSelect});

  final String text;
  final VoidCallback onSelect;
  final VoidCallback? onLongSelect;

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTvSearchBarTheme.of(context);

    return _CupertinoTvSearchBarItem(
      onSelect: onSelect,
      onLongSelect: onLongSelect,
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
