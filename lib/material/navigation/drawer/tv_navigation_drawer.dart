import 'package:flutter/material.dart';

import '../../../foundation/foundation.dart';
import 'tv_navigation_drawer_mode.dart';

final class TvNavigationDrawer extends StatefulWidget {
  TvNavigationDrawer({
    super.key,
    this.controller,
    this.header,
    this.footer,
    this.backgroundColor,
    this.constraints = const BoxConstraints(minWidth: 64, maxWidth: 280),
    this.drawerExpandDuration = const Duration(milliseconds: 300),
    this.alignment = TvNavigationMenuAlignment.start,
    this.mode = TvNavigationDrawerMode.standard,
    this.initialEntry,
    required this.menuItems,
    this.separatorBuilder,
    FocusTraversalPolicy? policy,
    this.descendantsAreFocusable = true,
    this.descendantsAreTraversable = true,
    this.autofocus = false,
    this.onUp,
    this.onDown,
    this.onLeft,
    this.onRight,
    this.onFocusChanged,
    this.onFocusDisabledWhenWasFocused,
    required this.drawerBuilder,
    required this.builder,
  }) : assert(menuItems.isNotEmpty),
       policy = policy ?? ReadingOrderTraversalPolicy();

  final TvNavigationMenuController? controller;
  final TvNavigationMenuItem? header;
  final TvNavigationMenuItem? footer;
  final Color? backgroundColor;
  final BoxConstraints constraints;
  final Duration drawerExpandDuration;
  final TvNavigationMenuAlignment alignment;
  final TvNavigationDrawerMode mode;
  final TvNavigationMenuSelectionEntry? initialEntry;
  final List<TvNavigationMenuItem> menuItems;
  final Widget Function(int index)? separatorBuilder;
  final FocusTraversalPolicy policy;
  final bool descendantsAreFocusable;
  final bool descendantsAreTraversable;
  final bool autofocus;
  final ScrollGroupDpadEventCallback? onUp;
  final ScrollGroupDpadEventCallback? onDown;
  final ScrollGroupDpadEventCallback? onLeft;
  final ScrollGroupDpadEventCallback? onRight;
  final void Function(FocusScopeNode, bool)? onFocusChanged;
  final void Function(FocusScopeNode)? onFocusDisabledWhenWasFocused;
  final Widget Function(BuildContext context, Widget child) drawerBuilder;
  final Widget Function(
    BuildContext context,
    TvNavigationMenuSelectionEntry? entry,
  )
  builder;

  @override
  State<StatefulWidget> createState() => TvNavigationDrawerState();
}

final class TvNavigationDrawerState extends State<TvNavigationDrawer> {
  late TvNavigationMenuController controller;
  var _ownsController = false;

  @override
  void initState() {
    final passedController = widget.controller;
    final passedInitialEntry = widget.initialEntry;

    switch ((passedController, passedInitialEntry)) {
      case (null, null):
        throw ArgumentError(
          'Either controller or initialEntry must be provided',
        );

      case (final TvNavigationMenuController controller, _):
        this.controller = controller;

      case (null, final TvNavigationMenuSelectionEntry entry):
        controller = TvNavigationMenuController(initialEntry: entry);
        _ownsController = true;
    }

    controller.addListener(_controllerListener);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TvNavigationDrawer oldWidget) {
    final passedController = widget.controller;

    if (passedController != null && oldWidget.controller != passedController) {
      controller.removeListener(_controllerListener);

      if (_ownsController) {
        controller.dispose();
      }

      controller = passedController..addListener(_controllerListener);
      _ownsController = false;
    }

    super.didUpdateWidget(oldWidget);
  }

  void _controllerListener() => setState(() {});

  @override
  void dispose() {
    controller.removeListener(_controllerListener);

    if (_ownsController) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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
        if (widget.alignment == TvNavigationMenuAlignment.start)
          _buildContent(),

        Expanded(child: widget.builder(context, controller.selectedEntry)),

        if (widget.alignment == TvNavigationMenuAlignment.end) _buildContent(),
      ],
    );
  }

  Widget _buildModal() {
    return switch (widget.alignment) {
      TvNavigationMenuAlignment.start => Stack(
        children: [
          Positioned.fill(
            left: widget.constraints.minWidth,
            child: widget.builder(context, controller.selectedEntry),
          ),

          Align(alignment: Alignment.centerLeft, child: _buildContent()),
        ],
      ),

      TvNavigationMenuAlignment.end => Stack(
        children: [
          Positioned.fill(
            right: widget.constraints.minWidth,
            child: widget.builder(context, controller.selectedEntry),
          ),

          Align(alignment: Alignment.centerRight, child: _buildContent()),
        ],
      ),
    };
  }

  Widget _buildContent() {
    return DpadFocus(
      focusNode: controller.mediatorFocusNode,
      onFocusChanged: (_, hasFocus) {
        if (hasFocus) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.selectedFocusNodeOrNull?.requestFocus();
          });
        }
      },
      builder: (_) {
        return widget.drawerBuilder(
          context,
          TvNavigationMenuContent(
            controller: widget.controller,
            header: widget.header,
            footer: widget.footer,
            constraints: widget.constraints,
            animateDrawerExpansion: true,
            drawerAnimationsDuration: widget.drawerExpandDuration,
            menuItems: widget.menuItems,
            separatorBuilder: widget.separatorBuilder,
            policy: widget.policy,
            descendantsAreFocusable: widget.descendantsAreFocusable,
            descendantsAreTraversable: widget.descendantsAreTraversable,
            autofocus: widget.autofocus,
            onUp: widget.onUp,
            onDown: widget.onDown,
            onLeft: widget.onLeft,
            onRight: widget.onRight,
            onFocusChanged: widget.onFocusChanged,
            onFocusDisabledWhenWasFocused: widget.onFocusDisabledWhenWasFocused,
          ),
        );
      },
    );
  }
}
