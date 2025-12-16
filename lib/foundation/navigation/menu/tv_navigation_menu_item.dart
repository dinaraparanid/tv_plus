import 'package:flutter/widgets.dart';

final class TvNavigationMenuItem {
  const TvNavigationMenuItem({
    required this.key,
    required this.icon,
    this.iconSpacing = 12,
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: 12,
      horizontal: 16,
    ),
    required this.decoration,
    this.onSelect,
    required this.builder,
  });

  final Key key;
  final WidgetStateProperty<Icon> icon;
  final double iconSpacing;
  final EdgeInsets contentPadding;
  final WidgetStateProperty<BoxDecoration> decoration;
  final VoidCallback? onSelect;

  final Widget Function(
    BuildContext context,
    BoxConstraints itemConstraints,
    Set<WidgetState> itemStates,
  )
  builder;
}
