import 'package:flutter/cupertino.dart';
import 'package:tv_plus/tv_plus.dart';

final class SidebarSample extends StatefulWidget {
  const SidebarSample({super.key});

  static const backgroundColor = Color(0x801E1E1E);

  static const items = [
    ('Search', CupertinoIcons.search),
    ('Home', CupertinoIcons.home),
    ('Movies', CupertinoIcons.video_camera),
    ('Shows', CupertinoIcons.tv),
    ('Library', CupertinoIcons.play_rectangle),
  ];

  @override
  State<StatefulWidget> createState() => _SidebarSampleState();
}

final class _SidebarSampleState extends State<SidebarSample> {
  static const _animationDuration = Duration(milliseconds: 350);

  final controller = TvNavigationController(
    initialEntry: ItemEntry(key: ValueKey(SidebarSample.items[0].$1)),
  );

  var items = SidebarSample.items.toList();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(brightness: Brightness.dark),
      builder: (context, _) {
        return CupertinoTvSidebar(
          controller: controller,
          headerBuilder: _buildHeader,
          footerBuilder: _buildFooter,
          separatorBuilder: (i) {
            if (i == 2) {
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
          menuItems: items.map((item) {
            return _buildItem(title: item.$1, icon: item.$2);
          }).toList(),
          backgroundColor: CupertinoColors.darkBackgroundGray,
          drawerDecoration: const BoxDecoration(
            color: SidebarSample.backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          drawerOffset: const Offset(35, 18),
          drawerAnimationsDuration: _animationDuration,
          builder: (context, entry, focusNode) {
            return Stack(
              children: [
                Align(
                  child: DpadFocus(
                    focusNode: focusNode,
                    autofocus: true,
                    onLeft: (_, _) {
                      controller.mediatorFocusNode.requestFocus();
                      return KeyEventResult.handled;
                    },
                    builder: (node) {
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

  TvNavigationItem _buildHeader() {
    return TvNavigationItem(
      key: UniqueKey(),
      icon: _buildIcon(CupertinoIcons.profile_circled),
      decoration: _buildDecoration(),
      builder: (_, constraints, states) {
        return ConstrainedBox(
          constraints: constraints,
          child: AnimatedOpacity(
            opacity: controller.hasFocus ? 1 : 0,
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

  TvNavigationItem _buildItem({required String title, required IconData icon}) {
    return TvNavigationItem(
      key: ValueKey(title),
      icon: _buildIcon(icon),
      decoration: _buildDecoration(),
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
                  color: _buildContentColor(states),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  TvNavigationItem _buildFooter() {
    return _buildItem(title: 'Settings', icon: CupertinoIcons.settings);
  }

  WidgetStateProperty<BoxDecoration> _buildDecoration() {
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

  WidgetStateProperty<Icon> _buildIcon(IconData data) {
    return WidgetStateProperty.resolveWith((states) {
      return Icon(data, size: 20, color: _buildContentColor(states));
    });
  }

  Color _buildContentColor(Set<WidgetState> states) => CupertinoColors.white;
}
