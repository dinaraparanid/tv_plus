import 'package:flutter/material.dart';
import 'package:tv_plus/material/navigation/selection_entry.dart';
import 'package:tv_plus/tv_plus.dart';

final class NavigationDrawerSample extends StatefulWidget {
  const NavigationDrawerSample({super.key});

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

  static const _animationDuration = Duration(milliseconds: 300);
  static const _initialEntry = ItemEntry(index: 0);

  final controller = TvNavigationDrawerController(
    initialEntry: ItemEntry(index: 0),
    itemCount: NavigationDrawerSample.items.length,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TvNavigationDrawer(
      controller: controller,
      drawerExpandDuration: _animationDuration,
      drawerDecoration: BoxDecoration(
        color: Color(0xFF444746),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      headerBuilder: _buildHeader,
      footerBuilder: _buildFooter,
      itemCount: 5,
      separatorBuilder: (_) => SizedBox(height: 12),
      itemBuilder: (index) {
        return _buildItem(
          node: controller.itemsFocusNodes[index],
          title: NavigationDrawerSample.items[index].$1,
          icon: NavigationDrawerSample.items[index].$2,
        );
      },
      initialEntry: _initialEntry,
      builder: (context, entry, focusNode) {
        return Stack(
          children: [
            Align(
              child: DpadFocus(
                focusNode: focusNode,
                autofocus: true,
                onLeft: (_, _) {
                  controller.selectedNode.requestFocus();
                  return KeyEventResult.handled;
                },
                builder: (node) {
                  return AnimatedContainer(
                    duration: _animationDuration,
                    color: node.hasFocus ? Colors.green : Colors.indigoAccent,
                    width: 300,
                    height: 300,
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
  }

  WidgetStateProperty<BoxDecoration> _buildDecoration() {
    return WidgetStateProperty.resolveWith((states) {
      if (states.containsAll([WidgetState.selected, WidgetState.focused])) {
        return BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: Colors.deepPurpleAccent,
        );
      }

      if (states.contains(WidgetState.selected)) {
        return BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: Colors.indigoAccent,
        );
      }

      if (states.contains(WidgetState.focused)) {
        return BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: Colors.teal.withValues(alpha: 0.33),
        );
      }

      return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      );
    });
  }

  TvNavigationItem _buildHeader() {
    return TvNavigationItem(
      icon: Icons.account_circle,
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
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Switch account',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  TvNavigationItem _buildItem({
    required FocusNode node,
    required String title,
    required IconData icon,
  }) {
    return TvNavigationItem(
      icon: icon,
      decoration: _buildDecoration(),
      builder: (_, constraints, states) {
        return ConstrainedBox(
          constraints: constraints,
          child: Stack(
            children: [
              AnimatedOpacity(
                opacity: controller.hasFocus ? 1 : 0,
                duration: _animationDuration,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
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

  TvNavigationItem _buildFooter() {
    return _buildItem(
      node: controller.footerFocusNode,
      title: 'Settings',
      icon: Icons.settings,
    );
  }
}
