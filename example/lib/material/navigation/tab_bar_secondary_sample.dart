import 'package:flutter/material.dart';
import 'package:tv_plus/tv_plus.dart';

final class TvTabBarSecondarySample extends StatefulWidget {
  const TvTabBarSecondarySample({super.key});

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
    ('Cartoons', Icons.child_care),
    ('Library', Icons.live_tv),
    ('Music', Icons.music_note),
    ('Podcasts', Icons.multitrack_audio_sharp),
    ('Settings', Icons.settings),
    ('Profile', Icons.person),
  ];

  @override
  State<StatefulWidget> createState() => _TvTabBarSecondarySampleState();
}

final class _TvTabBarSecondarySampleState
    extends State<TvTabBarSecondarySample> {
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
    final (text, icon) = TvTabBarSecondarySample.items[_currentIndex];

    return MaterialApp(
      home: Scaffold(
        backgroundColor: TvTabBarSecondarySample.backgroundColor,
        appBar: AppBar(
          backgroundColor: TvTabBarSecondarySample.backgroundColor,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(
              TvTabBarSecondarySample.tabBarHeight,
            ),
            child: TvTabBar.secondary(
              controller: _tabController,
              isScrollable: true,
              animationDuration: TvTabBarSecondarySample.animationDuration,
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
                for (var i = 0; i < TvTabBarSecondarySample.items.length; ++i)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TabItem(
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

  Widget _buildIndicator(
    BuildContext context,
    Offset tabOffset,
    Size tabSize,
    bool tabBarHasFocus,
  ) {
    final margin =
        (tabSize.width - TvTabBarSecondarySample.unfocusedSelectionWidth) / 2;

    return AnimatedContainer(
      duration: TvTabBarSecondarySample.animationDuration,
      height: 2,
      width: tabBarHasFocus
          ? tabSize.width
          : TvTabBarSecondarySample.unfocusedSelectionWidth,
      margin: EdgeInsets.only(left: tabBarHasFocus ? 0 : margin),
      decoration: BoxDecoration(
        color: tabBarHasFocus
            ? TvTabBarSecondarySample.focusedColor
            : TvTabBarSecondarySample.selectedColor,
        borderRadius: TvTabBarSecondarySample.selectionRadius,
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
                        ? TvTabBarSecondarySample.focusedColor
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

@visibleForTesting
final class TabItem extends StatelessWidget {
  const TabItem({
    super.key,
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
      (false, _) => TvTabBarSecondarySample.contentColor,
      (true, true) => TvTabBarSecondarySample.focusedColor,
      (true, false) => TvTabBarSecondarySample.selectedColor,
    };

    return AnimatedScale(
      scale: isSelected ? 1.2 : 1.0,
      duration: TvTabBarSecondarySample.animationDuration,
      child: TvTab(
        autofocus: index == currentIndex,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Icon(TvTabBarSecondarySample.items[index].$2, color: contentColor),

            Text(
              TvTabBarSecondarySample.items[index].$1,
              style: TextStyle(color: contentColor, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
