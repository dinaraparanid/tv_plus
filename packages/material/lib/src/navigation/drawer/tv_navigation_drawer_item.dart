part of 'drawer.dart';

final class TvNavigationDrawerItem {
  const TvNavigationDrawerItem({
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
    BoxConstraints constraints,
    Set<WidgetState> itemStates,
    Widget? icon,
  )
  builder;
}

extension _MenuItemMapper on TvNavigationDrawerItem {
  TvNavigationMenuItem toMenuItem() {
    return TvNavigationMenuItem(
      key: key,
      isSelectable: isSelectable,
      canRequestFocus: canRequestFocus,
      onSelect: onSelect,
      iconBuilder: iconBuilder,
      builder: (context, states, icon) => LayoutBuilder(
        builder: (context, constraints) {
          return builder(context, constraints, states, icon);
        },
      ),
    );
  }
}
