import 'package:flutter/cupertino.dart';
import 'package:tv_plus_cupertino/src/search/search.dart';
import 'package:tv_plus_cupertino/tv_plus_cupertino.dart';

final class CupertinoSearchBarSample extends StatefulWidget {
  const CupertinoSearchBarSample({super.key});

  static const items = [
    ('Crimson Red', CupertinoColors.systemRed),
    ('Emerald Green', CupertinoColors.systemGreen),
    ('Royal Blue', CupertinoColors.systemBlue),
    ('Bright Orange', CupertinoColors.systemOrange),
    ('Sunny Yellow', CupertinoColors.systemYellow),
    ('Deep Purple', CupertinoColors.systemPurple),
    ('Hot Pink', CupertinoColors.systemPink),
    ('Slate Grey', CupertinoColors.systemGrey),
    ('Cyan', CupertinoColors.systemCyan),
    ('Indigo', CupertinoColors.systemIndigo),
  ];

  @override
  State<StatefulWidget> createState() => _CupertinoSearchBarSampleState();
}

final class _CupertinoSearchBarSampleState
    extends State<CupertinoSearchBarSample> {
  late final _controller = TVSearchController();
  late final _searchScopeNode = FocusScopeNode();
  late final _gridScopeNode = FocusScopeNode();

  @override
  void dispose() {
    _controller.dispose();
    _searchScopeNode.dispose();
    _gridScopeNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(brightness: Brightness.dark),
      builder: (context, _) => CupertinoPageScaffold(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 80),
              sliver: SliverToBoxAdapter(
                child: CupertinoTvSearchBar(
                  controller: _controller,
                  focusScopeNode: _searchScopeNode,
                  placeholder: 'Search by color name',
                  searchIcon: const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(
                      CupertinoIcons.search,
                      size: 48,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  placeholderStyle: const TextStyle(
                    fontSize: 32,
                    color: CupertinoColors.systemGrey,
                    fontWeight: FontWeight.w700,
                  ),
                  queryStyle: const TextStyle(
                    fontSize: 32,
                    color: CupertinoColors.systemGrey6,
                    fontWeight: FontWeight.w700,
                  ),
                  onDown: (_, _, isOutOfScope) {
                    if (isOutOfScope) {
                      _gridScopeNode.requestFocus();
                      return KeyEventResult.handled;
                    }

                    return KeyEventResult.ignored;
                  },
                  onFocusChanged: (node, isFocused) {
                    final context = node.context;

                    if (context != null && isFocused) {
                      Scrollable.ensureVisible(context);
                    }
                  },
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(
                vertical: 80,
                horizontal: 160,
              ),
              sliver: SliverTVScrollAdapter(
                focusScopeNode: _gridScopeNode,
                onUp: (_, _, isOutOfScope) {
                  if (isOutOfScope) {
                    _searchScopeNode.requestFocus();
                    return KeyEventResult.handled;
                  }

                  return KeyEventResult.ignored;
                },
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisSpacing: 60,
                    crossAxisSpacing: 50,
                    childAspectRatio: 1.2,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    childCount: CupertinoSearchBarSample.items.length,
                    (context, index) => _Item(
                      autofocus: index == 0,
                      color: CupertinoSearchBarSample.items[index].$2,
                      name: CupertinoSearchBarSample.items[index].$1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _Item extends StatefulWidget {
  const _Item({
    required this.color,
    required this.name,
    required this.autofocus,
  });

  final Color color;
  final String name;
  final bool autofocus;

  @override
  State<StatefulWidget> createState() => _ItemState();
}

final class _ItemState extends State<_Item> {
  var _isScaled = false;

  static const _duration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    return DpadFocus(
      autofocus: widget.autofocus,
      onFocusChanged: (_, isFocused) {
        setState(() => _isScaled = isFocused);
      },
      builder: (_, _) => AnimatedScale(
        scale: _isScaled ? 1.1 : 1,
        duration: _duration,
        child: Container(
          decoration: const BoxDecoration(
            color: CupertinoColors.darkBackgroundGray,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            boxShadow: [BoxShadow(blurRadius: 10)],
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  ColoredBox(
                    color: widget.color,
                    child: const SizedBox(width: double.infinity, height: 200),
                  ),

                  Text(widget.name),
                ],
              ),

              Positioned.fill(
                child: AnimatedContainer(
                  duration: _duration,
                  color: _isScaled
                      ? const Color(0x1AFFFFFF)
                      : CupertinoColors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
