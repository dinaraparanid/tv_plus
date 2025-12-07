import 'package:flutter/material.dart';
import 'package:tv_plus/tv_plus.dart';

final class TabBarSecondarySample extends StatefulWidget {
  const TabBarSecondarySample({super.key});

  static const backgroundColor = Color(0xFF131314);
  static const focusedColor = Colors.indigoAccent;
  static const selectedColor = Colors.green;
  static const contentColor = Colors.white;
  static const selectionRadius = BorderRadius.all(Radius.circular(2));
  static const animationDuration = Duration(milliseconds: 300);
  static const tabBarHeight = 20.0;
  static const unfocusedSelectionWidth = 8.0;

  static const items = [
    ('Search', Icons.search),
    ('Home', Icons.home),
    ('Movies', Icons.movie),
    ('Shows', Icons.tv),
    ('Library', Icons.video_library),
  ];

  @override
  State<StatefulWidget> createState() => _TabBarSecondarySampleState();
}

final class _TabBarSecondarySampleState extends State<TabBarSecondarySample> {
  late final _focusScopeNode = FocusScopeNode();

  late final _contentFocusNode = FocusNode();

  late final _tabController = TvTabBarController(initialIndex: 1);

  late var _currentIndex = _tabController.selectedIndex;

  var _tabBarHasFocus = false;

  @override
  void initState() {
    _tabController.addListener(_tabListener);
    _focusScopeNode.addListener(_focusListener);
    super.initState();
  }

  void _tabListener() {
    if (_currentIndex != _tabController.selectedIndex) {
      setState(() => _currentIndex = _tabController.selectedIndex);
    }
  }

  void _focusListener() {
    if (_tabBarHasFocus != _focusScopeNode.hasFocus) {
      setState(() => _tabBarHasFocus = _focusScopeNode.hasFocus);
    }
  }

  @override
  void dispose() {
    _focusScopeNode.removeListener(_focusListener);
    _tabController.removeListener(_tabListener);

    _focusScopeNode.dispose();
    _contentFocusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (text, icon) = TabBarSecondarySample.items[_currentIndex];

    return MaterialApp(
      home: Scaffold(
        backgroundColor: TabBarSecondarySample.backgroundColor,
        appBar: AppBar(
          backgroundColor: TabBarSecondarySample.backgroundColor,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(
              TabBarSecondarySample.tabBarHeight,
            ),
            child: TvTabBar.secondary(
              controller: _tabController,
              animationDuration: TabBarSecondarySample.animationDuration,
              focusScopeNode: _focusScopeNode,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 16,
              onDown: (_, _, isOutOfScope) {
                if (isOutOfScope) {
                  _contentFocusNode.requestFocus();
                }

                return KeyEventResult.handled;
              },
              indicatorBuilder: _buildIndicator,
              tabs: [
                for (var i = 0; i < TabBarSecondarySample.items.length; ++i)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _TabItem(
                      index: i,
                      currentIndex: _currentIndex,
                      isTabBarFocused: _tabBarHasFocus,
                    ),
                  ),
              ],
            ),
          ),
        ),
        body: _buildContent(text: text, icon: icon),
      ),
    );
  }

  Widget _buildIndicator(Offset tabOffset, Size tabSize, bool tabBarHasFocus) {
    return AnimatedContainer(
      duration: TabBarSecondarySample.animationDuration,
      height: 2,
      width: tabBarHasFocus
          ? tabSize.width
          : TabBarSecondarySample.unfocusedSelectionWidth,
      margin: EdgeInsets.only(
        left: tabBarHasFocus
            ? 0
            : (tabSize.width - TabBarSecondarySample.unfocusedSelectionWidth) /
                  2,
      ),
      decoration: BoxDecoration(
        color: tabBarHasFocus
            ? TabBarSecondarySample.focusedColor
            : TabBarSecondarySample.selectedColor,
        borderRadius: TabBarSecondarySample.selectionRadius,
      ),
    );
  }

  Widget _buildContent({required String text, required IconData icon}) {
    return Stack(
      children: [
        Align(
          child: Column(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  Icon(icon, size: 48, color: Colors.white),

                  Flexible(
                    child: Text(
                      text,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),

              DpadFocus(
                focusNode: _contentFocusNode,
                onSelect: (_, _) {
                  _focusScopeNode.requestFocus();
                  return KeyEventResult.handled;
                },
                onUp: (_, _) {
                  _focusScopeNode.requestFocus();
                  return KeyEventResult.handled;
                },
                onLeft: (_, _) => KeyEventResult.handled,
                onRight: (_, _) => KeyEventResult.handled,
                builder: (node) => Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    color: node.hasFocus
                        ? TabBarSecondarySample.focusedColor
                        : Colors.transparent,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: const Text(
                    'Jump to selected tab',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

final class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.index,
    required this.currentIndex,
    required this.isTabBarFocused,
  });

  final int index;
  final int currentIndex;
  final bool isTabBarFocused;

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;

    final contentColor = switch ((isSelected, isTabBarFocused)) {
      (false, _) => TabBarSecondarySample.contentColor,
      (true, true) => TabBarSecondarySample.focusedColor,
      (true, false) => TabBarSecondarySample.selectedColor,
    };

    return AnimatedScale(
      scale: isSelected ? 1.2 : 1.0,
      duration: TabBarSecondarySample.animationDuration,
      child: TvTab(
        autofocus: index == currentIndex,
        viewportAlignment: 0,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Icon(TabBarSecondarySample.items[index].$2, color: contentColor),

            Text(
              TabBarSecondarySample.items[index].$1,
              style: TextStyle(color: contentColor, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
