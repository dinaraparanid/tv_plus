import 'package:flutter/cupertino.dart';

import '../../foundation/foundation.dart';
import 'cupertino_tv_sidebar_floating_header.dart';

final class CupertinoTvSidebar extends StatefulWidget {
  const CupertinoTvSidebar({
    super.key,
    required this.controller,
    this.childNode,
    this.headerBuilder,
    this.footerBuilder,
    this.backgroundColor,
    this.constraints = const BoxConstraints(minWidth: 90, maxWidth: 200),
    this.drawerMargin = const EdgeInsets.all(16),
    required this.drawerAnimationsDuration,
    this.alignment = TvNavigationAlignment.start,
    this.initialEntry,
    required this.menuItems,
    this.separatorBuilder,
    this.collapsedHeaderBuilder,
    required this.drawerBuilder,
    required this.builder,
  });

  final TvNavigationController controller;
  final FocusNode? childNode;
  final TvNavigationItem Function()? headerBuilder;
  final TvNavigationItem Function()? footerBuilder;
  final Color? backgroundColor;
  final BoxConstraints constraints;
  final EdgeInsets drawerMargin;
  final Duration drawerAnimationsDuration;
  final TvNavigationAlignment alignment;
  final TvSelectionEntry? initialEntry;
  final List<TvNavigationItem> menuItems;
  final Widget Function(int index)? separatorBuilder;
  final Widget Function(
    BuildContext context,
    TvSelectionEntry? entry,
    FocusNode childFocusNode,
  )?
  collapsedHeaderBuilder;
  final Widget Function(BuildContext context, Widget child) drawerBuilder;
  final Widget Function(
    BuildContext context,
    TvSelectionEntry? entry,
    FocusNode childFocusNode,
  )
  builder;

  @override
  State<StatefulWidget> createState() => _CupertinoTvSidebarState();
}

final class _CupertinoTvSidebarState extends State<CupertinoTvSidebar> {
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
    return DecoratedBox(
      key: widget.key,
      decoration: BoxDecoration(color: widget.backgroundColor),
      child: switch (widget.alignment) {
        TvNavigationAlignment.start => Stack(
          children: [
            const SizedBox.expand(),

            Positioned.fill(
              left: widget.constraints.minWidth,
              child: widget.builder(
                context,
                widget.controller.selectedEntry,
                widget.controller.childFocusNode,
              ),
            ),

            Positioned(
              top: widget.drawerMargin.top,
              bottom: widget.drawerMargin.bottom,
              left: widget.drawerMargin.left,
              child: _buildContent(),
            ),
          ],
        ),

        TvNavigationAlignment.end => Stack(
          children: [
            const SizedBox.expand(),

            Positioned.fill(
              right: widget.constraints.minWidth,
              child: widget.builder(
                context,
                widget.controller.selectedEntry,
                widget.controller.childFocusNode,
              ),
            ),

            Positioned(
              top: widget.drawerMargin.top,
              bottom: widget.drawerMargin.bottom,
              right: widget.drawerMargin.right,
              child: _buildContent(),
            ),
          ],
        ),
      },
    );
  }

  Widget _buildContent() {
    return DpadFocus(
      focusNode: widget.controller.mediatorFocusNode,
      onFocusChanged: (node) {
        if (node.hasFocus) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.controller.selectedFocusNode.requestFocus();
          });
        }
      },
      builder: (_) {
        return AnimatedCrossFade(
          duration: widget.drawerAnimationsDuration,
          crossFadeState: widget.controller.hasFocus
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: ConstrainedBox(
            constraints: widget.constraints,
            child: widget.drawerBuilder(
              context,
              TvNavigationContent(
                controller: widget.controller,
                headerBuilder: widget.headerBuilder,
                footerBuilder: widget.footerBuilder,
                constraints: widget.constraints,
                animateDrawerExpansion: false,
                drawerAnimationsDuration: widget.drawerAnimationsDuration,
                menuItems: widget.menuItems,
                separatorBuilder: widget.separatorBuilder,
              ),
            ),
          ),
          secondChild:
              widget.collapsedHeaderBuilder?.call(
                context,
                widget.controller.selectedEntry,
                widget.controller.childFocusNode,
              ) ??
              CupertinoTvSidebarFloatingHeader(
                controller: widget.controller,
                selectedItem: switch (widget.controller.selectedEntry) {
                  HeaderEntry() => widget.headerBuilder!.call(),

                  ItemEntry(key: final key) => widget.menuItems.firstWhere(
                    (it) => it.key == key,
                  ),

                  FooterEntry() => widget.footerBuilder!.call(),
                },
              ),
        );
      },
    );
  }
}
