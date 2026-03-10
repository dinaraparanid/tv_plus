import 'package:flutter/material.dart';
import 'package:tv_plus_foundation/tv_plus_foundation.dart';
import 'package:tv_plus_sandstone/src/navigation/navigation.dart';

final class SandstoneHorizontalTabLayoutSample extends StatefulWidget {
  const SandstoneHorizontalTabLayoutSample({super.key});

  static const backgroundColor = Color(0xFF131314);
  static const indicatorColor = Colors.indigoAccent;
  static const contentColor = Colors.white;
  static const selectionRadius = BorderRadius.all(Radius.circular(4));
  static const initialIndex = 1;

  static final tabBarKey = GlobalKey();
  static final indicatorKey = GlobalKey();
  static final contentKey = GlobalKey();
  static final contentIconKey = GlobalKey();
  static final contentTitleKey = GlobalKey();
  static final contentJumpKey = GlobalKey();
  static final tabsKeys = List.generate(
    SandstoneHorizontalTabLayoutSample.items.length,
    (_) => GlobalKey(),
  );

  static const items = [
    ('Search', Icons.search),
    ('Home', Icons.home),
    ('Movies', Icons.movie),
    ('Settings', Icons.settings),
    ('Profile', Icons.person),
  ];

  @override
  State<StatefulWidget> createState() =>
      _SandstoneHorizontalTabLayoutSampleState();
}

final class _SandstoneHorizontalTabLayoutSampleState
    extends State<SandstoneHorizontalTabLayoutSample> {
  late final _focusScopeNode = FocusScopeNode();

  late final _contentFocusNode = FocusNode();

  late final _tabController = TvTabBarController(
    initialIndex: SandstoneHorizontalTabLayoutSample.initialIndex,
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
    final (text, icon) =
        SandstoneHorizontalTabLayoutSample.items[_currentIndex];

    return MaterialApp(
      home: Scaffold(
        backgroundColor: SandstoneHorizontalTabLayoutSample.backgroundColor,
        appBar: AppBar(
          backgroundColor: SandstoneHorizontalTabLayoutSample.backgroundColor,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SandstoneHorizontalTabLayout(
                key: SandstoneHorizontalTabLayoutSample.tabBarKey,
                controller: _tabController,
                focusScopeNode: _focusScopeNode,
                mainAxisAlignment: MainAxisAlignment.start,
                separatorBuilder: (_, _) => const SizedBox(),
                onDown: (_, _, isOutOfScope) {
                  if (isOutOfScope) {
                    _contentFocusNode.requestFocus();
                  }

                  return KeyEventResult.handled;
                },
                indicatorBuilder: _buildIndicator,
                tabs: [
                  for (
                    var i = 0;
                    i < SandstoneHorizontalTabLayoutSample.items.length;
                    ++i
                  )
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _TabItem(index: i, currentIndex: _currentIndex),
                    ),
                ],
              ),
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
    return tabBarHasFocus
        ? _buildPrimaryIndicator(context, tabOffset, tabSize)
        : _buildSecondaryIndicator(context, tabOffset, tabSize);
  }

  Widget _buildPrimaryIndicator(
    BuildContext context,
    Offset tabOffset,
    Size tabSize,
  ) {
    return Container(
      key: SandstoneHorizontalTabLayoutSample.indicatorKey,
      height: tabSize.height,
      width: tabSize.width,
      decoration: const BoxDecoration(
        color: SandstoneHorizontalTabLayoutSample.indicatorColor,
        borderRadius: SandstoneHorizontalTabLayoutSample.selectionRadius,
      ),
    );
  }

  Widget _buildSecondaryIndicator(
    BuildContext context,
    Offset tabOffset,
    Size tabSize,
  ) {
    return Container(
      key: SandstoneHorizontalTabLayoutSample.indicatorKey,
      height: 2,
      width: tabSize.width * 0.9,
      margin: EdgeInsets.only(left: tabSize.width * 0.05),
      decoration: const BoxDecoration(
        color: SandstoneHorizontalTabLayoutSample.indicatorColor,
        borderRadius: SandstoneHorizontalTabLayoutSample.selectionRadius,
      ),
    );
  }

  Widget _buildContent({required String text, required IconData icon}) {
    return Stack(
      key: SandstoneHorizontalTabLayoutSample.contentKey,
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
                    key: SandstoneHorizontalTabLayoutSample.contentIconKey,
                    size: 48,
                    color: Colors.white,
                  ),

                  Flexible(
                    child: Text(
                      text,
                      key: SandstoneHorizontalTabLayoutSample.contentTitleKey,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),

              DpadFocus(
                focusNode: _contentFocusNode,
                key: SandstoneHorizontalTabLayoutSample.contentJumpKey,
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
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    color: node.hasFocus
                        ? SandstoneHorizontalTabLayoutSample.indicatorColor
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
  const _TabItem({required this.index, required this.currentIndex});

  final int index;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;

    return TvTabItemSample(
      index: index,
      key: SandstoneHorizontalTabLayoutSample.tabsKeys[index],
      icon: SandstoneHorizontalTabLayoutSample.items[index].$2,
      text: SandstoneHorizontalTabLayoutSample.items[index].$1,
      color: SandstoneHorizontalTabLayoutSample.contentColor,
      isSelected: isSelected,
    );
  }
}

@visibleForTesting
final class TvTabItemSample extends StatelessWidget {
  const TvTabItemSample({
    super.key,
    required this.index,
    required this.icon,
    required this.text,
    required this.color,
    required this.isSelected,
  });

  final int index;
  final IconData icon;
  final String text;
  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return TvTab(
      autofocus: isSelected,
      onSelected: () => TvTabBarFoundation.of(context).select(index),
      child: Row(
        spacing: 8,
        children: [
          Icon(icon, color: color),
          Expanded(
            child: Text(text, style: TextStyle(color: color, fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
