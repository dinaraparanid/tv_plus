part of 'carousel.dart';

final class TvCarouselController with ChangeNotifier {
  TvCarouselController({required int itemCount, int initialActiveIndex = 0})
    : _itemCount = itemCount,
      _selectedIndex = initialActiveIndex {
    if (itemCount <= 0) {
      throw ArgumentError.value(itemCount, 'itemCount', 'must be > 0');
    }

    if (initialActiveIndex < 0 || initialActiveIndex >= itemCount) {
      throw ArgumentError.value(
        initialActiveIndex,
        'initialActiveIndex',
        'must be in range [0, $itemCount)',
      );
    }
  }

  int _itemCount;
  int get itemCount => _itemCount;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  bool get canScrollLeft => selectedIndex > 0;
  bool get canScrollRight => selectedIndex < itemCount - 1;

  void reset({required int count, int? newSelectedIndex}) {
    if (count <= 0) {
      throw ArgumentError.value(count, 'count', 'must be > 0');
    }

    if (newSelectedIndex != null) {
      if (newSelectedIndex >= count || newSelectedIndex < 0) {
        throw ArgumentError.value(
          newSelectedIndex,
          'newSelectedIndex',
          'must be in range [0, $count)',
        );
      }

      _selectedIndex = newSelectedIndex;
    } else if (selectedIndex >= count) {
      throw ArgumentError(
        'Current selected index $selectedIndex is out of new bounds [0; $count)'
        ", provide new selected index via 'newSelectedIndex' parameter",
      );
    }

    _itemCount = count;
    notifyListeners();
  }

  void select(int index) {
    if (index == _selectedIndex) {
      return;
    }

    if (index >= itemCount || index < 0) {
      throw ArgumentError.value(
        index,
        'index',
        'must be in range [0, $itemCount)',
      );
    }

    _selectedIndex = index;
    notifyListeners();
  }

  void scrollLeft() => select(selectedIndex - 1);
  void scrollRight() => select(selectedIndex + 1);
}
