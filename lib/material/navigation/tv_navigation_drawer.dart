import 'package:flutter/material.dart';

import '../../foundation/foundation.dart';
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
    this.alignment = TvNavigationAlignment.start,
    this.mode = TvNavigationDrawerMode.standard,
    this.initialEntry,
    required this.menuItems,
    this.separatorBuilder,
    required this.builder,
  }) : assert(menuItems.length > 0);

  final TvNavigationController controller;
  final FocusNode? childNode;
  final TvNavigationItem Function()? headerBuilder;
  final TvNavigationItem Function()? footerBuilder;
  final Color? backgroundColor;
  final BoxDecoration? drawerDecoration;
  final BoxConstraints constraints;
  final EdgeInsets drawerPadding;
  final Duration drawerExpandDuration;
  final TvNavigationAlignment alignment;
  final TvNavigationDrawerMode mode;
  final TvSelectionEntry? initialEntry;
  final List<TvNavigationItem> menuItems;
  final Widget Function(int index)? separatorBuilder;
  final Widget Function(
    BuildContext context,
    TvSelectionEntry? entry,
    FocusNode childFocusNode,
  )
  builder;

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
      child: switch (widget.mode) {
        TvNavigationDrawerMode.standard => _buildStandard(),
        TvNavigationDrawerMode.modal => _buildModal(),
      },
    );
  }

  Widget _buildStandard() {
    return Row(
      children: [
        if (widget.alignment == TvNavigationAlignment.start) _buildContent(),

        Expanded(
          child: widget.builder(
            context,
            widget.controller.selectedEntry,
            widget.controller.childFocusNode,
          ),
        ),

        if (widget.alignment == TvNavigationAlignment.end) _buildContent(),
      ],
    );
  }

  Widget _buildModal() {
    return switch (widget.alignment) {
      TvNavigationAlignment.start => Stack(
        children: [
          Positioned.fill(
            left: widget.constraints.minWidth,
            child: widget.builder(
              context,
              widget.controller.selectedEntry,
              widget.controller.childFocusNode,
            ),
          ),

          Align(alignment: Alignment.centerLeft, child: _buildContent()),
        ],
      ),

      TvNavigationAlignment.end => Stack(
        children: [
          Positioned.fill(
            right: widget.constraints.minWidth,
            child: widget.builder(
              context,
              widget.controller.selectedEntry,
              widget.controller.childFocusNode,
            ),
          ),

          Align(alignment: Alignment.centerRight, child: _buildContent()),
        ],
      ),
    };
  }

  Widget _buildContent() {
    return DpadFocus(
      focusNode: widget.controller.mediatorFocusNode,
      onFocusChanged: (node) {
        if (node.hasFocus) {
          widget.controller.selectedFocusNode.requestFocus();
        }
      },
      builder: (_) {
        return TvNavigationContent(
          controller: widget.controller,
          headerBuilder: widget.headerBuilder,
          footerBuilder: widget.footerBuilder,
          drawerDecoration: widget.drawerDecoration,
          constraints: widget.constraints,
          drawerPadding: widget.drawerPadding,
          animateDrawerExpansion: true,
          drawerAnimationsDuration: widget.drawerExpandDuration,
          menuItems: widget.menuItems,
          separatorBuilder: widget.separatorBuilder,
        );
      },
    );
  }
}
