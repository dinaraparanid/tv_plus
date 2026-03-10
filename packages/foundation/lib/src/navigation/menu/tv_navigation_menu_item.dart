part of 'menu.dart';

final class TvNavigationMenuItem {
  const TvNavigationMenuItem({
    this.key,
    this.isSelectable = true,
    this.canRequestFocus = true,
    required this.iconBuilder,
    this.onSelect,
    required this.builder,
  });

  final Key? key;
  final bool isSelectable;
  final bool canRequestFocus;
  final VoidCallback? onSelect;

  final WidgetStateProperty<Widget> Function(BuildContext context)? iconBuilder;

  final Widget Function(
    BuildContext context,
    Set<WidgetState> itemStates,
    Widget? icon,
  )
  builder;
}
