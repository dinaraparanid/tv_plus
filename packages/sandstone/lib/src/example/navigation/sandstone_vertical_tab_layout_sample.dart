import 'package:flutter/material.dart';
import 'package:tv_plus_foundation/tv_plus_foundation.dart';
import 'package:tv_plus_sandstone/src/navigation/tab/tab.dart';

const _animationDuration = Duration(milliseconds: 350);

final class SandstoneVerticalTabLayoutSample extends StatefulWidget {
  const SandstoneVerticalTabLayoutSample({super.key});

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
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: Colors.deepPurpleAccent,
        );
      }

      if (states.contains(WidgetState.selected)) {
        return const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: Colors.indigoAccent,
        );
      }

      if (states.contains(WidgetState.focused)) {
        return BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: Colors.teal.withValues(alpha: 0.33),
        );
      }

      return const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      );
    });
  }

  static SandstoneVerticalTab buildTab({
    required String title,
    required IconData icon,
  }) {
    return SandstoneVerticalTab(
      key: ValueKey(title),
      iconBuilder: (_) => SandstoneVerticalTabLayoutSample.buildIcon(icon),
      builder: (context, states, isExpanded, icon) {
        return Container(
          decoration: SandstoneVerticalTabLayoutSample.buildDecoration()
              .resolve(states),
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              if (icon != null) icon,

              if (isExpanded)
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: SandstoneVerticalTabLayoutSample.buildContentColor(
                      states,
                    ),
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
  State<StatefulWidget> createState() =>
      _SandstoneVerticalTabLayoutSampleState();
}

final class _SandstoneVerticalTabLayoutSampleState
    extends State<SandstoneVerticalTabLayoutSample> {
  final _items = SandstoneVerticalTabLayoutSample.items.toList();

  late final _controller = TvNavigationMenuController(
    initialEntry: ItemEntry(
      key: ValueKey(SandstoneVerticalTabLayoutSample.items[0].$1),
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
        return SandstoneVerticalTabLayout(
          controller: _controller,
          backgroundColor: SandstoneVerticalTabLayoutSample.backgroundColor,
          drawerExpandDuration: _animationDuration,
          separatorBuilder: (i, isExpanded) => const SizedBox(height: 12),
          tabs: _items.map((item) {
            return SandstoneVerticalTabLayoutSample.buildTab(
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
          tabsBuilder: (context, _, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
              child: child,
            );
          },
          builder: (context, isExpanded, entry) {
            return Stack(
              children: [
                Align(
                  child: DpadFocus(
                    focusNode: _contentFocusNode,
                    key: SandstoneVerticalTabLayoutSample.contentKey,
                    autofocus: true,
                    onLeft: (_, _) {
                      _controller.requestFocusOnMenu();
                      return KeyEventResult.handled;
                    },
                    builder: (context, node) {
                      return AnimatedContainer(
                        duration: _animationDuration,
                        color: isExpanded ? Colors.green : Colors.indigoAccent,
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
}
