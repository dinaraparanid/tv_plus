part of 'carousel.dart';

final class TvCarouselController with ChangeNotifier {
  TvCarouselController({required int itemCount, int initialActiveIndex = 0})
    : assert(
        itemCount > 0 &&
            initialActiveIndex < itemCount &&
            initialActiveIndex >= 0,
      ),
      _itemCount = itemCount,
      _selectedIndex = initialActiveIndex;

  int _itemCount;
  int get itemCount => _itemCount;

  void reset({required int count, int? newSelectedIndex}) {
    if (newSelectedIndex != null) {
      if (newSelectedIndex >= count || newSelectedIndex < 0) {
        throw ArgumentError(
          "New selected index $newSelectedIndex is out of bounds [0; $count)",
        );
      }

      _selectedIndex = newSelectedIndex;
    } else if (selectedIndex >= count) {
      throw ArgumentError(
        "Current selected index $selectedIndex is out of new bounds $count, "
        "provide new selected index via 'newSelectedIndex' parameter",
      );
    }

    _itemCount = count;
    notifyListeners();
  }

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void select(int index) {
    if (index >= itemCount || index < 0) {
      throw ArgumentError("Index $index is out of bounds [0; $itemCount)");
    }

    _selectedIndex = index;
    notifyListeners();
  }

  bool get canScrollLeft => selectedIndex > 0;
  bool get canScrollRight => selectedIndex < itemCount - 1;

  void scrollLeft() => select(selectedIndex - 1);
  void scrollRight() => select(selectedIndex + 1);
}
