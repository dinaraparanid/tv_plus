import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tv_plus/tv_plus.dart';
import 'package:tv_plus_example/scroll/tv_list_view_sample.dart';

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('List tests', () {
    testWidgets('...', (tester) async {
      await tester.pumpWidget(const TvListViewSample());
      await tester.testScenario();
    });
  });
}

extension ListTest on WidgetTester {
  Future<void> testScenario() async {
    // Go to right until end
    await pumpAndSettle();

    for (int i = 0; i < TvListViewSample.itemCount; ++i) {
      await checkHorizontalList(focusedIndex: i);
      await checkVerticalList();
      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowRight);
    }

    // Go to left until middle
    await pumpAndSettle();

    for (int i = 0; i < TvListViewSample.itemCount ~/ 2; ++i) {
      await checkHorizontalList(
        focusedIndex: TvListViewSample.itemCount - i - 1,
      );
      await checkVerticalList();
      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowLeft);
    }

    // Go to bottom until end
    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowDown);

    for (int i = 0; i < TvListViewSample.itemCount; ++i) {
      await checkHorizontalList();
      await checkVerticalList(focusedIndex: i);
      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowDown);
    }

    // Go to top until horizontal list reached
    await pumpAndSettle();

    for (int i = 0; i < TvListViewSample.itemCount; ++i) {
      await checkHorizontalList();
      await checkVerticalList(focusedIndex: TvListViewSample.itemCount - i - 1);
      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowUp);
    }
  }

  Future<void> checkHorizontalList({int? focusedIndex}) async {
    final horizontalListFinder = find.byKey(TvListViewSample.horizontalListKey);
    expect(horizontalListFinder, findsOneWidget);

    final horizontalList = firstWidget<TvListView>(horizontalListFinder);
    expect(horizontalList.scrollDirection, Axis.horizontal);

    final itemsFinder = find.descendant(
      of: horizontalListFinder,
      matching: find.byType(TvListItem),
    );

    for (final (i, element) in itemsFinder.evaluate().indexed) {
      final item = element.widget as TvListItem;
      final index = item.index;

      final itemScrollFocusFinder = find.descendant(
        of: horizontalListFinder,
        matching: find.byKey(
          ValueKey(TvListViewSample.buildItemName(index: index)),
        ),
      );

      final itemScrollFocus = firstWidget<ScrollGroupDpadFocus>(
        itemScrollFocusFinder,
      );
      expect(itemScrollFocus.viewportAlignment, 0.0);

      final itemFinder = itemsFinder.at(i);

      final containerFinder = find.descendant(
        of: itemFinder,
        matching: find.byType(Container),
      );

      expect(containerFinder, findsOneWidget);

      final container = firstWidget<Container>(containerFinder);
      final decoration = container.decoration! as BoxDecoration;

      if (focusedIndex == index) {
        expect(decoration.color, TvListViewSample.focusedColor);
        expect(item.node.hasFocus, true);
      } else {
        expect(decoration.color, Colors.transparent);
        expect(item.node.hasFocus, false);
      }

      final textFinder = find.descendant(
        of: containerFinder,
        matching: find.byType(Text),
      );

      expect(textFinder, findsOneWidget);

      final text = firstWidget<Text>(textFinder);
      expect(text.data, TvListViewSample.buildItemName(index: index));
    }
  }

  Future<void> checkVerticalList({int? focusedIndex}) async {
    final verticalListFinder = find.byKey(TvListViewSample.verticalListKey);
    expect(verticalListFinder, findsOneWidget);

    final horizontalList = firstWidget<TvListView>(verticalListFinder);
    expect(horizontalList.scrollDirection, Axis.vertical);

    final itemsFinder = find.descendant(
      of: verticalListFinder,
      matching: find.byType(TvListItem),
    );

    for (final (i, element) in itemsFinder.evaluate().indexed) {
      final item = element.widget as TvListItem;
      final index = item.index;

      final itemScrollFocusFinder = find.descendant(
        of: verticalListFinder,
        matching: find.byKey(
          ValueKey(TvListViewSample.buildItemName(index: index)),
        ),
      );

      final itemScrollFocus = firstWidget<ScrollGroupDpadFocus>(
        itemScrollFocusFinder,
      );
      expect(itemScrollFocus.viewportAlignment, 0.5);

      final itemFinder = itemsFinder.at(i);

      final containerFinder = find.descendant(
        of: itemFinder,
        matching: find.byType(Container),
      );

      expect(containerFinder, findsOneWidget);

      final container = firstWidget<Container>(containerFinder);
      final decoration = container.decoration! as BoxDecoration;

      if (focusedIndex == index) {
        expect(decoration.color, TvListViewSample.focusedColor);
        expect(item.node.hasFocus, true);
      } else {
        expect(decoration.color, Colors.transparent);
        expect(item.node.hasFocus, false);
      }

      final textFinder = find.descendant(
        of: containerFinder,
        matching: find.byType(Text),
      );

      expect(textFinder, findsOneWidget);

      final text = firstWidget<Text>(textFinder);
      expect(text.data, TvListViewSample.buildItemName(index: index));
    }
  }
}
