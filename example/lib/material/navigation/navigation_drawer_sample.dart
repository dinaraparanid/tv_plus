import 'package:flutter/material.dart';
import 'package:tv_plus/tv_plus.dart';

final class NavigationDrawerSample extends StatefulWidget {
  const NavigationDrawerSample({super.key});

  static const backgroundColor = Color(0xFF131314);

  static const items = [
    ('Search', Icons.search),
    ('Home', Icons.home),
    ('Movies', Icons.movie),
    ('Shows', Icons.tv),
    ('Library', Icons.video_library),
  ];

  @override
  State<StatefulWidget> createState() => _NavigationDrawerSampleState();
}

final class _NavigationDrawerSampleState extends State<NavigationDrawerSample> {
  static const _animationDuration = Duration(milliseconds: 350);

  final _items = NavigationDrawerSample.items.toList();

  // late final Timer timer;

  late final _controller = TvNavigationMenuController(
    initialEntry: ItemEntry(key: ValueKey(NavigationDrawerSample.items[0].$1)),
    focusScopeNode: FocusScopeNode(),
    headerNode: FocusNode(),
    footerNode: FocusNode(),
    itemsNodes: {
      for (final item in NavigationDrawerSample.items)
        ValueKey(item.$1): FocusNode(),
    },
  );

  late final _contentFocusNode = FocusNode();

  @override
  void initState() {
    // Testing
    // timer = Timer.periodic(Duration(seconds: 3), (_) {
    //   if (items.length > 1) {
    //     setState(() => items.removeLast());
    //   }
    // });

    super.initState();
  }

  @override
  void dispose() {
    // timer.cancel();
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
          mode: TvNavigationDrawerMode.modal,
          header: _buildHeader(),
          footer: _buildFooter(),
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

  WidgetStateProperty<BoxDecoration> _buildDecoration() {
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

  Color _buildContentColor(Set<WidgetState> states) =>
      states.contains(WidgetState.selected) ? Colors.black : Colors.white;

  WidgetStateProperty<Icon> _buildIcon(IconData data) {
    return WidgetStateProperty.resolveWith((states) {
      return Icon(data, size: 32, color: _buildContentColor(states));
    });
  }

  TvNavigationMenuItem _buildHeader() {
    return TvNavigationMenuItem(
      key: UniqueKey(),
      icon: _buildIcon(Icons.account_circle),
      decoration: _buildDecoration(),
      builder: (_, constraints, states) {
        return ConstrainedBox(
          constraints: constraints,
          child: AnimatedOpacity(
            opacity: _controller.focusScopeNode.hasFocus ? 1 : 0,
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
                    color: _buildContentColor(states),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Switch account',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: _buildContentColor(states),
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
    return TvNavigationMenuItem(
      key: ValueKey(title),
      icon: _buildIcon(icon),
      decoration: _buildDecoration(),
      builder: (_, constraints, states) {
        return ConstrainedBox(
          constraints: constraints,
          child: Stack(
            children: [
              AnimatedOpacity(
                opacity: _controller.focusScopeNode.hasFocus ? 1 : 0,
                duration: _animationDuration,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: _buildContentColor(states),
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

  TvNavigationMenuItem _buildFooter() {
    return _buildItem(title: 'Settings', icon: Icons.settings);
  }

  Widget _buildContentSeparator() {
    return AnimatedCrossFade(
      duration: _animationDuration,
      crossFadeState: _controller.focusScopeNode.hasFocus
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
