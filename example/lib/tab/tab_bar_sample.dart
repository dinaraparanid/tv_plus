import 'package:flutter/material.dart';
import 'package:tv_plus/tv_plus.dart';

final class TabBarSample extends StatefulWidget {
  const TabBarSample({super.key});

  static const backgroundColor = Color(0xFF131314);
  static const focusedColor = Colors.indigoAccent;
  static const selectedColor = Colors.green;
  static const contentColor = Colors.white;
  static const contentHighlightedColor = Colors.black;
  static const radius = BorderRadius.all(Radius.circular(16.0));
  static const animationDuration = Duration(milliseconds: 300);
  static const tabBarHeight = 20.0;

  static const items = [
    ('Search', Icons.search),
    ('Home', Icons.home),
    ('Movies', Icons.movie),
    ('Shows', Icons.tv),
    ('Library', Icons.video_library),
  ];

  @override
  State<StatefulWidget> createState() => _TabBarSampleState();
}

final class _TabBarSampleState extends State<TabBarSample>
    with SingleTickerProviderStateMixin {
  static final _tabBarKey = GlobalKey();

  late final _focusScopeNode = FocusScopeNode();

  late final _tabsFocusNodes = List.generate(
    TabBarSample.items.length,
    (_) => FocusNode(),
  );

  late final _tabsKeys = List.generate(
    TabBarSample.items.length,
    (_) => GlobalKey(),
  );

  late final _contentFocusNode = FocusNode();

  late final _tabController = TvTabBarController(initialIndex: 1);

  late var _currentIndex = _tabController.selectedIndex;

  var _tabBarHasFocus = false;

  @override
  void initState() {
    _tabController.addListener(_tabListener);
    _focusScopeNode.addListener(_focusListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });

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

    for (final node in _tabsFocusNodes) {
      node.dispose();
    }

    _focusScopeNode.dispose();
    _contentFocusNode.dispose();

    _tabController.removeListener(_tabListener);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (text, icon) = TabBarSample.items[_currentIndex];

    return MaterialApp(
      home: Scaffold(
        backgroundColor: TabBarSample.backgroundColor,
        appBar: AppBar(
          backgroundColor: TabBarSample.backgroundColor,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(TabBarSample.tabBarHeight),
            child: Stack(
              children: [
                ?_buildSelection(),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: TvTabBar(
                    key: _tabBarKey,
                    controller: _tabController,
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
                    tabs: [
                      for (var i = 0; i < TabBarSample.items.length; ++i)
                        Padding(
                          key: _tabsKeys[i],
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _TabItem(
                            index: i,
                            focusNode: _tabsFocusNodes[i],
                            currentIndex: _currentIndex,
                          ),
                        ),
                    ],
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

  Widget? _buildSelection() {
    final (selectedOffset, selectedSize) = _getSelectionConstraints();

    if (selectedOffset == null || selectedSize == null) {
      return null;
    }

    return AnimatedPositioned(
      duration: TabBarSample.animationDuration,
      top: 0,
      bottom: 0,
      left: selectedOffset.dx,
      child: AnimatedContainer(
        duration: TabBarSample.animationDuration,
        width: selectedSize.width,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _tabBarHasFocus
                ? TabBarSample.focusedColor
                : TabBarSample.selectedColor,
            borderRadius: TabBarSample.radius,
          ),
        ),
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
                builder: (node) => Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    color: node.hasFocus
                        ? TabBarSample.focusedColor
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

  (Offset?, Size?) _getSelectionConstraints() {
    final obj = _tabsKeys[_currentIndex].currentContext?.findRenderObject();
    final box = obj is RenderBox ? obj : null;

    final parentObj = _tabBarKey.currentContext?.findRenderObject();
    final parentBox = parentObj is RenderBox ? parentObj : null;

    final hasSize = (box?.hasSize ?? false) && box?.size.width != 0;
    final globalOffset = hasSize ? box?.localToGlobal(Offset.zero) : null;

    final localOffset = globalOffset != null
        ? parentBox?.globalToLocal(globalOffset)
        : null;

    final size = hasSize ? box?.size : null;

    return (localOffset, size);
  }
}

final class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.index,
    required this.focusNode,
    required this.currentIndex,
  });

  final int index;
  final FocusNode focusNode;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final isHighlighted = index == currentIndex;

    final contentColor = isHighlighted
        ? TabBarSample.contentHighlightedColor
        : TabBarSample.contentColor;

    return AnimatedScale(
      scale: isHighlighted ? 1.2 : 1.0,
      duration: TabBarSample.animationDuration,
      child: TvTab(
        focusNode: focusNode,
        autofocus: index == currentIndex,
        viewportAlignment: 0,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Icon(TabBarSample.items[index].$2, color: contentColor),

            Text(
              TabBarSample.items[index].$1,
              style: TextStyle(color: contentColor, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
