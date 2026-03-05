import 'package:flutter/widgets.dart';
import 'package:test/test.dart';
import 'package:tv_plus/tv_plus.dart';

void main() {
  group('Navigation menu controller tests', () {
    test('Select', () {
      final controller = TvNavigationMenuController(
        initialEntry: const ItemEntry(key: ValueKey(0)),
        itemsNodes: {
          const ValueKey(0): FocusNode(),
          const ValueKey(1): FocusNode(),
          const ValueKey(2): FocusNode(),
        },
      );

      controller.select(const ItemEntry(key: ValueKey(0)));
      expect(controller.selectedEntry, const ItemEntry(key: ValueKey(0)));

      controller.select(const ItemEntry(key: ValueKey(1)));
      expect(controller.selectedEntry, const ItemEntry(key: ValueKey(1)));

      controller.select(const ItemEntry(key: ValueKey(2)));
      expect(controller.selectedEntry, const ItemEntry(key: ValueKey(2)));

      // It is acceptable since itemsNodes can be updated later
      expect(
        () => controller.select(const ItemEntry(key: ValueKey(3))),
        returnsNormally,
      );
      expect(controller.selectedEntry, const ItemEntry(key: ValueKey(3)));
    });

    test('Invalidate', () {
      final controller = TvNavigationMenuController(
        initialEntry: const ItemEntry(key: ValueKey(0)),
        itemsNodes: {
          const ValueKey(0): FocusNode(),
          const ValueKey(1): FocusNode(),
          const ValueKey(2): FocusNode(),
        },
      );

      controller.invalidateItemsNodes(
        newItems: {
          const ValueKey(0): FocusNode(),
          const ValueKey(1): FocusNode(),
          const ValueKey(2): FocusNode(),
          const ValueKey(3): FocusNode(),
        },
        onSelectedItemRemoved: () => throw AssertionError('Must not be called'),
      );

      expect(controller.selectedEntry, const ItemEntry(key: ValueKey(0)));

      controller.invalidateItemsNodes(
        newItems: {
          const ValueKey(0): FocusNode(),
          const ValueKey(1): FocusNode(),
        },
        onSelectedItemRemoved: () => throw AssertionError('Must not be called'),
      );

      expect(controller.selectedEntry, const ItemEntry(key: ValueKey(0)));

      controller.invalidateItemsNodes(
        newItems: {
          const ValueKey(2): FocusNode(),
          const ValueKey(3): FocusNode(),
        },
        onSelectedItemRemoved: () => const ItemEntry(key: ValueKey(2)),
      );

      expect(controller.selectedEntry, const ItemEntry(key: ValueKey(2)));
    });
  });
}
