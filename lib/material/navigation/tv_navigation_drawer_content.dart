import 'package:flutter/material.dart';

import '../../dpad/dpad.dart';
import 'selection_entry.dart';
import 'tv_navigation_drawer_controller.dart';
import 'tv_navigation_item.dart';

final class TvNavigationDrawerContent extends StatelessWidget {
  const TvNavigationDrawerContent({
    super.key,
    required this.controller,
    required this.headerBuilder,
    required this.footerBuilder,
    required this.drawerDecoration,
    required this.constraints,
    required this.drawerPadding,
    required this.drawerExpandDuration,
    required this.itemCount,
    required this.itemBuilder,
    required this.separatorBuilder,
  });

  final TvNavigationDrawerController controller;
  final TvNavigationItem Function()? headerBuilder;
  final TvNavigationItem Function()? footerBuilder;
  final BoxDecoration? drawerDecoration;
  final BoxConstraints constraints;
  final EdgeInsets drawerPadding;
  final Duration drawerExpandDuration;
  final int itemCount;
  final TvNavigationItem Function(int index) itemBuilder;
  final Widget Function(int index)? separatorBuilder;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: drawerExpandDuration,
      constraints: constraints.copyWith(
        maxWidth: controller.hasFocus ? null : constraints.minWidth,
      ),
      decoration: drawerDecoration,
      padding: drawerPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (headerBuilder != null) _Header(
            item: headerBuilder!(),
            controller: controller,
            drawerExpandDuration: drawerExpandDuration,
          ),

          const Spacer(),

          for (var i = 0; i < itemCount; ++i)
            ...[
              if (i != 0)
                ?separatorBuilder?.call(i),

              _Item(
                index: i,
                item: itemBuilder(i),
                controller: controller,
                drawerExpandDuration: drawerExpandDuration,
              ),
            ],

          const Spacer(),

          if (footerBuilder != null) _Footer(
            item: footerBuilder!(),
            controller: controller,
            drawerExpandDuration: drawerExpandDuration,
          ),
        ],
      ),
    );
  }
}

final class _Header extends StatefulWidget {
  const _Header({
    required this.item,
    required this.controller,
    required this.drawerExpandDuration,
  });

  final TvNavigationItem item;
  final TvNavigationDrawerController controller;
  final Duration drawerExpandDuration;

  @override
  State<StatefulWidget> createState() => _HeaderState();
}

final class _HeaderState extends State<_Header> {

  late final node = widget.controller.headerFocusNode;

  @override
  void initState() {
    node.addListener(_focusListener);
    super.initState();
  }

  void _focusListener() => setState(() {});

  @override
  void dispose() {
    node.removeListener(_focusListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DpadFocus(
      focusNode: node,
      onSelect: (_, _) {
        widget.controller.select(const HeaderEntry());
        widget.item.onSelect?.call();
        return KeyEventResult.handled;
      },
      onDown: (_, _) {
        widget.controller.itemsFocusNodes.first.requestFocus();
        return KeyEventResult.handled;
      },
      onRight: (_, _) {
        widget.controller.childFocusNode.requestFocus();
        return KeyEventResult.handled;
      },
      builder: (node) {
        return _TvNavigationDrawerItem(
          model: widget.item,
          node: node,
          isSelected: widget.controller.entry == const HeaderEntry(),
          isDrawerExpanded: widget.controller.hasFocus,
          drawerExpandDuration: widget.drawerExpandDuration,
        );
      },
    );
  }
}

final class _Item extends StatefulWidget {
  const _Item({
    required this.index,
    required this.item,
    required this.controller,
    required this.drawerExpandDuration,
  });

  final int index;
  final TvNavigationItem item;
  final TvNavigationDrawerController controller;
  final Duration drawerExpandDuration;

  @override
  State<StatefulWidget> createState() => _ItemState();
}

final class _ItemState extends State<_Item> {

  late final node = widget.controller.itemsFocusNodes[widget.index];

