import 'package:flutter/cupertino.dart';
import 'package:tv_plus/tv_plus.dart';

final class SidebarSample extends StatefulWidget {
  const SidebarSample({super.key});

  static const backgroundColor = Color(0xFF131314);

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
        return DecoratedBox(
          decoration: const BoxDecoration(color: CupertinoColors.systemGreen),
          child: Stack(
            children: [
              Align(
                child: CupertinoTvSidebarFloatingHeader(
                  selectedItem: _buildItem(
                    title: SidebarSample.items[0].$1,
                    icon: SidebarSample.items[0].$2,
                    forceShow: true,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  TvNavigationItem _buildItem({
    required String title,
    required IconData icon,
    bool forceShow = false,
  }) {
    return TvNavigationItem(
      key: ValueKey(title),
      icon: _buildIcon(icon),
      decoration: _buildDecoration(),
      builder: (_, constraints, states) {
        return ConstrainedBox(
          constraints: constraints,
          child: Stack(
            children: [
              AnimatedOpacity(
                opacity: forceShow || controller.hasFocus ? 1 : 0,
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

  WidgetStateProperty<BoxDecoration> _buildDecoration() {
    return WidgetStateProperty.resolveWith((states) {
      if (states.containsAll([WidgetState.selected, WidgetState.focused])) {
        return const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: CupertinoColors.activeBlue,
        );
      }

      if (states.contains(WidgetState.selected)) {
        return const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: CupertinoColors.systemIndigo,
        );
      }

      if (states.contains(WidgetState.focused)) {
        return BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          color: CupertinoColors.systemTeal.withValues(alpha: 0.33),
        );
      }

      return const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      );
    });
  }

  WidgetStateProperty<Icon> _buildIcon(IconData data) {
    return WidgetStateProperty.resolveWith((states) {
      return Icon(data, size: 20, color: _buildContentColor(states));
    });
  }

  Color _buildContentColor(Set<WidgetState> states) => CupertinoColors.white;
}
