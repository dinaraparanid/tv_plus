part of 'tab.dart';

final class TvTabBarController with ChangeNotifier {
  TvTabBarController({int initialIndex = 0}) : _selectedIndex = initialIndex {
    if (initialIndex < 0) {
      throw ArgumentError.value(initialIndex, 'initialIndex', 'must be >= 0');
    }
  }

  int _selectedIndex;
  int get selectedIndex => _selectedIndex;

  void select(int index) {
    if (index == _selectedIndex) {
      return;
    }

    if (index < 0) {
      throw ArgumentError.value(index, 'index', 'must be >= 0');
    }

    _selectedIndex = index;
    notifyListeners();
  }
}
