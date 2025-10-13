import 'package:flutter/material.dart';

import '../../dpad/dpad.dart';

final class TvNavigationDrawer extends StatefulWidget {
  const TvNavigationDrawer({
    super.key,
    this.header,
    this.footer,
    this.backgroundColor,
    this.drawerDecoration,
    this.drawerPadding = const EdgeInsets.all(12),
    this.itemSpacing = 12,
    required this.items,
    required this.initialItemIndex,
    required this.builder,
  });

  final Widget? header;
  final Widget? footer;
  final Color? backgroundColor;
  final BoxDecoration? drawerDecoration;
  final EdgeInsets drawerPadding;
  final double itemSpacing;
  final List<Widget> items;
  final int initialItemIndex;
  final Widget Function(BuildContext context, int index) builder;

  @override
  State<StatefulWidget> createState() => _TvNavigationDrawerState();
}

final class _TvNavigationDrawerState extends State<TvNavigationDrawer> {

  late int selectedIndex;

  late final FocusNode? headerFocusNode;
  late final FocusNode? footerFocusNode;
  late final List<FocusNode> itemsFocusNodes;
  late final List<FocusNode> focusNodes;
  late final Listenable focusListenable;

  var hasFocus = false;

  @override
  void initState() {
    selectedIndex = widget.initialItemIndex;

    headerFocusNode = widget.header != null ? FocusNode() : null;
    footerFocusNode = widget.footer != null ? FocusNode() : null;
    itemsFocusNodes = List.generate(widget.items.length, (_) => FocusNode());
    focusNodes = [?headerFocusNode, ?footerFocusNode, ...itemsFocusNodes];

    focusListenable = Listenable
        .merge(focusNodes)
        ..addListener(focusChangeListener);

    super.initState();
  }

  void focusChangeListener() {
    final nextHasFocus = focusNodes.any((it) => it.hasFocus);

    if (nextHasFocus != hasFocus) {
      setState(() => hasFocus = nextHasFocus);
    }
  }

  @override
  void dispose() {
    focusListenable.removeListener(focusChangeListener);
    headerFocusNode?.dispose();
    footerFocusNode?.dispose();

    for (final it in itemsFocusNodes) {
      it.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.backgroundColor,
      child: LayoutBuilder(
        builder: (context, _) {
          return Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                constraints: const BoxConstraints(minWidth: 80, maxWidth: 280),
                width: hasFocus ? 80 : 280,
                decoration: widget.drawerDecoration,
                padding: widget.drawerPadding,
                child: Column(
                  spacing: widget.itemSpacing,
                  children: [
                    if (widget.header != null) DpadFocus(
                      focusNode: headerFocusNode,
                      child: widget.header!,
                    ),

                    const Spacer(),

                    ...widget.items.indexed.map((indexWithWidget) {
                      final (index, widget) = indexWithWidget;

                      return DpadFocus(
                        focusNode: itemsFocusNodes[index],
                        child: widget,
                      );
                    }),

                    const Spacer(),

                    if (widget.footer != null) DpadFocus(
                      focusNode: footerFocusNode,
                      child: widget.footer!,
                    ),
                  ],
                ),
              ),

              Expanded(child: widget.builder(context, selectedIndex)),
            ],
          );
        },
      ),
    );
  }
}
