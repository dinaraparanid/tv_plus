import 'package:flutter/material.dart';

import '../material.dart';
import 'selection_entry.dart';
import 'tv_navigation_drawer_content.dart';
import 'tv_navigation_drawer_mode.dart';

final class TvNavigationDrawer extends StatefulWidget {
  const TvNavigationDrawer({
    super.key,
    required this.controller,
    this.childNode,
    this.headerBuilder,
    this.footerBuilder,
    this.backgroundColor,
    this.drawerDecoration,
    this.constraints = const BoxConstraints(minWidth: 90, maxWidth: 280),
    this.drawerPadding = const EdgeInsets.all(12),
    this.drawerExpandDuration = const Duration(milliseconds: 300),
    this.alignment = TvNavigationDrawerAlignment.start,
    this.mode = TvNavigationDrawerMode.standard,
    this.initialEntry,
    required this.menuItems,
    this.separatorBuilder,
    required this.builder,
  }) : assert(menuItems.length > 0);

  final TvNavigationDrawerController controller;
  final FocusNode? childNode;
  final TvNavigationItem Function()? headerBuilder;
  final TvNavigationItem Function()? footerBuilder;
  final Color? backgroundColor;
  final BoxDecoration? drawerDecoration;
  final BoxConstraints constraints;
  final EdgeInsets drawerPadding;
  final Duration drawerExpandDuration;
  final TvNavigationDrawerAlignment alignment;
  final TvNavigationDrawerMode mode;
  final SelectionEntry? initialEntry;
  final List<TvNavigationItem> menuItems;
  final Widget Function(int index)? separatorBuilder;
  final Widget Function(
    BuildContext context,
    SelectionEntry? entry,
    FocusNode childFocusNode,
  ) builder;

  @override
  State<StatefulWidget> createState() => _TvNavigationDrawerState();
}

final class _TvNavigationDrawerState extends State<TvNavigationDrawer> {

  @override
  void initState() {
    widget.controller.addListener(_controllerListener);
    super.initState();
  }

  void _controllerListener() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(_controllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      key: widget.key,
      color: widget.backgroundColor,
      child: LayoutBuilder(
        builder: (context, _) {
          return switch (widget.mode) {
            TvNavigationDrawerMode.standard => _buildStandard(),
            TvNavigationDrawerMode.modal => _buildModal(),
          };
        },
      ),
    );
  }

  Widget _buildStandard() {
    return Row(
      children: [
        if (widget.alignment == TvNavigationDrawerAlignment.start)
          _buildContent(),

        Expanded(
          child: widget.builder(
            context,
            widget.controller.entry,
            widget.controller.childFocusNode,
          ),
        ),

        if (widget.alignment == TvNavigationDrawerAlignment.end)
          _buildContent(),
      ],
    );
  }

  Widget _buildModal() {
    return switch (widget.alignment) {
      TvNavigationDrawerAlignment.start => Stack(
        children: [
          Positioned.fill(
            left: widget.constraints.minWidth,
            child: widget.builder(
              context,
              widget.controller.entry,
              widget.controller.childFocusNode,
            ),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: _buildContent(),
          ),
        ],
      ),

      TvNavigationDrawerAlignment.end => Stack(
        children: [
          Positioned.fill(
            right: widget.constraints.minWidth,
            child: widget.builder(
              context,
              widget.controller.entry,
              widget.controller.childFocusNode,
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: _buildContent(),
          ),
        ],
      ),
    };
  }

  Widget _buildContent() {
    return TvNavigationDrawerContent(
      controller: widget.controller,
      headerBuilder: widget.headerBuilder,
      footerBuilder: widget.footerBuilder,
      drawerDecoration: widget.drawerDecoration,
      constraints: widget.constraints,
      drawerPadding: widget.drawerPadding,
      drawerExpandDuration: widget.drawerExpandDuration,
      menuItems: widget.menuItems,
      separatorBuilder: widget.separatorBuilder,
    );
  }
}
