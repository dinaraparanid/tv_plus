import 'package:flutter/material.dart';
import 'package:tv_plus/tv_plus.dart';

final class TvTabItemSample extends StatelessWidget {
  const TvTabItemSample({
    super.key,
    required this.index,
    required this.icon,
    required this.text,
    required this.color,
    required this.isSelected,
    required this.isTabBarFocused,
  });

  static const animationDuration = Duration(milliseconds: 300);

  final int index;
  final IconData icon;
  final String text;
  final Color color;
  final bool isSelected;
  final bool isTabBarFocused;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isSelected ? 1.2 : 1.0,
      duration: animationDuration,
      child: TvTab(
        autofocus: isSelected,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Icon(icon, color: color),
            Text(text, style: TextStyle(color: color, fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
