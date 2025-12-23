import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tv_plus/tv_plus.dart';
import 'package:tv_plus_example/scroll/sliver_tv_list_sample.dart';

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Sliver List tests', () {
    testWidgets('...', (tester) async {
      await tester.pumpWidget(const SliverTvListSample());
      await tester.testScenario();
    });
  });
}

extension ListTest on WidgetTester {
  Future<void> testScenario() async {
    // Wait for selection decoration to appear
    await pumpAndSettle();
    await testList(focusedIndex: 0);
    await testGoToLastButton(isFocused: false);

    // Go to last item button check
    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowUp);
    await testList();
    await testGoToLastButton(isFocused: true);
    await sendDpadEventAndSettle(LogicalKeyboardKey.select);
    await pumpAndSettle();
    await testList(focusedIndex: SliverTvListSample.itemCount - 1);
    await testGoToFirstButton(isFocused: false);

    // Go to first item button check
    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowDown);
    await testList();
    await testGoToFirstButton(isFocused: true);
    await sendDpadEventAndSettle(LogicalKeyboardKey.select);
    await pumpAndSettle();
    await testList(focusedIndex: 0);
    await testGoToLastButton(isFocused: false);

    // Go to bottom until end
    for (int i = 0; i < SliverTvListSample.itemCount; ++i) {
      await testList(focusedIndex: i);
      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowDown);
    }

    await testList();
    await testGoToFirstButton(isFocused: true);

    // Go to top
    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowUp);

    for (int i = 0; i < SliverTvListSample.itemCount; ++i) {
      await testList(focusedIndex: SliverTvListSample.itemCount - i - 1);
      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowUp);
    }

    await testGoToLastButton(isFocused: true);
  }

  Future<void> testList({int? focusedIndex}) async {
    final listFinder = find.byKey(SliverTvListSample.listKey);
    expect(listFinder, findsOneWidget);

    final itemsFinder = find.descendant(
      of: listFinder,
      matching: find.byType(TvListItem),
    );

    for (final (i, element) in itemsFinder.evaluate().indexed) {
      final item = element.widget as TvListItem;
      final index = item.index;

      final itemScrollFocusFinder = find.descendant(
        of: listFinder,
        matching: find.byKey(
          ValueKey(SliverTvListSample.buildItemName(index: index)),
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
        expect(decoration.color, SliverTvListSample.focusedColor);
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
      expect(text.data, SliverTvListSample.buildItemName(index: index));
    }
  }

  Future<void> testGoToLastButton({required bool isFocused}) async {
    final buttonFinder = find.byKey(SliverTvListSample.goToLastButtonKey);
    expect(buttonFinder, findsOneWidget);

    final button = firstWidget<TvListButtonItem>(buttonFinder);

    final containerFinder = find.descendant(
      of: buttonFinder,
      matching: find.byType(Container),
    );

    expect(containerFinder, findsOneWidget);

    final container = firstWidget<Container>(containerFinder);
    final decoration = container.decoration! as BoxDecoration;

    if (isFocused) {
      expect(decoration.color, SliverTvListSample.focusedColor);
      expect(button.node.hasFocus, true);
    } else {
      expect(decoration.color, Colors.transparent);
      expect(button.node.hasFocus, false);
    }
  }

  Future<void> testGoToFirstButton({required bool isFocused}) async {
    final buttonFinder = find.byKey(SliverTvListSample.goToFirstButtonKey);
    expect(buttonFinder, findsOneWidget);

    final button = firstWidget<TvListButtonItem>(buttonFinder);

    final containerFinder = find.descendant(
      of: buttonFinder,
      matching: find.byType(Container),
    );

    expect(containerFinder, findsOneWidget);

    final container = firstWidget<Container>(containerFinder);
    final decoration = container.decoration! as BoxDecoration;

    if (isFocused) {
      expect(decoration.color, SliverTvListSample.focusedColor);
      expect(button.node.hasFocus, true);
    } else {
      expect(decoration.color, Colors.transparent);
      expect(button.node.hasFocus, false);
    }
  }
}
