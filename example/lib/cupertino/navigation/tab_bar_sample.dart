import 'package:flutter/cupertino.dart';
import 'package:tv_plus/tv_plus.dart';

final class TabBarSample extends StatefulWidget {
  const TabBarSample({super.key});

  static const backgroundColor = Color(0xFF131314);
  static const focusedColor = CupertinoColors.systemIndigo;
  static const selectedColor = CupertinoColors.systemGreen;
  static const contentColor = CupertinoColors.white;
  static const contentSelectedColor = CupertinoColors.black;
  static const selectionRadius = BorderRadius.all(Radius.circular(16));
  static const animationDuration = Duration(milliseconds: 300);
  static const tabBarHeight = 48.0;

  static const items = [
    ('Home', CupertinoIcons.home, true),
    ('Movies', CupertinoIcons.video_camera, true),
    ('Shows', CupertinoIcons.tv, true),
    ('Library', CupertinoIcons.play_rectangle, true),
    ('Search', CupertinoIcons.search, false),
  ];

  @override
  State<StatefulWidget> createState() => _TabBarSampleState();
}

final class _TabBarSampleState extends State<TabBarSample> {
  late final _focusScopeNode = FocusScopeNode();

  late final _contentFocusNode = FocusNode();

  late final _tabController = TvTabBarController();

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
    final (text, icon, _) = TabBarSample.items[_currentIndex];

    return CupertinoApp(
      home: CupertinoPageScaffold(
        backgroundColor: TabBarSample.backgroundColor,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: TabBarSample.backgroundColor,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(TabBarSample.tabBarHeight),
            child: CupertinoTvTabBar(
              controller: _tabController,
              animationDuration: TabBarSample.animationDuration,
              focusScopeNode: _focusScopeNode,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 40,
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
              onDown: (_, _, isOutOfScope) {
                if (isOutOfScope) {
                  _contentFocusNode.requestFocus();
                }

                return KeyEventResult.handled;
              },
              tabs: [
                for (var i = 0; i < TabBarSample.items.length; ++i)
                  _TabItem(
                    index: i,
                    currentIndex: _currentIndex,
                    isTabBarFocused: _tabBarHasFocus,
                  ),
              ],
            ),
          ),
        ),
        child: _buildContent(text: text, icon: icon),
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
                  Icon(icon, size: 48, color: CupertinoColors.white),

                  Flexible(
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 20,
                      ),
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
                        ? TabBarSample.focusedColor
                        : CupertinoColors.transparent,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: const Text(
                    'Jump to selected tab',
                    style: TextStyle(
                      fontSize: 16,
                      color: CupertinoColors.white,
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

    final contentColor = isSelected
        ? TabBarSample.contentSelectedColor
        : TabBarSample.contentColor;

    final (text, icon, isTabTextVisible) = TabBarSample.items[index];

    return TvTab(
      autofocus: index == currentIndex,
      viewportAlignment: 0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Icon(icon, color: contentColor),

          if (isTabTextVisible)
            Text(text, style: TextStyle(color: contentColor, fontSize: 20)),
        ],
      ),
    );
  }
}
