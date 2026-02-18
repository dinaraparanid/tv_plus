import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tv_plus/tv_plus.dart';

const _animationDuration = Duration(milliseconds: 350);

final class NavigationDrawerSample extends StatefulWidget {
  const NavigationDrawerSample({
    super.key,
    this.isTimerEnabled = false,
    this.mode = TvNavigationDrawerMode.modal,
  });

  final bool isTimerEnabled;
  final TvNavigationDrawerMode mode;

  static const backgroundColor = Color(0xFF131314);
  static const backgroundColorTransparent = Color(0x03131314);

  static const items = [
    ('Search', Icons.search),
    ('Home', Icons.home),
    ('Movies', Icons.movie),
    ('Shows', Icons.tv),
    ('Library', Icons.video_library),
  ];

  static const contentKey = ValueKey('content');

  static Color buildContentColor(Set<WidgetState> states) =>
      states.contains(WidgetState.selected) ? Colors.black : Colors.white;

  static WidgetStateProperty<Icon> buildIcon(IconData data) {
    return WidgetStateProperty.resolveWith((states) {
      return Icon(data, size: 28, color: buildContentColor(states));
    });
  }

  static WidgetStateProperty<BoxDecoration> buildDecoration() {
    return WidgetStateProperty.resolveWith((states) {
      if (states.containsAll([WidgetState.selected, WidgetState.focused])) {
        return const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: Colors.deepPurpleAccent,
        );
      }

      if (states.contains(WidgetState.selected)) {
        return const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: Colors.indigoAccent,
        );
      }

      if (states.contains(WidgetState.focused)) {
        return BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          color: Colors.teal.withValues(alpha: 0.33),
        );
      }

      return const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      );
    });
  }

  static TvNavigationMenuItem buildItem({
    required String title,
    required IconData icon,
  }) {
    return TvNavigationMenuItem(
      key: ValueKey(title),
      iconBuilder: (_) => NavigationDrawerSample.buildIcon(icon),
      builder: (context, constraints, states, icon) {
        return Container(
          decoration: NavigationDrawerSample.buildDecoration().resolve(states),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          constraints: constraints,
          child: Row(
            children: [
              if (icon != null) Flexible(flex: 0, child: icon),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Opacity(
                    opacity: TvNavigationDrawer.animationOf(context).value,
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: NavigationDrawerSample.buildContentColor(states),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  State<StatefulWidget> createState() => _NavigationDrawerSampleState();
}

final class _NavigationDrawerSampleState extends State<NavigationDrawerSample> {
  final _items = NavigationDrawerSample.items.toList();

  late final Timer timer;

  late final _controller = TvNavigationMenuController(
    initialEntry: ItemEntry(key: ValueKey(NavigationDrawerSample.items[0].$1)),
  );

  late final _contentFocusNode = FocusNode();

  var _isHeaderPresent = true;
  var _isFooterPresent = true;

  @override
  void initState() {
    if (widget.isTimerEnabled) {
      timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (_items.length > 1) {
          setState(() {
            _items.removeLast();
            _invalidateItems();
          });
        } else if (_isHeaderPresent) {
          if (_controller.selectedEntry is HeaderEntry) {
            _controller.select(_selectedEntryFallback());
          }

          setState(() => _isHeaderPresent = false);
        } else if (_isFooterPresent) {
          if (_controller.selectedEntry is FooterEntry) {
            _controller.select(_selectedEntryFallback());
          }

          setState(() => _isFooterPresent = false);
        } else {
          timer.cancel();
        }
      });
    }

    super.initState();
  }

  void _invalidateItems() {
    _controller.invalidateItemsNodes(
      newItems: {for (final item in _items) ValueKey(item.$1): FocusNode()},
      onSelectedItemRemoved: _selectedEntryFallback,
    );
  }

  TvNavigationMenuEntry _selectedEntryFallback() =>
      ItemEntry(key: ValueKey(_items.first.$1));

  @override
  void dispose() {
    if (widget.isTimerEnabled) {
      timer.cancel();
    }

    _controller.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, _) {
        return TvNavigationDrawer(
          controller: _controller,
          backgroundColor: NavigationDrawerSample.backgroundColor,
          drawerExpandDuration: _animationDuration,
          constraints: const BoxConstraints(minWidth: 80, maxWidth: 220),
          mode: widget.mode,
          header: _isHeaderPresent ? _buildHeader() : null,
          footer: _isFooterPresent ? _buildFooter() : null,
          separatorBuilder: (i) {
            if (i == const ItemEntry(key: ValueKey('Home'))) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  _buildContentSeparator(),
                  const SizedBox(height: 4),
                ],
              );
            }

            return const SizedBox(height: 12);
          },
          menuItems: _items.map((item) {
            return NavigationDrawerSample.buildItem(
              title: item.$1,
              icon: item.$2,
            );
          }).toList(),
          onRight: (_, _, isOutOfScope) {
            if (isOutOfScope) {
              _contentFocusNode.requestFocus();
            }

            return KeyEventResult.handled;
          },
          drawerBuilder: (context, animation, child) {
            return DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    NavigationDrawerSample.backgroundColor,
                    NavigationDrawerSample.backgroundColorTransparent,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Padding(padding: const EdgeInsets.all(8), child: child),
            );
          },
          builder: (context, animation, entry) {
            return Stack(
              children: [
                Align(
                  child: DpadFocus(
                    focusNode: _contentFocusNode,
                    key: NavigationDrawerSample.contentKey,
                    autofocus: true,
                    onLeft: (_, _) {
                      _controller.requestFocusOnMenu();
                      return KeyEventResult.handled;
                    },
                    builder: (context, node) {
                      return Container(
                        color: Color.lerp(
                          Colors.indigoAccent,
                          Colors.green,
                          animation.value,
                        ),
                        width: 700,
                        height: 500,
                        alignment: Alignment.center,
                        child: Text('$entry content'),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  TvNavigationMenuItem _buildHeader() {
    return TvNavigationMenuItem(
      iconBuilder: (_) =>
          NavigationDrawerSample.buildIcon(Icons.account_circle),
      builder: (context, constraints, states, icon) {
        final contentColor = NavigationDrawerSample.buildContentColor(states);

        return Container(
          decoration: NavigationDrawerSample.buildDecoration().resolve(states),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          constraints: constraints,
          child: Row(
            children: [
              if (icon != null) Flexible(flex: 0, child: icon),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Opacity(
                    opacity: TvNavigationDrawer.animationOf(context).value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: contentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Switch account',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: contentColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  TvNavigationMenuItem _buildFooter() {
    return NavigationDrawerSample.buildItem(
      title: 'Settings',
      icon: Icons.settings,
    );
  }

  Widget _buildContentSeparator() {
    return AnimatedCrossFade(
      duration: _animationDuration,
      crossFadeState: _controller.hasFocus
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: const Row(
        children: [
          SizedBox(width: 16),

          Expanded(
            child: Text(
              'Content',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
      secondChild: const SizedBox(
        height: 1,
        width: double.infinity,
        child: DecoratedBox(decoration: BoxDecoration(color: Colors.blueGrey)),
      ),
    );
  }
}
