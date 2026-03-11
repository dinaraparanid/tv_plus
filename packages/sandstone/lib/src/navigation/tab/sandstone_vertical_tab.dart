part of 'tab.dart';

final class SandstoneVerticalTab {
  const SandstoneVerticalTab({
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

  final WidgetStateProperty<Widget> Function(
    BuildContext context,
    bool isExpanded,
  )?
  iconBuilder;

  final Widget Function(
    BuildContext context,
    Set<WidgetState> itemStates,
    bool isExpanded,
    Widget? icon,
  )
  builder;
}

extension _MenuItemMapper on SandstoneVerticalTab {
  TvNavigationMenuItem toMenuItem({required bool isExpanded}) {
    final ic = iconBuilder;

    return TvNavigationMenuItem(
      key: key,
      isSelectable: isSelectable,
      canRequestFocus: canRequestFocus,
      onSelect: onSelect,
      iconBuilder: ic == null ? null : (context) => ic(context, isExpanded),
      builder: (context, states, icon) {
        return builder(context, states, isExpanded, icon);
      },
    );
  }
}
