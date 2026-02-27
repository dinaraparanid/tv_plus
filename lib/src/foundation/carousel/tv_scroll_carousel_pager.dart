part of 'carousel.dart';

final class TvScrollCarouselPager extends StatefulWidget {
  const TvScrollCarouselPager({
    super.key,
    required this.height,
    this.itemCount,
    this.initialActiveIndex,
    this.capacity,
    this.viewportAlignment,
    this.controller,
    this.scrollController,
    this.focusScopeNode,
    this.autofocus = false,
    this.onUp,
    this.onDown,
    this.onLeft,
    this.onRight,
    this.onSelect,
    this.onBack,
    this.onKeyEvent,
    this.onFocusChanged,
    this.onFocusDisabledWhenWasFocused,
    this.separatorBuilder,
    required this.itemBuilder,
  });

  final double height;
  final int? itemCount;
  final int? initialActiveIndex;
  final int? capacity;
  final double? Function(
    BuildContext context,
    int index,
    (int, int) visibleIndices,
  )?
  viewportAlignment;
  final TvCarouselController? controller;
  final ScrollController? scrollController;
  final FocusScopeNode? focusScopeNode;
  final bool autofocus;
  final DpadEventCallback? onUp;
  final DpadEventCallback? onDown;
  final CarouselDpadEventCallback? onLeft;
  final CarouselDpadEventCallback? onRight;
  final DpadEventCallback? onSelect;
  final DpadEventCallback? onBack;
  final KeyEventResult Function(FocusNode, KeyEvent)? onKeyEvent;
  final void Function(FocusNode, bool)? onFocusChanged;
  final void Function(FocusScopeNode)? onFocusDisabledWhenWasFocused;
  final Widget Function(
    BuildContext context,
    int index,
    int selectedIndex,
    (int, int) visibleIndices,
  )?
  separatorBuilder;
  final Widget Function(
    BuildContext context,
    int index,
    int selectedIndex,
    (int, int) visibleIndices,
    bool isFocused,
  )
  itemBuilder;

  static TvCarouselController of(BuildContext context) =>
      context.findAncestorStateOfType<_TvScrollCarouselPager>()!._controller;

  @override
  State<TvScrollCarouselPager> createState() => _TvScrollCarouselPager();
}

final class _TvScrollCarouselPager extends State<TvScrollCarouselPager>
    with DpadScopeEvents {
  late final TvCarouselController _controller;
  var _ownsController = false;

  late final ScrollController _scrollController;
  var _ownsScrollController = false;

  late final FocusScopeNode _focusScopeNode;
  var _ownsNode = false;

  late (int, int) _visibleIndices;

  int get _capacity => widget.capacity ?? _controller.itemCount;

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

    _setVisibleIndices();

    _ownsController = widget.controller == null;
    _controller.addListener(_listener);

    _scrollController = widget.scrollController ?? ScrollController();
    _ownsScrollController = widget.scrollController == null;

    _focusScopeNode = widget.focusScopeNode ?? FocusScopeNode();
    _ownsNode = widget.focusScopeNode == null;

    super.initState();
  }

  @override
  void didUpdateWidget(covariant TvScrollCarouselPager oldWidget) {
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
      _setVisibleIndices();
    }

    if (widget.capacity != oldWidget.capacity) {
      _setVisibleIndices();
    }

    final passedScrollController = widget.scrollController;

    if (passedScrollController != null &&
        passedScrollController != oldWidget.scrollController) {
      if (_ownsScrollController) {
        _scrollController.dispose();
      }

      _scrollController = passedScrollController;
      _ownsScrollController = false;
    }

    final passedNode = widget.focusScopeNode;

    if (passedNode != null && passedNode != oldWidget.focusScopeNode) {
      if (_ownsNode) {
        _focusScopeNode.dispose();
      }

      _focusScopeNode = passedNode;
      _ownsNode = false;
    }

    super.didUpdateWidget(oldWidget);
  }

  void _setVisibleIndices() {
    final start = math.max(0, _controller.selectedIndex - _capacity ~/ 2);
    final end = math.min(_controller.itemCount, start + _capacity);
    _visibleIndices = (start, end);
  }

  void _listener() => setState(() {});

  @override
  KeyEventResult onUpEvent(
    FocusNode node,
    KeyDownEvent event,
    bool isOutOfScope,
  ) {
    return widget.onUp?.call(node, event) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onDownEvent(
    FocusNode node,
    KeyDownEvent event,
    bool isOutOfScope,
  ) {
    return widget.onDown?.call(node, event) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onLeftEvent(
    FocusNode node,
    KeyDownEvent event,
    bool isOutOfScope,
  ) {
    if (_controller.canScrollLeft) {
      _controller.scrollLeft();

      if (_controller.selectedIndex < _visibleIndices.$1 + 1 &&
          _visibleIndices.$1 != 0) {
        _visibleIndices = (_visibleIndices.$1 - 1, _visibleIndices.$2 - 1);
      }

      return widget.onLeft?.call(node, event, false) ?? KeyEventResult.handled;
    }

    return widget.onLeft?.call(node, event, true) ?? KeyEventResult.ignored;
  }

  @override
  KeyEventResult onRightEvent(
    FocusNode node,
    KeyDownEvent event,
    bool isOutOfScope,
  ) {
    if (_controller.canScrollRight) {
      _controller.scrollRight();

      if (_controller.selectedIndex > _visibleIndices.$2 - 1 &&
          _visibleIndices.$2 != _controller.itemCount - 1) {
        _visibleIndices = (_visibleIndices.$1 + 1, _visibleIndices.$2 + 1);
      }

      return widget.onRight?.call(node, event, false) ?? KeyEventResult.handled;
    }

    return widget.onRight?.call(node, event, true) ?? KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);

    if (_ownsController) {
      _controller.dispose();
    }

    if (_ownsScrollController) {
      _scrollController.dispose();
    }

    if (_ownsNode) {
      _focusScopeNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: TvListView.separated(
        focusScopeNode: _focusScopeNode,
        autofocus: widget.autofocus,
        onUp: onUpEvent,
        onDown: onDownEvent,
        onLeft: onLeftEvent,
        onRight: onRightEvent,
        onKeyEvent: widget.onKeyEvent,
        onFocusChanged: widget.onFocusChanged,
        onFocusDisabledWhenWasFocused: widget.onFocusDisabledWhenWasFocused,
        itemCount: _controller.itemCount,
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        separatorBuilder: (context, index) =>
            widget.separatorBuilder?.call(
              context,
              index,
              _controller.selectedIndex,
              _visibleIndices,
            ) ??
            const SizedBox(),
        itemBuilder: (context, index) => ScrollGroupDpadFocus(
          viewportAlignment: widget.viewportAlignment?.call(
            context,
            index,
            _visibleIndices,
          ),
          builder: (context, node) => widget.itemBuilder(
            context,
            index,
            _controller.selectedIndex,
            _visibleIndices,
            node.hasFocus,
          ),
        ),
      ),
    );
  }
}
