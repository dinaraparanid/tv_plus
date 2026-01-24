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
      return Icon(data, size: 32, color: buildContentColor(states));
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
    required bool Function() isDrawerExpanded,
  }) {
    return TvNavigationMenuItem(
      key: ValueKey(title),
      icon: NavigationDrawerSample.buildIcon(icon),
      decoration: NavigationDrawerSample.buildDecoration(),
      builder: (_, constraints, states) {
        return ConstrainedBox(
          constraints: constraints,
          child: Stack(
            children: [
              AnimatedOpacity(
                opacity: isDrawerExpanded() ? 1 : 0,
                duration: _animationDuration,
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

  TvNavigationMenuSelectionEntry _selectedEntryFallback() =>
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
          mode: widget.mode,
          header: _isHeaderPresent ? _buildHeader() : null,
          footer: _isFooterPresent ? _buildFooter() : null,
          separatorBuilder: (i) {
            if (i == 2) {
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
            return _buildItem(title: item.$1, icon: item.$2);
          }).toList(),
          onRight: (_, _, isOutOfScope) {
            if (isOutOfScope) {
              _contentFocusNode.requestFocus();
            }

            return KeyEventResult.handled;
          },
          drawerBuilder: (context, child) {
            return DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    NavigationDrawerSample.backgroundColor,
                    Colors.transparent,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Padding(padding: const EdgeInsets.all(20), child: child),
            );
          },
          builder: (context, entry) {
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
                    builder: (node) {
                      return AnimatedContainer(
                        duration: _animationDuration,
                        color: node.hasFocus
                            ? Colors.green
                            : Colors.indigoAccent,
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
      icon: NavigationDrawerSample.buildIcon(Icons.account_circle),
      decoration: NavigationDrawerSample.buildDecoration(),
      builder: (_, constraints, states) {
        return ConstrainedBox(
          constraints: constraints,
          child: AnimatedOpacity(
            opacity: _controller.hasFocus ? 1 : 0,
            duration: _animationDuration,
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
                    color: NavigationDrawerSample.buildContentColor(states),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Switch account',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: NavigationDrawerSample.buildContentColor(states),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  TvNavigationMenuItem _buildItem({
    required String title,
    required IconData icon,
  }) {
    return NavigationDrawerSample.buildItem(
      title: title,
      icon: icon,
      isDrawerExpanded: () => _controller.hasFocus,
    );
  }

  TvNavigationMenuItem _buildFooter() {
    return _buildItem(title: 'Settings', icon: Icons.settings);
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

          Text(
            'Content',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w800,
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
