import 'package:flutter/material.dart';
import 'package:tv_plus/tv_plus.dart';

final class TvTabBarFoundationSample extends StatefulWidget {
  const TvTabBarFoundationSample({super.key});

  static const backgroundColor = Color(0xFF131314);
  static const focusedColor = Colors.indigoAccent;
  static const selectedColor = Colors.green;
  static const contentColor = Colors.white;
  static const contentSelectedColor = Colors.black;
  static const radius = BorderRadius.all(Radius.circular(16.0));
  static const animationDuration = Duration(milliseconds: 300);
  static const tabBarHeight = 20.0;
  static const initialIndex = 1;

  static final tabBarKey = GlobalKey();
  static final indicatorKey = GlobalKey();
  static final contentKey = GlobalKey();
  static final contentIconKey = GlobalKey();
  static final contentTitleKey = GlobalKey();
  static final contentJumpKey = GlobalKey();
  static final tabsKeys = List.generate(
    TvTabBarFoundationSample.items.length,
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
  State<StatefulWidget> createState() => _TvTabBarFoundationSampleState();
}

final class _TvTabBarFoundationSampleState
    extends State<TvTabBarFoundationSample> {
  late final _focusScopeNode = FocusScopeNode();

  late final _scrollController = ScrollController();

  late final _contentFocusNode = FocusNode();

  late final _tabController = TvTabBarController(
    initialIndex: TvTabBarFoundationSample.initialIndex,
  );

  late var _currentIndex = _tabController.selectedIndex;

  var _tabBarHasFocus = false;

  Offset? _selectedOffset;
  Size? _selectedSize;

  @override
  void initState() {
    _tabController.addListener(_tabListener);
    _focusScopeNode.addListener(_focusListener);

    // Required for _buildIndicator() in order to update
    // selected tab's RenderBox position and constraints.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSelectionConstraints();
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
    _tabController.removeListener(_tabListener);

    _focusScopeNode.dispose();
    _contentFocusNode.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (text, icon) = TvTabBarFoundationSample.items[_currentIndex];

    return MaterialApp(
      home: Scaffold(
        backgroundColor: TvTabBarFoundationSample.backgroundColor,
        appBar: AppBar(
          backgroundColor: TvTabBarFoundationSample.backgroundColor,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(
              TvTabBarFoundationSample.tabBarHeight,
            ),
            child: Stack(
              children: [
                ?_buildIndicator(),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: TvTabBarFoundation(
                    key: TvTabBarFoundationSample.tabBarKey,
                    controller: _tabController,
                    focusScopeNode: _focusScopeNode,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    separatorBuilder: (_, _) => const SizedBox(width: 16),
                    onDown: (_, _, isOutOfScope) {
                      if (isOutOfScope) {
                        _contentFocusNode.requestFocus();
                      }

                      return KeyEventResult.handled;
                    },
                    tabs: [
                      for (
                        var i = 0;
                        i < TvTabBarFoundationSample.items.length;
                        ++i
                      )
                        TabItem(
                          key: TvTabBarFoundationSample.tabsKeys[i],
                          index: i,
                          currentIndex: _currentIndex,
                          onFocusChanged: (_, hasFocus) {
                            if (hasFocus) {
                              _updateSelectionConstraints();
                            }
                          },
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

  Widget? _buildIndicator() {
    final offset = _selectedOffset?.dx;
    final width = _selectedSize?.width;

    if (offset == null || width == null) {
      return null;
    }

    return AnimatedPositioned(
      key: TvTabBarFoundationSample.indicatorKey,
      duration: TvTabBarFoundationSample.animationDuration,
      top: 0,
      bottom: 0,
      left: offset,
      child: AnimatedContainer(
        duration: TvTabBarFoundationSample.animationDuration,
        width: width,
        decoration: BoxDecoration(
          color: _tabBarHasFocus
              ? TvTabBarFoundationSample.focusedColor
              : TvTabBarFoundationSample.selectedColor,
          borderRadius: TvTabBarFoundationSample.radius,
        ),
      ),
    );
  }

  Widget _buildContent({required String text, required IconData icon}) {
    return Stack(
      key: TvTabBarFoundationSample.contentKey,
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
                    key: TvTabBarFoundationSample.contentIconKey,
                    size: 48,
                    color: Colors.white,
                  ),

                  Flexible(
                    child: Text(
                      text,
                      key: TvTabBarFoundationSample.contentTitleKey,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),

              DpadFocus(
                focusNode: _contentFocusNode,
                key: TvTabBarFoundationSample.contentJumpKey,
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
                        ? TvTabBarFoundationSample.focusedColor
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

  void _updateSelectionConstraints() {
    final (offset, size) = _getSelectionConstraints();

    if (offset != null && size != null) {
      setState(() {
        _selectedOffset = offset;
        _selectedSize = size;
      });
    }
  }

  (Offset?, Size?) _getSelectionConstraints() {
    final obj = TvTabBarFoundationSample.tabsKeys[_currentIndex].currentContext
        ?.findRenderObject();

    final box = obj is RenderBox ? obj : null;

    final parentObj = TvTabBarFoundationSample.tabBarKey.currentContext
        ?.findRenderObject();

    final parentBox = parentObj is RenderBox ? parentObj : null;

    final hasSize = (box?.hasSize ?? false) && box?.size.width != 0;
    final globalOffset = hasSize ? box?.localToGlobal(Offset.zero) : null;

    final localOffset = globalOffset != null
        ? parentBox?.globalToLocal(globalOffset)
        : null;

    final scrollOffset = _scrollController.hasClients
        ? _scrollController.offset
        : 0;

    final visibleOffset = localOffset == null
        ? null
        : Offset(localOffset.dx - scrollOffset, localOffset.dy);

    final size = hasSize ? box?.size : null;

    return (visibleOffset, size);
  }
}

@visibleForTesting
final class TabItem extends StatelessWidget {
  const TabItem({
    super.key,
    required this.index,
    required this.currentIndex,
    required this.onFocusChanged,
  });

  final int index;
  final int currentIndex;
  final void Function(FocusNode, bool)? onFocusChanged;

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;

    final contentColor = isSelected
        ? TvTabBarFoundationSample.contentSelectedColor
        : TvTabBarFoundationSample.contentColor;

    return AnimatedScale(
      scale: isSelected ? 1.2 : 1.0,
      duration: TvTabBarFoundationSample.animationDuration,
      child: TvTab(
        autofocus: index == currentIndex,
        onFocusChanged: onFocusChanged,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              Icon(
                TvTabBarFoundationSample.items[index].$2,
                color: contentColor,
              ),

              Text(
                TvTabBarFoundationSample.items[index].$1,
                style: TextStyle(color: contentColor, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
