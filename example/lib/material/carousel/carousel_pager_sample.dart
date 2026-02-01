import 'package:flutter/material.dart';
import 'package:tv_plus/tv_plus.dart';

final class CarouselPagerSample extends StatefulWidget {
  const CarouselPagerSample({super.key});

  static const backgroundColor = Color(0xFF131314);
  static const selectedFocusedIndicatorColor = Color(0xFFFFFFFF);
  static const selectedUnfocusedIndicatorColor = Color(0x80FFFFFF);
  static const unselectedIndicatorColor = Color(0x33FFFFFF);
  static const animationDuration = Duration(milliseconds: 300);
  static const initialSelectedIndex = 1;

  static const items = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.lime,
  ];

  @override
  State<StatefulWidget> createState() => _CarouselPagerSampleState();
}

final class _CarouselPagerSampleState extends State<CarouselPagerSample> {
  late final TvCarouselController _controller;
  late final FocusNode _focusNode;

  var _selectedIndex = CarouselPagerSample.initialSelectedIndex;

  @override
  void initState() {
    _controller = TvCarouselController(
      initialActiveIndex: CarouselPagerSample.initialSelectedIndex,
      itemCount: CarouselPagerSample.items.length,
    )..addListener(_listener);

    _focusNode = FocusNode();

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
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: CarouselPagerSample.backgroundColor,
      builder: (context, _) {
        return Stack(
          children: [
            Align(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  AnimatedContainer(
                    duration: CarouselPagerSample.animationDuration,
                    height: 200,
                    width: 600,
                    decoration: BoxDecoration(
                      color: CarouselPagerSample.items[_selectedIndex],
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                    ),
                  ),

                  TvCarouselPager(
                    controller: _controller,
                    focusNode: _focusNode,
                    autofocus: true,
                    spacing: 8,
                    itemBuilder: (context, index, isSelected, isFocused) {
                      return Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: switch ((isSelected, isFocused)) {
                            (false, _) =>
                              CarouselPagerSample.unselectedIndicatorColor,

                            (true, true) =>
                              CarouselPagerSample.selectedFocusedIndicatorColor,

                            (true, false) =>
                              CarouselPagerSample
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
