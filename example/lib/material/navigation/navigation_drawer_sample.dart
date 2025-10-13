import 'package:flutter/material.dart';
import 'package:tv_plus/tv_plus.dart';

final class NavigationDrawerSample extends StatelessWidget {
  const NavigationDrawerSample({super.key});

  @override
  Widget build(BuildContext context) {
    return TvNavigationDrawer(
      drawerDecoration: BoxDecoration(
        color: Color(0xFF444746),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        )
      ),
      header: _buildHeader(),
      footer: _buildFooter(),
      items: [
        _buildItem(title: 'Search', icon: Icons.search),
        _buildItem(title: 'Home', icon: Icons.home),
        _buildItem(title: 'Movies', icon: Icons.movie),
        _buildItem(title: 'Shows', icon: Icons.tv),
        _buildItem(title: 'Library', icon: Icons.video_library),
      ],
      initialItemIndex: 0,
      builder: (context, index) {
        return Container(
          color: Colors.green,
          child: Text('Item ${index + 1} content'),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      spacing: 12,
      children: [
        Icon(
          Icons.account_circle,
          size: 32,
        ),

        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Switch account',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItem({
    required String title,
    required IconData icon,
}) {
    return Row(
      spacing: 12,
      children: [
        Icon(icon, size: 24),

        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return _buildItem(title: 'Settings', icon: Icons.settings);
  }
}
