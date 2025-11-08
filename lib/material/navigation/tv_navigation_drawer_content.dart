import 'package:flutter/material.dart';

import '../../foundation/foundation.dart';

final class TvNavigationDrawerContent extends StatefulWidget {
  const TvNavigationDrawerContent({
    super.key,
    required this.controller,
    required this.headerBuilder,
    required this.footerBuilder,
    required this.drawerDecoration,
    required this.constraints,
    required this.drawerPadding,
    required this.drawerExpandDuration,
    required this.menuItems,
    required this.separatorBuilder,
  });

  final TvNavigationController controller;
  final TvNavigationItem Function()? headerBuilder;
  final TvNavigationItem Function()? footerBuilder;
  final BoxDecoration? drawerDecoration;
  final BoxConstraints constraints;
  final EdgeInsets drawerPadding;
  final Duration drawerExpandDuration;
  final List<TvNavigationItem> menuItems;
  final Widget Function(int index)? separatorBuilder;

  @override
  State<StatefulWidget> createState() => _TvNavigationDrawerContentState();
}

final class _TvNavigationDrawerContentState
    extends State<TvNavigationDrawerContent> {
  @override
  void initState() {
    _attachItemsFocusNodes();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TvNavigationDrawerContent oldWidget) {
    if (oldWidget.menuItems != widget.menuItems) {
      _attachItemsFocusNodes();
    }

    super.didUpdateWidget(oldWidget);
  }

  void _attachItemsFocusNodes() {
    widget.controller.attachItemsFocusNodes(
      widget.menuItems.map((child) => child.key).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.drawerExpandDuration,
      constraints: widget.constraints.copyWith(
        maxWidth: widget.controller.hasFocus
            ? null
            : widget.constraints.minWidth,
      ),
      decoration: widget.drawerDecoration,
      padding: widget.drawerPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.headerBuilder != null)
            _Header(
              item: widget.headerBuilder!(),
              controller: widget.controller,
              drawerExpandDuration: widget.drawerExpandDuration,
            ),

          const Spacer(),

          for (final (index, child) in widget.menuItems.indexed) ...[
            if (index != 0) ?widget.separatorBuilder?.call(index),

            _Item(
              index: index,
              item: child,
              controller: widget.controller,
              drawerExpandDuration: widget.drawerExpandDuration,
            ),
          ],

          const Spacer(),

          if (widget.footerBuilder != null)
            _Footer(
              item: widget.footerBuilder!(),
              controller: widget.controller,
              drawerExpandDuration: widget.drawerExpandDuration,
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
  final TvNavigationController controller;
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
      key: widget.key,
      focusNode: node,
      onSelect: (_, _) {
        widget.controller.select(const HeaderEntry());
        widget.item.onSelect?.call();
        return KeyEventResult.handled;
      },
      onDown: (_, _) {
        widget.controller.getItemFocusNodeAt(0)!.requestFocus();
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
  final TvNavigationController controller;
  final Duration drawerExpandDuration;

  @override
  State<StatefulWidget> createState() => _ItemState();
}

final class _ItemState extends State<_Item> {
  late final FocusNode node;

  @override
  void initState() {
    node = widget.controller.getItemFocusNodeAt(widget.index)!
      ..addListener(_focusListener);

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
    final entryKey = widget.item.key;

    return DpadFocus(
      key: entryKey,
      focusNode: node,
      onSelect: (_, _) {
        widget.controller.select(ItemEntry(key: entryKey));
        widget.item.onSelect?.call();
        return KeyEventResult.handled;
      },
      onUp: (_, _) {
        switch (widget.index) {
          case 0:
            widget.controller.headerFocusNode.requestFocus();

          default:
            widget.controller
                .getItemFocusNodeAt(widget.index - 1)!
                .requestFocus();
        }

        return KeyEventResult.handled;
      },
      onDown: (_, _) {
        if (widget.index == widget.controller.itemCount - 1) {
          widget.controller.footerFocusNode.requestFocus();
        } else {
          widget.controller
              .getItemFocusNodeAt(widget.index + 1)!
              .requestFocus();
        }

        return KeyEventResult.handled;
      },
      onRight: (_, _) {
        widget.controller.childFocusNode.requestFocus();
        return KeyEventResult.handled;
      },
      builder: (node) {
        final isSelected = widget.controller.entry == ItemEntry(key: entryKey);

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
  final TvNavigationController controller;
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
      key: widget.key,
      focusNode: node,
      onSelect: (_, _) {
        widget.item.onSelect?.call();
        widget.controller.select(const FooterEntry());
        return KeyEventResult.handled;
      },
      onUp: (_, _) {
        widget.controller
            .getItemFocusNodeAt(widget.controller.itemCount - 1)!
            .requestFocus();

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
        ? {WidgetState.focused}
        : {};

    final widgetState = isSelected
        ? {WidgetState.selected, ...focusedState}
        : focusedState;

    return AnimatedContainer(
      duration: drawerExpandDuration,
      padding: model.contentPadding,
      decoration: model.decoration.resolve(widgetState),
      child: Row(
        children: [
          Flexible(flex: 0, child: model.icon.resolve(widgetState)),
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
