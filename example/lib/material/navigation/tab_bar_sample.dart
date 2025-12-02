import 'package:flutter/material.dart';
import 'package:tv_plus/tv_plus.dart';

final class TabBarSample extends StatefulWidget {
  const TabBarSample({super.key});

  static const backgroundColor = Color(0xFF131314);
  static const focusedColor = Colors.indigoAccent;
  static const selectedColor = Colors.green;
  static const radius = BorderRadius.all(Radius.circular(16.0));

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
  late final _focusScopeNode = FocusScopeNode();

  late final _tabsFocusNodes = List.generate(
    TabBarSample.items.length,
    (_) => FocusNode(),
  );

  late final _contentFocusNode = FocusNode();

  late final _tabController = TvTabBarController(initialIndex: 1);

  var _currentIndex = 0;

  FocusNode? _focusedNode;
  FocusNode? _selectedNode;

  @override
  void initState() {
    _tabController.addListener(_tabListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshFocusedNode();
      _refreshSelectedNode();
    });

    super.initState();
  }

  void _tabListener() {
    if (_currentIndex != _tabController.selectedIndex ||
        _selectedNode != _tabsFocusNodes[_currentIndex]) {
      _refreshSelectedNode();
    }
  }

  void _refreshFocusedNode() {
    setState(() => _focusedNode = _focusScopeNode.focusedChild);
  }

  void _refreshSelectedNode() {
    setState(() {
      _currentIndex = _tabController.selectedIndex;
      _selectedNode = _tabsFocusNodes[_currentIndex];
    });
  }

  @override
  void dispose() {
    for (final node in _tabsFocusNodes) {
      node.dispose();
    }

    _contentFocusNode.dispose();

    _tabController.removeListener(_tabListener);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (text, icon) = TabBarSample.items[_currentIndex];

    final selectedObj = _selectedNode?.context?.findRenderObject();
    final selectedBox = selectedObj is RenderBox ? selectedObj : null;
    final selectedHasSize = selectedBox?.hasSize ?? false;
    final selectedOffset = selectedHasSize
        ? selectedBox?.localToGlobal(Offset.zero)
        : null;
    final selectedSize = selectedHasSize ? selectedBox?.size : null;

    final focusedObj = _focusedNode?.context?.findRenderObject();
    final focusedBox = focusedObj is RenderBox ? focusedObj : null;
    final focusedHasSize = focusedBox?.hasSize ?? false;
    final focusedOffset = focusedHasSize
        ? focusedBox?.localToGlobal(Offset.zero)
        : null;
    final focusedSize = focusedHasSize ? focusedBox?.size : null;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: TabBarSample.backgroundColor,
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Stack(
              children: [
                if (selectedOffset != null && selectedSize != null)
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: selectedOffset.dx,
                    child: SizedBox(
                      width: selectedSize.width,
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          color: TabBarSample.selectedColor,
                          borderRadius: TabBarSample.radius,
                        ),
                      ),
                    ),
                  ),

                if (_focusedNode != _selectedNode &&
                    focusedOffset != null &&
                    focusedSize != null)
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: focusedOffset.dx,
                    child: SizedBox(
                      width: focusedSize.width,
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          color: TabBarSample.focusedColor,
                          borderRadius: TabBarSample.radius,
                        ),
                      ),
                    ),
                  ),

                TvTabBar(
                  controller: _tabController,
                  focusScopeNode: _focusScopeNode,
                  onDown: (_, _, isOutOfScope) {
                    if (isOutOfScope) {
                      _contentFocusNode.requestFocus();
                    }

                    return KeyEventResult.handled;
                  },
                  onLeft: (_, _, _) {
                    _refreshFocusedNode();
                    return KeyEventResult.handled;
                  },
                  onRight: (_, _, _) {
                    _refreshFocusedNode();
                    return KeyEventResult.handled;
                  },
                  tabs: [
                    for (var i = 0; i < TabBarSample.items.length; i++)
                      TvTab(
                        text: TabBarSample.items[i].$1,
                        icon: Icon(TabBarSample.items[i].$2),
                        focusNode: _tabsFocusNodes[i],
                        autofocus: i == _currentIndex,
                        onSelect: (_, _) {
                          _tabController.selectIndex(i);
                          return KeyEventResult.handled;
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
          title: const Text('Tabs Demo'),
        ),
        body: _buildContent(text: text, icon: icon),
      ),
    );
  }

  Widget _buildContent({required String text, required IconData icon}) {
    return Column(
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
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
    );
  }
}
