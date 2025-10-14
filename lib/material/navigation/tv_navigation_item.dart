import 'package:flutter/widgets.dart';

@immutable
final class TvNavigationItem {
  const TvNavigationItem({
    this.isSelected = false,
    required this.icon,
    this.iconSize = 32,
    this.iconSpacing = 12,
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: 12,
      horizontal: 16,
    ),
    required this.decoration,
    this.onSelect,
    required this.builder,
  });

  final bool isSelected;
  final IconData icon;
  final double iconSize;
  final double iconSpacing;
  final EdgeInsets contentPadding;
  final WidgetStateProperty<BoxDecoration> decoration;
  final VoidCallback? onSelect;

  final Widget Function(
    BuildContext context,
    BoxConstraints itemConstraints,
    Set<WidgetState> itemStates,
    bool isDrawerExpanded,
  ) builder;
}