  @override
  void initState() {
    node.addListener(_focusListener);
    super.initState();
  }

  void _focusListener() => setState(() {});

  @override
  void dispose() {
    node.removeListener(_focusListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DpadFocus(
      focusNode: node,
      onSelect: (_, _) {
        widget.controller.select(ItemEntry(index: widget.index));
        widget.item.onSelect?.call();
        return KeyEventResult.handled;
      },
      onUp: (_, _) {
        switch (widget.index) {
          case 0:
            widget.controller.headerFocusNode.requestFocus();

          default:
            widget.controller.itemsFocusNodes[widget.index - 1].requestFocus();
        }

        return KeyEventResult.handled;
      },
      onDown: (_, _) {
        if (widget.index == widget.controller.itemCount - 1) {
          widget.controller.footerFocusNode.requestFocus();
        } else {
          widget.controller.itemsFocusNodes[widget.index + 1].requestFocus();
        }

        return KeyEventResult.handled;
      },
      onRight: (_, _) {
        widget.controller.childFocusNode.requestFocus();
        return KeyEventResult.handled;
      },
      builder: (node) {
        final isSelected = widget.controller.entry ==
            ItemEntry(index: widget.index);

        return _TvNavigationDrawerItem(
          model: widget.item,
          node: node,
          isSelected: isSelected,
          isDrawerExpanded: widget.controller.hasFocus,
          drawerExpandDuration: widget.drawerExpandDuration,
        );
      },
    );
  }
}

final class _Footer extends StatefulWidget {
  const _Footer({
    required this.item,
    required this.controller,
    required this.drawerExpandDuration,
  });

  final TvNavigationItem item;
  final TvNavigationDrawerController controller;
  final Duration drawerExpandDuration;

  @override
  State<StatefulWidget> createState() => _FooterState();
}

final class _FooterState extends State<_Footer> {

  late final node = widget.controller.footerFocusNode;

  @override
  void initState() {
    node.addListener(_focusListener);
    super.initState();
  }

  void _focusListener() => setState(() {});

  @override
  void dispose() {
    node.removeListener(_focusListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DpadFocus(
      focusNode: node,
      onSelect: (_, _) {
        widget.item.onSelect?.call();
        widget.controller.select(const FooterEntry());
        return KeyEventResult.handled;
      },
      onDown: (_, _) {
        widget.controller.itemsFocusNodes.last.requestFocus();
        return KeyEventResult.handled;
      },
      onRight: (_, _) {
        widget.controller.childFocusNode.requestFocus();
        return KeyEventResult.handled;
      },
      builder: (node) {
        return _TvNavigationDrawerItem(
          model: widget.item,
          node: node,
          isSelected: widget.controller.entry == const FooterEntry(),
          isDrawerExpanded: widget.controller.hasFocus,
          drawerExpandDuration: widget.drawerExpandDuration,
        );
      },
    );
  }
}

final class _TvNavigationDrawerItem extends StatelessWidget {
  const _TvNavigationDrawerItem({
    required this.model,
    required this.node,
    this.isSelected = false,
    required this.isDrawerExpanded,
    required this.drawerExpandDuration,
  });

  final TvNavigationItem model;
  final FocusNode node;
  final bool isSelected;
  final bool isDrawerExpanded;
  final Duration drawerExpandDuration;

  @override
  Widget build(BuildContext context) {
    final Set<WidgetState> focusedState = node.hasFocus
        ? { WidgetState.focused }
        : {};

    final widgetState = isSelected
        ? { WidgetState.selected, ...focusedState }
        : focusedState;

    return AnimatedContainer(
      duration: drawerExpandDuration,
      padding: model.contentPadding,
      decoration: model.decoration.resolve(widgetState),
      child: Row(
        children: [
          Flexible(flex: 0, child: Icon(model.icon, size: model.iconSize)),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: EdgeInsets.only(left: model.iconSpacing),
                  child: model.builder(context, constraints, widgetState),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
