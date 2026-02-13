import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:tv_plus/tv_plus.dart';

final class CupertinoSidebarSample extends StatefulWidget {
  const CupertinoSidebarSample({super.key});

  static const backgroundColor = Color(0x801E1E1E);

  static const items = [
    ('Search', CupertinoIcons.search),
    ('Home', CupertinoIcons.home),
    ('Movies', CupertinoIcons.video_camera),
    ('Shows', CupertinoIcons.tv),
    ('Library', CupertinoIcons.play_rectangle),
  ];

  static const contentKey = ValueKey('content');
  static const collapsedHeaderKey = ValueKey('collapsed-header');
  static const sidebarKey = ValueKey('sidebar');

  static Color buildContentColor(Set<WidgetState> states) {
    return CupertinoColors.white;
  }

  static WidgetStateProperty<Icon> buildIcon(IconData data) {
    return WidgetStateProperty.resolveWith((states) {
      return Icon(
        data,
        size: 20,
        color: CupertinoSidebarSample.buildContentColor(states),
      );
    });
  }

  static WidgetStateProperty<BoxDecoration> buildDecoration() {
    const radius = BorderRadius.all(Radius.circular(16));

    return WidgetStateProperty.resolveWith((states) {
      if (states.containsAll([WidgetState.selected, WidgetState.focused])) {
        return const BoxDecoration(
          borderRadius: radius,
          color: CupertinoColors.activeBlue,
        );
      }

      if (states.contains(WidgetState.selected)) {
        return const BoxDecoration(
          borderRadius: radius,
          color: CupertinoColors.systemIndigo,
        );
      }

      if (states.contains(WidgetState.focused)) {
        return BoxDecoration(
          borderRadius: radius,
          color: CupertinoColors.systemTeal.withValues(alpha: 0.33),
        );
      }

      return const BoxDecoration(borderRadius: radius);
    });
  }

  static TvNavigationMenuItem buildItem({
    required String title,
    required IconData icon,
  }) {
    return TvNavigationMenuItem(
      key: ValueKey(title),
      icon: CupertinoSidebarSample.buildIcon(icon),
      decoration: CupertinoSidebarSample.buildDecoration(),
      contentPadding: const EdgeInsets.all(12),
      builder: (_, constraints, states) {
        return ConstrainedBox(
          constraints: constraints,
          child: Stack(
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  color: CupertinoSidebarSample.buildContentColor(states),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  State<StatefulWidget> createState() => _CupertinoSidebarSampleState();
}

final class _CupertinoSidebarSampleState extends State<CupertinoSidebarSample> {
  static const _animationDuration = Duration(milliseconds: 350);

  late final _controller = TvNavigationMenuController(
    initialEntry: ItemEntry(key: ValueKey(CupertinoSidebarSample.items[0].$1)),
    focusScopeNode: FocusScopeNode(),
    headerNode: FocusNode(),
    footerNode: FocusNode(),
    itemsNodes: {
      for (final item in CupertinoSidebarSample.items)
        ValueKey(item.$1): FocusNode(),
    },
  );

  late final _contentFocusNode = FocusNode();

  final _items = CupertinoSidebarSample.items.toList();

  @override
  void dispose() {
    _controller.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(brightness: Brightness.dark),
      builder: (context, _) {
        return CupertinoTvSidebar(
          controller: _controller,
          header: _buildHeader(),
          footer: _buildFooter(),
          separatorBuilder: (i) {
            if (i == const ItemEntry(key: ValueKey('Home'))) {
              return const Row(
                children: [
                  SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 28),

                        Text(
                          'Content',
                          style: TextStyle(
                            fontSize: 18,
                            color: CupertinoColors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              );
            }

            return const SizedBox(height: 6);
          },
          menuItems: _items.map((item) {
            return CupertinoSidebarSample.buildItem(
              title: item.$1,
              icon: item.$2,
            );
          }).toList(),
          backgroundColor: CupertinoColors.darkBackgroundGray,
          drawerAnimationsDuration: _animationDuration,
          onRight: (_, _, isOutOfScope) {
            if (isOutOfScope) {
              _contentFocusNode.requestFocus();
            }

            return KeyEventResult.handled;
          },
          collapsedHeaderBuilder: (context, _, selectedItem) {
            return CupertinoTvSidebarFloatingHeader(
              key: CupertinoSidebarSample.collapsedHeaderKey,
              controller: _controller,
              selectedItem: selectedItem,
            );
          },
          sidebarBuilder: (context, child) {
            const radius = BorderRadius.all(Radius.circular(40));
            const blurSigma = 135.91;

            return ClipRRect(
              key: CupertinoSidebarSample.sidebarKey,
              borderRadius: radius,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: CupertinoSidebarSample.backgroundColor,
                    borderRadius: radius,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 10,
                    ),
                    child: child,
                  ),
                ),
              ),
            );
          },
          builder: (context, entry) {
            return Stack(
              children: [
                Align(
                  child: DpadFocus(
                    focusNode: _contentFocusNode,
                    key: CupertinoSidebarSample.contentKey,
                    autofocus: true,
                    onLeft: (_, _) {
                      _controller.requestFocusOnMenu();
                      return KeyEventResult.handled;
                    },
                    builder: (context, node) {
                      return AnimatedContainer(
                        duration: _animationDuration,
                        color: node.hasFocus
                            ? CupertinoColors.systemGreen
                            : CupertinoColors.systemIndigo,
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

  static TvNavigationMenuItem _buildHeader() {
    return TvNavigationMenuItem(
      key: UniqueKey(),
      icon: CupertinoSidebarSample.buildIcon(CupertinoIcons.profile_circled),
      decoration: CupertinoSidebarSample.buildDecoration(),
      builder: (_, constraints, states) {
        return ConstrainedBox(
          constraints: constraints,
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
                  color: CupertinoSidebarSample.buildContentColor(states),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Switch account',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: CupertinoSidebarSample.buildContentColor(states),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static TvNavigationMenuItem _buildFooter() {
    return CupertinoSidebarSample.buildItem(
      title: 'Settings',
      icon: CupertinoIcons.settings,
    );
  }
}
