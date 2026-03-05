import 'package:test/test.dart';
import 'package:tv_plus/tv_plus.dart';

void main() {
  group('Carousel controller tests', () {
    test('Create', () {
      expect(
        () => TvCarouselController(itemCount: 0),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Item count must be > 0',
          ),
        ),
      );

      expect(
        () => TvCarouselController(itemCount: -1),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Item count must be > 0',
          ),
        ),
      );

      expect(
        () => TvCarouselController(itemCount: 10, initialActiveIndex: -1),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Initial index is out of bounds: [0, 10)',
          ),
        ),
      );

      expect(
        () => TvCarouselController(itemCount: 10, initialActiveIndex: 10),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Initial index is out of bounds: [0, 10)',
          ),
        ),
      );

      expect(
        () => TvCarouselController(itemCount: 10, initialActiveIndex: 2),
        returnsNormally,
      );
    });

    test('Reset', () {
      final controller = TvCarouselController(
        itemCount: 10,
        initialActiveIndex: 5,
      );

      expect(controller.itemCount, 10);
      expect(controller.selectedIndex, 5);

      expect(
        () => controller.reset(count: 0),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Item count must be > 0',
          ),
        ),
      );

      expect(
        () => controller.reset(count: -1),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Item count must be > 0',
          ),
        ),
      );

      expect(
        () => controller.reset(count: 5, newSelectedIndex: 5),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'New selected index 5 is out of bounds [0; 5)',
          ),
        ),
      );

      expect(
        () => controller.reset(count: 5, newSelectedIndex: -1),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'New selected index -1 is out of bounds [0; 5)',
          ),
        ),
      );

      expect(
        () => controller.reset(count: 5),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Current selected index 5 is out of new bounds [0; 5), '
                "provide new selected index via 'newSelectedIndex' parameter",
          ),
        ),
      );

      expect(() => controller.reset(count: 7), returnsNormally);
      expect(controller.itemCount, 7);
      expect(controller.selectedIndex, 5);

      expect(
        () => controller.reset(count: 5, newSelectedIndex: 0),
        returnsNormally,
      );

      expect(controller.itemCount, 5);
      expect(controller.selectedIndex, 0);
    });

    test('Select', () {
      final controller = TvCarouselController(
        itemCount: 10,
        initialActiveIndex: 5,
      );

      expect(controller.itemCount, 10);
      expect(controller.selectedIndex, 5);

      expect(
        () => controller.select(10),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Index 10 is out of bounds [0; 10)',
          ),
        ),
      );

      expect(
        () => controller.select(-1),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Index -1 is out of bounds [0; 10)',
          ),
        ),
      );

      expect(() => controller.select(0), returnsNormally);
      expect(controller.selectedIndex, 0);

      expect(() => controller.select(2), returnsNormally);
      expect(controller.selectedIndex, 2);
    });

    test('Scroll', () {
      final controller = TvCarouselController(itemCount: 3);
      expect(controller.itemCount, 3);
      expect(controller.selectedIndex, 0);

      expect(controller.canScrollLeft, false);
      expect(
        controller.scrollLeft,
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Index -1 is out of bounds [0; 3)',
          ),
        ),
      );
      expect(controller.itemCount, 3);
      expect(controller.selectedIndex, 0);

      expect(controller.canScrollRight, true);
      expect(controller.scrollRight, returnsNormally);
      expect(controller.itemCount, 3);
      expect(controller.selectedIndex, 1);

      expect(controller.canScrollRight, true);
      expect(controller.scrollRight, returnsNormally);
      expect(controller.itemCount, 3);
      expect(controller.selectedIndex, 2);

      expect(controller.canScrollRight, false);
      expect(
        controller.scrollRight,
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Index 3 is out of bounds [0; 3)',
          ),
        ),
      );
      expect(controller.itemCount, 3);
      expect(controller.selectedIndex, 2);

      expect(controller.canScrollLeft, true);
      expect(controller.scrollLeft, returnsNormally);
      expect(controller.itemCount, 3);
      expect(controller.selectedIndex, 1);

      expect(controller.canScrollLeft, true);
      expect(controller.scrollLeft, returnsNormally);
      expect(controller.itemCount, 3);
      expect(controller.selectedIndex, 0);
      expect(controller.canScrollLeft, false);
    });
  });
}
