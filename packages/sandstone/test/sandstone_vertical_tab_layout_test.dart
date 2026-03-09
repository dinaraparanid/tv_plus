import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_plus_foundation/tv_plus_foundation.dart';
import 'package:tv_plus_sandstone/src/example/navigation/sandstone_vertical_tab_layout_sample.dart';

import '../../foundation/test/utils.dart';

void main() {
  group('Sandstone vertical tab layout tests', () {
    testWidgets('...', (tester) async {
      await tester.pumpWidget(const SandstoneVerticalTabLayoutSample());
      await tester.testScenario();
    });
  });
}

extension VerticalTabLayoutTest on WidgetTester {
  Future<void> testScenario() async {
    testContent(focused: true, selectedIndex: 0);
    testDrawer(selectedIndex: 0, focusedIndex: 0, menuExpanded: false);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowLeft);
    testContent(focused: false, selectedIndex: 0);
    testDrawer(selectedIndex: 0, focusedIndex: 0, menuExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowDown);
    testContent(focused: false, selectedIndex: 0);
    testDrawer(selectedIndex: 0, focusedIndex: 1, menuExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowDown);
    testContent(focused: false, selectedIndex: 0);
    testDrawer(selectedIndex: 0, focusedIndex: 2, menuExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.select);
    testContent(focused: false, selectedIndex: 2);
    testDrawer(selectedIndex: 2, focusedIndex: 2, menuExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowRight);
    testContent(focused: true, selectedIndex: 2);
    testDrawer(selectedIndex: 2, focusedIndex: 2, menuExpanded: false);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowLeft);
    testContent(focused: false, selectedIndex: 2);
    testDrawer(selectedIndex: 2, focusedIndex: 2, menuExpanded: true);

    // nothing should change
    await sendDpadEventAndSettle(LogicalKeyboardKey.select);
    testContent(focused: false, selectedIndex: 2);
    testDrawer(selectedIndex: 2, focusedIndex: 2, menuExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowDown);
    testContent(focused: false, selectedIndex: 2);
    testDrawer(selectedIndex: 2, focusedIndex: 3, menuExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.select);
    testContent(focused: false, selectedIndex: 3);
    testDrawer(selectedIndex: 3, focusedIndex: 3, menuExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowRight);
    testContent(focused: true, selectedIndex: 3);
    testDrawer(selectedIndex: 3, focusedIndex: 3, menuExpanded: false);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowLeft);
    testContent(focused: false, selectedIndex: 3);
    testDrawer(selectedIndex: 3, focusedIndex: 3, menuExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowUp);
    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowUp);
    testContent(focused: false, selectedIndex: 3);
    testDrawer(selectedIndex: 3, focusedIndex: 1, menuExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.select);
    testContent(focused: false, selectedIndex: 1);
    testDrawer(selectedIndex: 1, focusedIndex: 1, menuExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowRight);
    testContent(focused: true, selectedIndex: 1);
    testDrawer(selectedIndex: 1, focusedIndex: 1, menuExpanded: false);
  }

  void testContent({required bool focused, required int selectedIndex}) {
    final contentFinder = find.byKey(
      SandstoneVerticalTabLayoutSample.contentKey,
    );

    final contentDpadFocus = firstWidget<DpadFocus>(contentFinder);
    expect(contentDpadFocus.autofocus, true);
    expect(contentDpadFocus.canRequestFocus, true);
    expect(contentDpadFocus.focusNode?.hasFocus, focused);

    final contentTextFinder = find.descendant(
      of: contentFinder,
      matching: find.byType(Text),
    );

    final contentText = firstWidget<Text>(contentTextFinder);

    final entry = ItemEntry(
      key: ValueKey(SandstoneVerticalTabLayoutSample.items[selectedIndex].$1),
    );

    expect(contentText.data, '$entry content');
  }

  void testDrawer({
    required int selectedIndex,
    required int focusedIndex,
    required bool menuExpanded,
  }) {
    for (int i = 0; i < SandstoneVerticalTabLayoutSample.items.length; ++i) {
      final (title, iconData) = SandstoneVerticalTabLayoutSample.items[i];

      final itemFinder = find.byKey(ValueKey(title));
      expect(itemFinder, findsOneWidget);

      final states = {
        if (i == selectedIndex) WidgetState.selected,
        if (i == focusedIndex && menuExpanded) WidgetState.focused,
      };

      // check decoration
      final containerFinder = find.descendant(
        of: itemFinder,
        matching: find.byType(Container),
      );

      final container = firstWidget<Container>(containerFinder);

      expect(
        container.decoration! as BoxDecoration,
        SandstoneVerticalTabLayoutSample.buildDecoration().resolve(states),
      );

      // check title
      final titleFinder = find.descendant(
        of: itemFinder,
        matching: find.byType(Text),
      );

      if (menuExpanded) {
        expect(titleFinder, findsOneWidget);

        final titleWidget = firstWidget<Text>(titleFinder);
        expect(titleWidget.data, title);
        expect(titleWidget.maxLines, 1);
        expect(
          titleWidget.style?.color,
          SandstoneVerticalTabLayoutSample.buildContentColor(states),
        );
      } else {
        expect(titleFinder, findsNothing);
      }
    }
  }
}
