import 'package:flutter/material.dart';

import '../../dpad/dpad.dart';
import '../material.dart';

const _animatedDuration = Duration(milliseconds: 300);

final class TvNavigationDrawer extends StatefulWidget {
  const TvNavigationDrawer({
    super.key,
    this.headerBuilder,
    this.footerBuilder,
    this.backgroundColor,
    this.drawerDecoration,
    this.constraints = const BoxConstraints(minWidth: 90, maxWidth: 280),
    this.drawerPadding = const EdgeInsets.all(12),
    required this.itemCount,
    required this.itemBuilder,
    this.separatorBuilder,
    required this.initialItemIndex,
    required this.builder,
  }) : assert(itemCount > 0);

  final TvNavigationItem Function(FocusNode)? headerBuilder;
  final TvNavigationItem Function(FocusNode)? footerBuilder;
  final Color? backgroundColor;
  final BoxDecoration? drawerDecoration;
  final BoxConstraints constraints;
  final EdgeInsets drawerPadding;
  final int itemCount;

  final TvNavigationItem Function(
    FocusNode node,
    int index,
    bool isSelected,
  ) itemBuilder;

  final Widget Function(FocusNode, int, bool)? separatorBuilder;
  final int initialItemIndex;

  final Widget Function(
    BuildContext context,
    int index,
    FocusNode childNode,
    FocusNode drawerItemNode,
  ) builder;

  @override
  State<StatefulWidget> createState() => TvNavigationDrawerState();
}

final class TvNavigationDrawerState extends State<TvNavigationDrawer> {

  late int _selectedIndex;

  int get selectedIndex => _selectedIndex;
  FocusNode get selectedItemFocusNode => itemsFocusNodes[selectedIndex];

  late final FocusNode? headerFocusNode;
  late final FocusNode? footerFocusNode;
  late final FocusNode childFocusNode;
  late final List<FocusNode> itemsFocusNodes;
  late final List<FocusNode> _focusNodes;
  late final Listenable _focusListenable;

  var _hasFocus = false;
  bool get isExpanded => _hasFocus;

  @override
  void initState() {
    _selectedIndex = widget.initialItemIndex;

    headerFocusNode = widget.headerBuilder != null ? FocusNode() : null;
    footerFocusNode = widget.footerBuilder != null ? FocusNode() : null;
    childFocusNode = FocusNode();
    itemsFocusNodes = List.generate(widget.itemCount, (_) => FocusNode());
    _focusNodes = [?headerFocusNode, ?footerFocusNode, ...itemsFocusNodes];

    _focusListenable = Listenable
        .merge(_focusNodes)
        ..addListener(focusChangeListener);

    super.initState();
  }

  void focusChangeListener() {
    final nextHasFocus = _focusNodes.any((it) {
      return it.hasFocus;
    });

    if (nextHasFocus != _hasFocus) {
      setState(() => _hasFocus = nextHasFocus);
    }
  }

  @override
  void dispose() {
    _focusListenable.removeListener(focusChangeListener);
    headerFocusNode?.dispose();
    footerFocusNode?.dispose();
    childFocusNode.dispose();

    for (final it in itemsFocusNodes) {
      it.dispose();
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
                duration: _animatedDuration,
                constraints: widget.constraints.copyWith(
                  maxWidth: isExpanded ? null : widget.constraints.minWidth,
                ),
                decoration: widget.drawerDecoration,
                padding: widget.drawerPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.headerBuilder != null) () {
                      final item = widget.headerBuilder!(headerFocusNode!);
                      return DpadFocus(
                        focusNode: headerFocusNode,
                        onSelect: (_, _) {
                          item.onSelect?.call();
                          return KeyEventResult.handled;
                        },
                        onDown: (_, _) {
                          itemsFocusNodes.first.requestFocus();
                          return KeyEventResult.handled;
                        },
                        onRight: (_, _) {
                          childFocusNode.requestFocus();
                          return KeyEventResult.handled;
                        },
                        builder: (node) {
                          return _TvNavigationDrawerItem(
                            model: item,
                            node: node,
                            isDrawerExpanded: isExpanded,
                          );
                        },
                      );
                    }(),

                    const Spacer(),

                    for (var i = 0; i < widget.itemCount; ++i)
                      ...[
                        if (i != 0)
                          ?widget.separatorBuilder?.call(
                            itemsFocusNodes[i],
                            i,
                            selectedIndex == i,
                          ),

                        () {
                          final isSelected = selectedIndex == i;
                          final node = itemsFocusNodes[i];
                          final item = widget.itemBuilder(node, i, isSelected);

                          return DpadFocus(
                            focusNode: node,
                            onSelect: (_, _) {
                              setState(() => _selectedIndex = i);
                              item.onSelect?.call();
                              return KeyEventResult.handled;
                            },
                            onUp: (_, _) {
                              switch (i) {
                                case 0: headerFocusNode?.requestFocus();
                                default: itemsFocusNodes[i - 1].requestFocus();
                              }

                              return KeyEventResult.handled;
                            },
                            onDown: (_, _) {
                              if (i == widget.itemCount - 1) {
                                footerFocusNode?.requestFocus();
                              } else {
                                itemsFocusNodes[i + 1].requestFocus();
                              }

                              return KeyEventResult.handled;
                            },
                            onRight: (_, _) {
                              childFocusNode.requestFocus();
                              return KeyEventResult.handled;
                            },
                            builder: (node) {
                              return _TvNavigationDrawerItem(
                                model: item,
                                node: node,
                                isSelected: isSelected,
                                isDrawerExpanded: isExpanded,
                              );
                            },
                          );
                        }(),
                      ],

                    const Spacer(),

                    if (widget.footerBuilder != null) () {
                      final item = widget.footerBuilder!(footerFocusNode!);
                      return DpadFocus(
                        focusNode: footerFocusNode,
                        onSelect: (_, _) {
                          item.onSelect?.call();
                          return KeyEventResult.handled;
                        },
                        onDown: (_, _) {
                          itemsFocusNodes.last.requestFocus();
                          return KeyEventResult.handled;
                        },
                        onRight: (_, _) {
                          childFocusNode.requestFocus();
                          return KeyEventResult.handled;
                        },
                        builder: (node) {
                          return _TvNavigationDrawerItem(
                            model: item,
                            node: node,
                            isDrawerExpanded: isExpanded,
                          );
                        },
                      );
                    }(),
                  ],
                ),
              ),

              Expanded(
                child: widget.builder(
                  context,
                  _selectedIndex,
                  childFocusNode,
                  selectedItemFocusNode,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

final class _TvNavigationDrawerItem extends StatelessWidget {

  const _TvNavigationDrawerItem({
    required this.model,
    required this.node,
    this.isSelected = false,
    required this.isDrawerExpanded,
  });

  final TvNavigationItem model;
  final FocusNode node;
  final bool isSelected;
  final bool isDrawerExpanded;

  @override
  Widget build(BuildContext context) {
    final Set<WidgetState> focusedState = node.hasFocus
        ? { WidgetState.focused }
        : {};

    final widgetState = isSelected
        ? { WidgetState.selected, ...focusedState }
        : focusedState;

    return AnimatedContainer(
      duration: _animatedDuration,
      padding: model.contentPadding,
      decoration: model.decoration.resolve(widgetState),
      child: Row(
        children: [
          Flexible(child: Icon(model.icon, size: model.iconSize)),
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
