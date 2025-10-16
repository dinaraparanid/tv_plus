import 'package:flutter/widgets.dart';

@immutable
final class TvNavigationItem {
  const TvNavigationItem({
    required this.icon,
    this.iconColor,
    this.iconSpacing = 12,
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: 12,
      horizontal: 16,
    ),
    required this.decoration,
    this.onSelect,
    required this.builder,
  });

  final WidgetStateProperty<Icon> icon;
  final Color? iconColor;
  final double iconSpacing;
  final EdgeInsets contentPadding;
  final WidgetStateProperty<BoxDecoration> decoration;
  final VoidCallback? onSelect;

  final Widget Function(
    BuildContext context,
    BoxConstraints itemConstraints,
    Set<WidgetState> itemStates,
  ) builder;
}
