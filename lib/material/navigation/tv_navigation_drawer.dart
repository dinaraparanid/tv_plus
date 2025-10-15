import 'package:flutter/material.dart';

import '../../dpad/dpad.dart';
import '../material.dart';
import 'selection_entry.dart';
import 'tv_navigation_drawer_controller.dart';

final class TvNavigationDrawer extends StatefulWidget {
  const TvNavigationDrawer({
    super.key,
    this.controller,
    this.childNode,
    this.headerBuilder,
    this.footerBuilder,
    this.backgroundColor,
    this.drawerDecoration,
    this.constraints = const BoxConstraints(minWidth: 90, maxWidth: 280),
    this.drawerPadding = const EdgeInsets.all(12),
    this.drawerExpandDuration = const Duration(milliseconds: 300),
    required this.itemCount,
    required this.initialSelectedIndex,
    required this.itemBuilder,
    this.separatorBuilder,
    required this.builder,
  }) : assert(itemCount > 0);

  final TvNavigationDrawerController? controller;
  final FocusNode? childNode;
  final TvNavigationItem Function()? headerBuilder;
  final TvNavigationItem Function()? footerBuilder;
  final Color? backgroundColor;
  final BoxDecoration? drawerDecoration;
  final BoxConstraints constraints;
  final EdgeInsets drawerPadding;
  final Duration drawerExpandDuration;
  final int itemCount;
  final int initialSelectedIndex;
  final TvNavigationItem Function(int index) itemBuilder;
  final Widget Function(int index)? separatorBuilder;
  final Widget Function(
    BuildContext context,
    SelectionEntry entry,
    FocusNode childFocusNode,
  ) builder;

  @override
  State<StatefulWidget> createState() => _TvNavigationDrawerState();
}

final class _TvNavigationDrawerState extends State<TvNavigationDrawer> {

  late final TvNavigationDrawerController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    _controller = widget.controller ?? TvNavigationDrawerController(
      initialSelectedIndex: widget.initialSelectedIndex,
      itemCount: widget.itemCount,
      childNode: widget.childNode,
    );

    _ownsController = widget.controller == null;

    _controller.addListener(_controllerListener);

    super.initState();
  }

  void _controllerListener() => setState(() {});

  @override
  void dispose() {
    _controller.removeListener(_controllerListener);

    if (_ownsController) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      key: widget.key,
      color: widget.backgroundColor,
      child: LayoutBuilder(
        builder: (context, _) {
          return Row(
            children: [
              AnimatedContainer(
                duration: widget.drawerExpandDuration,
                constraints: widget.constraints.copyWith(
                  maxWidth: _controller.hasFocus
                      ? null
                      : widget.constraints.minWidth,
                ),
                decoration: widget.drawerDecoration,
                padding: widget.drawerPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.headerBuilder != null) _Header(
                      item: widget.headerBuilder!(),
                      controller: _controller,
                      drawerExpandDuration: widget.drawerExpandDuration,
                    ),

                    const Spacer(),

                    for (var i = 0; i < widget.itemCount; ++i)
                      ...[
                        if (i != 0)
                          ?widget.separatorBuilder?.call(i),

                        _Item(
                          index: i,
                          item: widget.itemBuilder(i),
                          controller: _controller,
                          drawerExpandDuration: widget.drawerExpandDuration,
                        ),
                      ],

                    const Spacer(),

                    if (widget.footerBuilder != null) _Footer(
                      item: widget.footerBuilder!(),
                      controller: _controller,
                      drawerExpandDuration: widget.drawerExpandDuration,
                    ),
                  ],
                ),
              ),

              Expanded(
                child: widget.builder(
                  context,
                  _controller.entry,
                  _controller.childFocusNode,
                ),
              ),
            ],
          );
        },
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
        widget.controller.select(HeaderEntry());
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
          isSelected: widget.controller.entry == HeaderEntry(),
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
        widget.controller.select(FooterEntry());
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
          isSelected: widget.controller.entry == FooterEntry(),
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
