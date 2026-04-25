part of 'search.dart';

final class CupertinoTvSearchBarTheme extends InheritedWidget {
  const CupertinoTvSearchBarTheme({
    super.key,
    CupertinoTvSearchBarThemeData? data,
    required super.child,
  }) : data = data ?? const CupertinoTvSearchBarThemeData();

  final CupertinoTvSearchBarThemeData data;

  static CupertinoTvSearchBarThemeData? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CupertinoTvSearchBarTheme>()
        ?.data;
  }

  static CupertinoTvSearchBarThemeData of(BuildContext context) {
    return maybeOf(context)!;
  }

  @override
  bool updateShouldNotify(covariant CupertinoTvSearchBarTheme oldWidget) {
    return data != oldWidget.data;
  }
}

@immutable
final class CupertinoTvSearchBarThemeData {
  const CupertinoTvSearchBarThemeData({
    this.queryStyle,
    this.placeholderStyle,
    this.letterTextStyle,
    this.buttonTextStyle,
    this.keyboardTypeExpandedTextStyle,
    this.letterDecoration,
    this.keyboardTypeExpandedDecoration,
    this.buttonContentColor,
    this.keyboardTypeExpandedBackgroundColor,
    this.letterFocusPadding,
    this.buttonFillPadding,
    this.buttonFocusPadding,
    this.letterSpacing,
    this.buttonRadius,
    this.keyboardTypeExpandedRadius,
    this.switchLocaleIconSize,
    this.spaceBetweenQueryAndInput,
    this.switchLanguageRadialOpacityAnimationRadius = 8,
    this.switchLanguageLabelShowDuration = const Duration(milliseconds: 400),
    this.switchLanguageLabelHideDuration = const Duration(milliseconds: 200),
  });

  final TextStyle? queryStyle;
  final TextStyle? placeholderStyle;
  final WidgetStateProperty<TextStyle>? letterTextStyle;
  final WidgetStateProperty<TextStyle>? buttonTextStyle;
  final WidgetStateProperty<TextStyle>? keyboardTypeExpandedTextStyle;
  final WidgetStateProperty<Decoration>? letterDecoration;
  final WidgetStateProperty<Decoration>? keyboardTypeExpandedDecoration;
  final WidgetStateProperty<Color>? buttonContentColor;
  final Color? keyboardTypeExpandedBackgroundColor;
  final EdgeInsetsGeometry? letterFocusPadding;
  final EdgeInsetsGeometry? buttonFillPadding;
  final EdgeInsetsGeometry? buttonFocusPadding;
  final double? letterSpacing;
  final BorderRadiusGeometry? buttonRadius;
  final BorderRadiusGeometry? keyboardTypeExpandedRadius;
  final double? switchLocaleIconSize;
  final double? spaceBetweenQueryAndInput;
  final double switchLanguageRadialOpacityAnimationRadius;
  final Duration switchLanguageLabelShowDuration;
  final Duration switchLanguageLabelHideDuration;
}
