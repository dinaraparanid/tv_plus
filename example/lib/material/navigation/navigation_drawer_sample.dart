import 'package:flutter/material.dart';
import 'package:tv_plus/tv_plus.dart';

final class NavigationDrawerSample extends StatelessWidget {
  const NavigationDrawerSample({super.key});

  static const _animationDuration = Duration(milliseconds: 300);

  static const _items = [
    ('BOB, I want all my Garmonbozia', Icons.search),
    ('Home', Icons.home),
    ('Movies', Icons.movie),
    ('Shows', Icons.tv),
    ('Library', Icons.video_library),
  ];

  @override
  Widget build(BuildContext context) {
    return TvNavigationDrawer(
      drawerExpandDuration: _animationDuration,
      drawerDecoration: BoxDecoration(
        color: Color(0xFF444746),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        )
      ),
      headerBuilder: _buildHeader,
      footerBuilder: _buildFooter,
      itemCount: 5,
      separatorBuilder: (_, _, _) => SizedBox(height: 12),
      itemBuilder: (node, index, isSelected) {
        return _buildItem(
          node: node,
          title: _items[index].$1,
          icon: _items[index].$2,
          isSelected: isSelected,
        );
      },
      initialItemIndex: 0,
      builder: (context, index, node, drawerNode) {
        return Stack(
          children: [
            Align(
              child: DpadFocus(
                focusNode: node,
                autofocus: true,
                onLeft: (_, _) {
                  drawerNode.requestFocus();
                  return KeyEventResult.handled;
                },
                builder: (node) {
                  return AnimatedContainer(
                    duration: _animationDuration,
                    color: node.hasFocus ? Colors.green : Colors.indigoAccent,
                    width: 300,
                    height: 300,
                    alignment: Alignment.center,
                    child: Text('Item ${index + 1} content'),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  TvNavigationItem _buildHeader(FocusNode node) {
    return TvNavigationItem(
      icon: Icons.account_circle,
      decoration: WidgetStateProperty.fromMap({
        WidgetState.selected: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: Colors.indigoAccent,
        ),
        WidgetState.focused: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: Colors.teal.withValues(alpha: 0.33),
        ),
        WidgetState.any: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: Colors.transparent,
        ),
      }),
      builder: (_, constraints, states, isDrawerExpanded) {
        return ConstrainedBox(
          constraints: constraints,
          child: AnimatedOpacity(
            opacity: isDrawerExpanded ? 1 : 0,
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
    bool isSelected = false,
}) {
    return TvNavigationItem(
      isSelected: isSelected,
      icon: icon,
      decoration: WidgetStateProperty.resolveWith((states) {
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
      }),
      builder: (_, constraints, states, isDrawerExpanded) {
        return ConstrainedBox(
          constraints: constraints,
          child: Stack(
            children: [
              AnimatedOpacity(
                opacity: isDrawerExpanded ? 1 : 0,
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

  TvNavigationItem _buildFooter(FocusNode node) {
    return _buildItem(node: node, title: 'Settings', icon: Icons.settings);
  }
}
