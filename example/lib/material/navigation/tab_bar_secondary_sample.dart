import 'package:flutter/material.dart';
import 'package:tv_plus/tv_plus.dart';

import 'tab_item_sample.dart';

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
  static const initialIndex = 1;

  static final tabBarKey = GlobalKey();
  static final indicatorKey = GlobalKey();
  static final contentKey = GlobalKey();
  static final contentIconKey = GlobalKey();
  static final contentTitleKey = GlobalKey();
  static final contentJumpKey = GlobalKey();
  static final tabsKeys = List.generate(
    TvTabBarSecondarySample.items.length,
    (_) => GlobalKey(),
  );

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

  late final _tabController = TvTabBarController(
    initialIndex: TvTabBarSecondarySample.initialIndex,
  );

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
              key: TvTabBarSecondarySample.tabBarKey,
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

  Widget _buildIndicator(
    BuildContext context,
    Offset tabOffset,
    Size tabSize,
    bool tabBarHasFocus,
  ) {
    final margin =
        (tabSize.width - TvTabBarSecondarySample.unfocusedSelectionWidth) / 2;

    return AnimatedContainer(
      key: TvTabBarSecondarySample.indicatorKey,
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
      key: TvTabBarSecondarySample.contentKey,
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
                  Icon(
                    icon,
                    key: TvTabBarSecondarySample.contentIconKey,
                    size: 48,
                    color: Colors.white,
                  ),

                  Flexible(
                    child: Text(
                      text,
                      key: TvTabBarSecondarySample.contentTitleKey,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),

              DpadFocus(
                focusNode: _contentFocusNode,
                key: TvTabBarSecondarySample.contentJumpKey,
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
                builder: (context, node) => Container(
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

    return TvTabItemSample(
      index: index,
      key: TvTabBarSecondarySample.tabsKeys[index],
      icon: TvTabBarSecondarySample.items[index].$2,
      text: TvTabBarSecondarySample.items[index].$1,
      color: switch ((isSelected, isTabBarFocused)) {
        (false, _) => TvTabBarSecondarySample.contentColor,
        (true, true) => TvTabBarSecondarySample.focusedColor,
        (true, false) => TvTabBarSecondarySample.selectedColor,
      },
      isSelected: isSelected,
      isTabBarFocused: isTabBarFocused,
    );
  }
}
