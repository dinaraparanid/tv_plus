import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tv_plus/foundation/dpad/dpad.dart';
import 'package:tv_plus/material/carousel/tv_carousel_controller.dart';

final class TvCarouselPager extends StatefulWidget {
  const TvCarouselPager({
    super.key,
    this.itemCount,
    this.initialActiveIndex,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.spacing = 0,
    required this.itemBuilder,
  });

  final int? itemCount;
  final int? initialActiveIndex;
  final TvCarouselController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final double spacing;
  final Widget Function(
    BuildContext context,
    int index,
    bool isSelected,
    bool isFocused,
  )
  itemBuilder;

  @override
  State<StatefulWidget> createState() => _TvCarouselPagerState();
}

final class _TvCarouselPagerState extends State<TvCarouselPager>
    with DpadEvents {
  late final TvCarouselController _controller;
  var _ownsController = false;

  late final FocusNode _focusNode;
  var _ownsNode = false;

  @override
  void initState() {
    if (widget.controller == null && widget.itemCount == null) {
      throw ArgumentError('Either controller or itemCount must be provided.');
    }

    _controller =
        widget.controller ??
        TvCarouselController(
          initialActiveIndex: widget.initialActiveIndex ?? 0,
          itemCount: widget.itemCount!,
        );

    _ownsController = widget.controller == null;
    _controller.addListener(_listener);

    _focusNode = widget.focusNode ?? FocusNode();
    _ownsNode = widget.focusNode == null;

    super.initState();
  }

  @override
  void didUpdateWidget(covariant TvCarouselPager oldWidget) {
    final passedController = widget.controller;

    if (passedController != null && passedController != oldWidget.controller) {
      _controller.removeListener(_listener);

      if (_ownsController) {
        _controller.dispose();
      }

      _controller = passedController..addListener(_listener);
      _ownsController = false;
    }

    final passedCount = widget.itemCount;

    if (passedCount != null && passedCount != _controller.itemCount) {
      _controller.reset(count: passedCount);
    }

    final passedNode = widget.focusNode;

    if (passedNode != null && passedNode != oldWidget.focusNode) {
      if (_ownsNode) {
        _focusNode.dispose();
      }

      _focusNode = passedNode;
      _ownsNode = false;
    }

    super.didUpdateWidget(oldWidget);
  }

  void _listener() {
    setState(() {});
  }

  @override
  KeyEventResult onLeftEvent(FocusNode node, KeyDownEvent event) {
    if (_controller.canScrollLeft) {
      _controller.scrollLeft();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  KeyEventResult onRightEvent(FocusNode node, KeyDownEvent event) {
    if (_controller.canScrollRight) {
      _controller.scrollRight();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);

    if (_ownsController) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DpadFocus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onLeft: onLeftEvent,
      onRight: onRightEvent,
      builder: (_) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          spacing: widget.spacing,
          children: [
            for (var i = 0; i < _controller.itemCount; ++i)
              widget.itemBuilder(
                context,
                i,
                _controller.selectedIndex == i,
                _focusNode.hasFocus,
              ),
          ],
        );
      },
    );
  }
}
