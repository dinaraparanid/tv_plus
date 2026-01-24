part of 'menu.dart';

final class TvNavigationMenuItem {
  TvNavigationMenuItem({
    this.key,
    this.isSelectable = true,
    this.canRequestFocus = true,
    this.icon,
    this.iconSpacing = 12,
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: 12,
      horizontal: 16,
    ),
    this.decoration,
    this.onSelect,
    required this.builder,
  }) {
    if (isSelectable && icon == null) {
      throw ArgumentError.value(
        icon,
        'icon',
        'must not be null if isSelectable is true',
      );
    }
  }

  final Key? key;
  final bool isSelectable;
  final bool canRequestFocus;
  final WidgetStateProperty<Widget>? icon;
  final double iconSpacing;
  final EdgeInsets contentPadding;
  final WidgetStateProperty<Decoration>? decoration;
  final VoidCallback? onSelect;

  final Widget Function(
    BuildContext context,
    BoxConstraints itemConstraints,
    Set<WidgetState> itemStates,
  )
  builder;
}
