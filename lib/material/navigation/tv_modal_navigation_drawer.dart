import 'package:flutter/material.dart';

import '../material.dart';
import 'selection_entry.dart';
import 'tv_navigation_drawer_content.dart';

final class TvModalNavigationDrawer extends StatefulWidget {
  const TvModalNavigationDrawer({
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
    this.alignment = TvNavigationDrawerAlignment.start,
    required this.itemCount,
    required this.initialEntry,
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
  final TvNavigationDrawerAlignment alignment;
  final int itemCount;
  final SelectionEntry initialEntry;
  final TvNavigationItem Function(int index) itemBuilder;
  final Widget Function(int index)? separatorBuilder;
  final Widget Function(
    BuildContext context,
    SelectionEntry entry,
    FocusNode childFocusNode,
  ) builder;

  @override
  State<StatefulWidget> createState() => _TvModalNavigationDrawerState();
}

final class _TvModalNavigationDrawerState extends State<TvModalNavigationDrawer> {

  late final TvNavigationDrawerController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    _controller = widget.controller ?? TvNavigationDrawerController(
      initialEntry: widget.initialEntry,
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
          return switch (widget.alignment) {
            TvNavigationDrawerAlignment.start => Stack(
              children: [
                Positioned.fill(
                  left: widget.constraints.minWidth,
                  child: widget.builder(
                    context,
                    _controller.entry,
                    _controller.childFocusNode,
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
                    _controller.entry,
                    _controller.childFocusNode,
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: _buildContent(),
                ),
              ],
            ),
          };
        },
      ),
    );
  }

  Widget _buildContent() {
    return TvNavigationDrawerContent(
      controller: _controller,
      headerBuilder: widget.headerBuilder,
      footerBuilder: widget.footerBuilder,
      drawerDecoration: widget.drawerDecoration,
      constraints: widget.constraints,
      drawerPadding: widget.drawerPadding,
      drawerExpandDuration: widget.drawerExpandDuration,
      itemCount: widget.itemCount,
      itemBuilder: widget.itemBuilder,
      separatorBuilder: widget.separatorBuilder,
    );
  }
}
