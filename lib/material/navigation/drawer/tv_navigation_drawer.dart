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
  final Widget Function(BuildContext context, Widget child) drawerBuilder;
  final Widget Function(
    BuildContext context,
    TvNavigationMenuSelectionEntry? entry,
  )
  builder;

  @override
  State<StatefulWidget> createState() => _TvNavigationDrawerState();
}

final class _TvNavigationDrawerState extends State<TvNavigationDrawer> {
  late final TvNavigationMenuController _controller;
  var _ownsController = false;

  void _validateController(TvNavigationMenuController controller) {
    if (widget.header != null && controller.headerNode == null) {
      throw ArgumentError('Header was passed but focus node was not');
    }

    if (widget.footer != null && controller.footerNode == null) {
      throw ArgumentError('Footer was passed but focus node was not');
    }

    if (widget.menuItems.length != controller.itemsNodes.length) {
      throw ArgumentError('Menu items count does not match focus nodes count');
    }
  }

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
        _validateController(controller);
        _controller = controller;

      case (null, final TvNavigationMenuSelectionEntry entry):
        _controller = TvNavigationMenuController(
          initialEntry: entry,
          focusScopeNode: FocusScopeNode(),
          headerNode: widget.header == null ? null : FocusNode(),
          footerNode: widget.footer == null ? null : FocusNode(),
          itemsNodes: {
            for (final item in widget.menuItems) item.key: FocusNode(),
          },
        );
        _ownsController = true;
    }

    _controller.addListener(_controllerListener);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TvNavigationDrawer oldWidget) {
    final passedController = widget.controller;

    if (passedController != null && oldWidget.controller != passedController) {
      _validateController(passedController);
      _controller.removeListener(_controllerListener);

      if (_ownsController) {
        _controller.dispose();
      }

      _controller = passedController..addListener(_controllerListener);
      _ownsController = false;
    }

    if (widget.menuItems.length != oldWidget.menuItems.length &&
        _controller.itemsNodes.length != widget.menuItems.length) {
      throw ArgumentError(
        'Updated menu items count does not match focus nodes count. '
        'Recreate the controller with valid `itemsNodes` count.',
      );
    }

    super.didUpdateWidget(oldWidget);
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

        Expanded(child: widget.builder(context, _controller.selectedEntry)),

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
            child: widget.builder(context, _controller.selectedEntry),
          ),

          Align(alignment: Alignment.centerLeft, child: _buildContent()),
        ],
      ),

      TvNavigationMenuAlignment.end => Stack(
        children: [
          Positioned.fill(
            right: widget.constraints.minWidth,
            child: widget.builder(context, _controller.selectedEntry),
          ),

          Align(alignment: Alignment.centerRight, child: _buildContent()),
        ],
      ),
    };
  }

  Widget _buildContent() {
    return DpadFocus(
      focusNode: _controller.mediatorFocusNode,
      onFocusChanged: (node) {
        if (node.hasFocus) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _controller.selectedFocusNode.requestFocus();
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
          ),
        );
      },
    );
  }
}
