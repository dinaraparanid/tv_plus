import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tv_plus/tv_plus.dart';
import 'package:tv_plus_example/scroll/sliver_tv_grid_sample.dart';

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Sliver Grid tests', () {
    testWidgets('...', (tester) async {
      await tester.pumpWidget(const SliverTvGridSample());
      await tester.testScenario();
    });
  });
}

extension SliverGridTest on WidgetTester {
  Future<void> testScenario() async {
    // Wait for selection decoration to appear
    await pumpAndSettle();

    await testGrid();
    await testButton(key: SliverTvGridSample.upButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.downButtonKey, isVisible: false);
    await testButton(key: SliverTvGridSample.leftButtonKey, isFocused: true);
    await testButton(key: SliverTvGridSample.rightButtonKey, isFocused: false);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowRight);
    await testGrid(focusedIndex: 0);
    await testButton(key: SliverTvGridSample.upButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.downButtonKey, isVisible: false);
    await testButton(key: SliverTvGridSample.leftButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.rightButtonKey, isFocused: false);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowUp);
    await testGrid();
    await testButton(key: SliverTvGridSample.upButtonKey, isFocused: true);
    await testButton(key: SliverTvGridSample.downButtonKey, isVisible: false);
    await testButton(key: SliverTvGridSample.leftButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.rightButtonKey, isFocused: false);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowDown);
    await testGrid(focusedIndex: 0); // returned to previous position
    await testButton(key: SliverTvGridSample.upButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.downButtonKey, isVisible: false);
    await testButton(key: SliverTvGridSample.leftButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.rightButtonKey, isFocused: false);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowRight);
    await testGrid(focusedIndex: 1);
    await testButton(key: SliverTvGridSample.upButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.downButtonKey, isVisible: false);
    await testButton(key: SliverTvGridSample.leftButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.rightButtonKey, isFocused: false);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowRight);
    await testGrid(focusedIndex: 2);
    await testButton(key: SliverTvGridSample.upButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.downButtonKey, isVisible: false);
    await testButton(key: SliverTvGridSample.leftButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.rightButtonKey, isFocused: false);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowRight);
    await testGrid();
    await testButton(key: SliverTvGridSample.upButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.downButtonKey, isVisible: false);
    await testButton(key: SliverTvGridSample.leftButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.rightButtonKey, isFocused: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowLeft);
    await testGrid(focusedIndex: 2);
    await testButton(key: SliverTvGridSample.upButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.downButtonKey, isVisible: false);
    await testButton(key: SliverTvGridSample.leftButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.rightButtonKey, isFocused: false);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowLeft);
    await testGrid(focusedIndex: 1);
    await testButton(key: SliverTvGridSample.upButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.downButtonKey, isVisible: false);
    await testButton(key: SliverTvGridSample.leftButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.rightButtonKey, isFocused: false);

    const rows = SliverTvGridSample.itemCount ~/ 3;

    for (var i = 1; i <= rows; ++i) {
      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowDown);
      await testGrid(focusedIndex: 1 + i * 3);
      await testButton(key: SliverTvGridSample.leftButtonKey, isFocused: false);
      await testButton(
        key: SliverTvGridSample.rightButtonKey,
        isFocused: false,
      );
    }

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowDown);
    await testGrid();
    await testButton(key: SliverTvGridSample.upButtonKey, isVisible: false);
    await testButton(key: SliverTvGridSample.downButtonKey, isFocused: true);
    await testButton(key: SliverTvGridSample.leftButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.rightButtonKey, isFocused: false);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowUp);
    await testGrid(focusedIndex: 49);
    await testButton(key: SliverTvGridSample.upButtonKey, isVisible: false);
    await testButton(key: SliverTvGridSample.downButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.leftButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.rightButtonKey, isFocused: false);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowRight);
    await testGrid(focusedIndex: 47);
    await testButton(key: SliverTvGridSample.upButtonKey, isVisible: false);
    await testButton(key: SliverTvGridSample.downButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.leftButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.rightButtonKey, isFocused: false);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowRight);
    await testGrid();
    await testButton(key: SliverTvGridSample.upButtonKey, isVisible: false);
    await testButton(key: SliverTvGridSample.downButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.leftButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.rightButtonKey, isFocused: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowLeft);
    await testGrid(focusedIndex: 47);
    await testButton(key: SliverTvGridSample.upButtonKey, isVisible: false);
    await testButton(key: SliverTvGridSample.downButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.leftButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.rightButtonKey, isFocused: false);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowLeft);
    await testGrid(focusedIndex: 49);
    await testButton(key: SliverTvGridSample.upButtonKey, isVisible: false);
    await testButton(key: SliverTvGridSample.downButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.leftButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.rightButtonKey, isFocused: false);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowLeft);
    await testGrid(focusedIndex: 48);
    await testButton(key: SliverTvGridSample.upButtonKey, isVisible: false);
    await testButton(key: SliverTvGridSample.downButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.leftButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.rightButtonKey, isFocused: false);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowLeft);
    await testGrid();
    await testButton(key: SliverTvGridSample.upButtonKey, isVisible: false);
    await testButton(key: SliverTvGridSample.downButtonKey, isFocused: false);
    await testButton(key: SliverTvGridSample.leftButtonKey, isFocused: true);
    await testButton(key: SliverTvGridSample.rightButtonKey, isFocused: false);
  }

  Future<void> testGrid({int? focusedIndex}) async {
    final listFinder = find.byKey(SliverTvGridSample.gridKey);
    expect(listFinder, findsOneWidget);

    final itemsFinder = find.descendant(
      of: listFinder,
      matching: find.byType(TvGridItem),
    );

    for (final (i, element) in itemsFinder.evaluate().indexed) {
      final item = element.widget as TvGridItem;
      final index = item.index;

      final itemScrollFocusFinder = find.descendant(
        of: listFinder,
        matching: find.byKey(
          ValueKey(SliverTvGridSample.buildItemName(index: index)),
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
        expect(decoration.color, SliverTvGridSample.focusedColor);
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
      expect(text.data, SliverTvGridSample.buildItemName(index: index));
    }
  }

  Future<void> testButton({
    required GlobalKey key,
    bool? isFocused,
    bool isVisible = true,
  }) async {
    final buttonFinder = find.byKey(key);

    if (isFocused == null || !isVisible) {
      expect(buttonFinder, findsNothing);
      return;
    }

    expect(buttonFinder, findsOneWidget);

    final button = firstWidget<TvGridButtonItem>(buttonFinder);

    final containerFinder = find.descendant(
      of: buttonFinder,
      matching: find.byType(Container),
    );

    expect(containerFinder, findsOneWidget);

    final container = firstWidget<Container>(containerFinder);
    final decoration = container.decoration! as BoxDecoration;

    if (isFocused) {
      expect(decoration.color, SliverTvGridSample.focusedColor);
      expect(button.node.hasFocus, true);
    } else {
      expect(decoration.color, Colors.transparent);
      expect(button.node.hasFocus, false);
    }
  }
}
