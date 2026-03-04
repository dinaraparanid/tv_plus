import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tv_plus_example/carousel/carousel_pager_sample.dart';
import 'package:tv_plus_example/carousel/scroll_carousel_pager_sample.dart';

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Carousel pager test', () {
    testWidgets('...', (tester) async {
      await tester.pumpWidget(const CarouselPagerSample());
      await tester.testScenario(
        initialSelectedIndex: CarouselPagerSample.initialSelectedIndex,
        contentKey: CarouselPagerSample.contentKey,
        pagerKey: CarouselPagerSample.pagerKey,
        items: CarouselPagerSample.items,
        selectedDotColor: CarouselPagerSample.selectedFocusedIndicatorColor,
        unselectedDotColor: CarouselPagerSample.unselectedIndicatorColor,
      );
    });
  });

  group('Scroll carousel pager test', () {
    testWidgets('...', (tester) async {
      await tester.pumpWidget(const ScrollCarouselPagerSample());
      await tester.testScenario(
        initialSelectedIndex: ScrollCarouselPagerSample.initialSelectedIndex,
        capacity: ScrollCarouselPagerSample.capacity,
        contentKey: ScrollCarouselPagerSample.contentKey,
        pagerKey: ScrollCarouselPagerSample.pagerKey,
        items: ScrollCarouselPagerSample.items,
        selectedDotColor:
            ScrollCarouselPagerSample.selectedFocusedIndicatorColor,
        unselectedDotColor: ScrollCarouselPagerSample.unselectedIndicatorColor,
      );
    });
  });
}

extension CarouselTest on WidgetTester {
  Future<void> testScenario({
    required int initialSelectedIndex,
    int? capacity,
    required Key contentKey,
    required Key pagerKey,
    required List<Color> items,
    required Color selectedDotColor,
    required Color unselectedDotColor,
  }) async {
    await pumpAndSettle();

    // Go to right until the end
    for (int i = initialSelectedIndex; i < items.length; ++i) {
      await testCarousel(
        selectedIndex: i,
        capacity: capacity,
        contentKey: contentKey,
        pagerKey: pagerKey,
        items: items,
        selectedDotColor: selectedDotColor,
        unselectedDotColor: unselectedDotColor,
      );

      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowRight);
    }

    // Go to left until the beginning
    for (int i = items.length - 1; i >= 0; --i) {
      await testCarousel(
        selectedIndex: i,
        capacity: capacity,
        contentKey: contentKey,
        pagerKey: pagerKey,
        items: items,
        selectedDotColor: selectedDotColor,
        unselectedDotColor: unselectedDotColor,
      );

      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowLeft);
    }
  }

  Future<void> testCarousel({
    required int selectedIndex,
    required int? capacity,
    required Key contentKey,
    required Key pagerKey,
    required List<Color> items,
    required Color selectedDotColor,
    required Color unselectedDotColor,
  }) async {
    final contentFinder = find.byKey(contentKey);
    expect(contentFinder, findsOneWidget);

    final content = firstWidget<AnimatedContainer>(contentFinder);
    final contentDecoration = content.decoration! as BoxDecoration;
    expect(contentDecoration.color, items[selectedIndex]);

    final pagerFinder = find.byKey(pagerKey);
    expect(pagerFinder, findsOneWidget);

    var visibleDots = 0;

    for (int i = 0; i < items.length; ++i) {
      final dotsFinder = find.descendant(
        of: pagerFinder,
        matching: find.byKey(ValueKey(i)),
      );

      if (dotsFinder.tryEvaluate()) {
        final dot = firstWidget<AnimatedContainer>(dotsFinder);
        visibleDots += dot.constraints!.minWidth > 0 ? 1 : 0;

        final dotDecoration = dot.decoration! as BoxDecoration;
        final isSelected = i == selectedIndex;

        expect(
          dotDecoration.color,
          isSelected ? selectedDotColor : unselectedDotColor,
        );
      }
    }

    expect(visibleDots, capacity ?? items.length);
  }
}
