import 'package:flutter/cupertino.dart';
import 'package:tv_plus/tv_plus.dart';

final class ScrollCarouselPagerSample extends StatefulWidget {
  const ScrollCarouselPagerSample({super.key});

  static const backgroundColor = Color(0xFF131314);
  static const selectedFocusedIndicatorColor = Color(0xFFFFFFFF);
  static const selectedUnfocusedIndicatorColor = Color(0x80FFFFFF);
  static const unselectedIndicatorColor = Color(0x33FFFFFF);
  static const animationDuration = Duration(milliseconds: 300);
  static const initialSelectedIndex = 1;
  static const capacity = 8;

  static final items = [
    CupertinoColors.systemRed,
    CupertinoColors.systemGreen,
    CupertinoColors.systemBlue,
    CupertinoColors.systemYellow,
    CupertinoColors.systemPurple,
    CupertinoColors.systemOrange,
    CupertinoColors.systemTeal,
    CupertinoColors.systemPink,
    CupertinoColors.systemIndigo,
    CupertinoColors.systemGrey,
  ];

  @override
  State<StatefulWidget> createState() => _ScrollCarouselPagerSampleState();
}

final class _ScrollCarouselPagerSampleState
    extends State<ScrollCarouselPagerSample> {
  late final TvCarouselController _controller;
  late final FocusScopeNode _focusScopeNode;

  var _selectedIndex = ScrollCarouselPagerSample.initialSelectedIndex;

  static double _itemSize({
    required int index,
    required int selectedIndex,
    required (int, int) visibleIndices,
  }) {
    if (index < visibleIndices.$1 || index > visibleIndices.$2) {
      return 0;
    }

    if (index == visibleIndices.$1 && selectedIndex > visibleIndices.$1 + 1) {
      return 4;
    }

    if (index == visibleIndices.$1 + 1 &&
        selectedIndex > visibleIndices.$1 + 1) {
      return 6;
    }

    if (index == visibleIndices.$2 && selectedIndex < visibleIndices.$2 - 1) {
      return 4;
    }

    if (index == visibleIndices.$2 - 1 &&
        selectedIndex < visibleIndices.$2 - 1) {
      return 6;
    }

    return 8;
  }

  @override
  void initState() {
    _controller = TvCarouselController(
      initialActiveIndex: ScrollCarouselPagerSample.initialSelectedIndex,
      itemCount: ScrollCarouselPagerSample.items.length,
    )..addListener(_listener);

    _focusScopeNode = FocusScopeNode();

    super.initState();
  }

  void _listener() {
    if (_controller.selectedIndex != _selectedIndex) {
      setState(() => _selectedIndex = _controller.selectedIndex);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    _controller.dispose();
    _focusScopeNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      color: ScrollCarouselPagerSample.backgroundColor,
      builder: (context, _) {
        return Stack(
          children: [
            Align(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  AnimatedContainer(
                    duration: ScrollCarouselPagerSample.animationDuration,
                    height: 200,
                    width: 600,
                    decoration: BoxDecoration(
                      color: ScrollCarouselPagerSample.items[_selectedIndex],
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                    ),
                  ),

                  TvScrollCarouselPager(
                    height: 20,
                    controller: _controller,
                    focusScopeNode: _focusScopeNode,
                    autofocus: true,
                    spacing: 8,
                    capacity: 8,
                    viewportAlignment:
                        (context, selectedIndex, visibleIndices) {
                          return selectedIndex == visibleIndices.$1
                              ? 0.0
                              : null;
                        },
                    itemBuilder:
                        (
                          context,
                          index,
                          selectedIndex,
                          visibleIndices,
                          isFocused,
                        ) {
                          final size = _itemSize(
                            index: index,
                            selectedIndex: selectedIndex,
                            visibleIndices: visibleIndices,
                          );

                          final isSelected = index == selectedIndex;

                          return AnimatedContainer(
                            duration:
                                ScrollCarouselPagerSample.animationDuration,
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: switch ((isSelected, isFocused)) {
                                (false, _) =>
                                  ScrollCarouselPagerSample
                                      .unselectedIndicatorColor,

                                (true, true) =>
                                  ScrollCarouselPagerSample
                                      .selectedFocusedIndicatorColor,

                                (true, false) =>
                                  ScrollCarouselPagerSample
                                      .selectedUnfocusedIndicatorColor,
                              },
                            ),
                          );
                        },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
