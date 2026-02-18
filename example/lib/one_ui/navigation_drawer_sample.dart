import 'package:flutter/material.dart';
import 'package:tv_plus/tv_plus.dart';

const _animationDuration = Duration(milliseconds: 350);

final class OneUiNavigationDrawerSample extends StatefulWidget {
  const OneUiNavigationDrawerSample({super.key});

  static const backgroundColor = Color(0xFF131314);

  static const backgroundGradientCollapsed = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    stops: [0, 0.75, 1],
    colors: [
      OneUiNavigationDrawerSample.backgroundColor,
      OneUiNavigationDrawerSample.backgroundColor,
      Colors.transparent,
    ],
  );

  static const backgroundGradientExpanded = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      OneUiNavigationDrawerSample.backgroundColor,
      OneUiNavigationDrawerSample.backgroundColor,
    ],
  );

  static const drawerCornerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0, 0.4, 0.6, 0.8, 1],
    colors: [
      Colors.transparent,
      Colors.transparent,
      Colors.pink,
      Colors.transparent,
      Colors.transparent,
    ],
  );

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
        return const BoxDecoration(color: Colors.deepPurpleAccent);
      }

      if (states.contains(WidgetState.selected)) {
        return const BoxDecoration(color: Colors.indigoAccent);
      }

      if (states.contains(WidgetState.focused)) {
        return BoxDecoration(color: Colors.teal.withValues(alpha: 0.33));
      }

      return const BoxDecoration();
    });
  }

  static TvNavigationMenuItem buildItem({
    required String title,
    required IconData icon,
    required bool Function() isDrawerExpanded,
  }) {
    return TvNavigationMenuItem(
      key: ValueKey(title),
      iconBuilder: (_) => OneUiNavigationDrawerSample.buildIcon(icon),
      builder: (context, constraints, states, icon) {
        return Container(
          decoration: OneUiNavigationDrawerSample.buildDecoration().resolve(
            states,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          constraints: constraints,
          child: Row(
            children: [
              if (icon != null) Flexible(flex: 0, child: icon),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Opacity(
                    opacity: OneUiTvNavigationDrawer.animationOf(context).value,
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: OneUiNavigationDrawerSample.buildContentColor(
                          states,
                        ),
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
  State<StatefulWidget> createState() => _OneUiNavigationDrawerSampleState();
}

final class _OneUiNavigationDrawerSampleState
    extends State<OneUiNavigationDrawerSample> {
  final _items = OneUiNavigationDrawerSample.items.toList();

  late final _controller = TvNavigationMenuController(
    initialEntry: ItemEntry(
      key: ValueKey(OneUiNavigationDrawerSample.items[0].$1),
    ),
  );

  late final _contentFocusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, _) {
        return OneUiTvNavigationDrawer(
          controller: _controller,
          backgroundColor: OneUiNavigationDrawerSample.backgroundColor,
          drawerExpandDuration: _animationDuration,
          constraints: const BoxConstraints(minWidth: 64, maxWidth: 220),
          header: _buildHeader(),
          footer: _buildFooter(),
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
            return _buildItem(title: item.$1, icon: item.$2);
          }).toList(),
          onRight: (_, _, isOutOfScope) {
            if (isOutOfScope) {
              _contentFocusNode.requestFocus();
            }

            return KeyEventResult.handled;
          },
          drawerBuilder: (context, expandAnimation, child) {
            return Row(
              children: [
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: Gradient.lerp(
                        OneUiNavigationDrawerSample.backgroundGradientCollapsed,
                        OneUiNavigationDrawerSample.backgroundGradientExpanded,
                        expandAnimation.value,
                      ),
                    ),
                    child: child,
                  ),
                ),

                const SizedBox(
                  width: 4,
                  height: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient:
                          OneUiNavigationDrawerSample.drawerCornerGradient,
                    ),
                  ),
                ),
              ],
            );
          },
          builder: (context, animation, entry) {
            return DpadFocus(
              focusNode: _contentFocusNode,
              key: OneUiNavigationDrawerSample.contentKey,
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
                  alignment: Alignment.center,
                  child: Text('$entry content'),
                );
              },
            );
          },
        );
      },
    );
  }

  TvNavigationMenuItem _buildHeader() {
    return TvNavigationMenuItem(
      iconBuilder: (_) {
        return OneUiNavigationDrawerSample.buildIcon(Icons.account_circle);
      },
      builder: (context, constraints, states, icon) {
        return Container(
          decoration: OneUiNavigationDrawerSample.buildDecoration().resolve(
            states,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          constraints: constraints,
          child: Row(
            children: [
              if (icon != null) Flexible(flex: 0, child: icon),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Opacity(
                    opacity: OneUiTvNavigationDrawer.animationOf(context).value,
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
                            color:
                                OneUiNavigationDrawerSample.buildContentColor(
                                  states,
                                ),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Switch account',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                OneUiNavigationDrawerSample.buildContentColor(
                                  states,
                                ),
                          ),
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

  TvNavigationMenuItem _buildItem({
    required String title,
    required IconData icon,
  }) {
    return OneUiNavigationDrawerSample.buildItem(
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
