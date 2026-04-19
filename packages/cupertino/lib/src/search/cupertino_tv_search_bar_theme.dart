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
    this.letterFocusDecoration,
    this.buttonContentColor,
    this.letterFocusPadding,
    this.buttonFillPadding,
    this.buttonFocusPadding,
    this.letterSpacing,
    this.buttonRadius,
    this.switchLocaleIconSize,
    this.spaceBetweenQueryAndInput,
  });

  final TextStyle? queryStyle;
  final TextStyle? placeholderStyle;
  final WidgetStateProperty<TextStyle>? letterTextStyle;
  final WidgetStateProperty<TextStyle>? buttonTextStyle;
  final WidgetStateProperty<Decoration>? letterFocusDecoration;
  final WidgetStateProperty<Color>? buttonContentColor;
  final EdgeInsetsGeometry? letterFocusPadding;
  final EdgeInsetsGeometry? buttonFillPadding;
  final EdgeInsetsGeometry? buttonFocusPadding;
  final double? letterSpacing;
  final BorderRadiusGeometry? buttonRadius;
  final double? switchLocaleIconSize;
  final double? spaceBetweenQueryAndInput;
}
