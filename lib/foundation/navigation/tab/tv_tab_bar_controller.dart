import 'package:flutter/widgets.dart';

final class TvTabBarController extends ChangeNotifier {
  TvTabBarController({int initialIndex = 0}) : _selectedIndex = initialIndex;

  int _selectedIndex;
  int get selectedIndex => _selectedIndex;

  void select(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
