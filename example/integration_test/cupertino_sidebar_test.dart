import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tv_plus/tv_plus.dart';
import 'package:tv_plus_example/cupertino/navigation/sidebar_sample.dart';

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Cupertino Sidebar tests', () {
    testWidgets('Standard', (tester) async {
      await tester.pumpWidget(const CupertinoSidebarSample());
      await tester.testScenario();
    });
  });
}

extension SidebarTest on WidgetTester {
  Future<void> testScenario() async {
    testContent(focused: true, selectedIndex: 0);
    testSidebar(selectedIndex: 0, focusedIndex: 0, sidebarExpanded: false);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowLeft);
    testContent(focused: false, selectedIndex: 0);
    testSidebar(selectedIndex: 0, focusedIndex: 0, sidebarExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowDown);
    testContent(focused: false, selectedIndex: 0);
    testSidebar(selectedIndex: 0, focusedIndex: 1, sidebarExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowDown);
    testContent(focused: false, selectedIndex: 0);
    testSidebar(selectedIndex: 0, focusedIndex: 2, sidebarExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.select);
    testContent(focused: false, selectedIndex: 2);
    testSidebar(selectedIndex: 2, focusedIndex: 2, sidebarExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowRight);
    testContent(focused: true, selectedIndex: 2);
    testSidebar(selectedIndex: 2, focusedIndex: 2, sidebarExpanded: false);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowLeft);
    testContent(focused: false, selectedIndex: 2);
    testSidebar(selectedIndex: 2, focusedIndex: 2, sidebarExpanded: true);

    // nothing should change
    await sendDpadEventAndSettle(LogicalKeyboardKey.select);
    testContent(focused: false, selectedIndex: 2);
    testSidebar(selectedIndex: 2, focusedIndex: 2, sidebarExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowDown);
    testContent(focused: false, selectedIndex: 2);
    testSidebar(selectedIndex: 2, focusedIndex: 3, sidebarExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.select);
    testContent(focused: false, selectedIndex: 3);
    testSidebar(selectedIndex: 3, focusedIndex: 3, sidebarExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowRight);
    testContent(focused: true, selectedIndex: 3);
    testSidebar(selectedIndex: 3, focusedIndex: 3, sidebarExpanded: false);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowLeft);
    testContent(focused: false, selectedIndex: 3);
    testSidebar(selectedIndex: 3, focusedIndex: 3, sidebarExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowUp);
    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowUp);
    testContent(focused: false, selectedIndex: 3);
    testSidebar(selectedIndex: 3, focusedIndex: 1, sidebarExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.select);
    testContent(focused: false, selectedIndex: 1);
    testSidebar(selectedIndex: 1, focusedIndex: 1, sidebarExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowRight);
    testContent(focused: true, selectedIndex: 1);
    testSidebar(selectedIndex: 1, focusedIndex: 1, sidebarExpanded: false);
  }

  void testContent({required bool focused, required int selectedIndex}) {
    final contentFinder = find.byKey(CupertinoSidebarSample.contentKey);
    final contentDpadFocus = firstWidget<DpadFocus>(contentFinder);
    expect(contentDpadFocus.autofocus, true);
    expect(contentDpadFocus.canRequestFocus, true);
    expect(contentDpadFocus.focusNode?.hasFocus, focused);

    final contentTextFinder = find.descendant(
      of: contentFinder,
      matching: find.byType(Text),
    );

    final contentText = firstWidget<Text>(contentTextFinder);

    expect(
      contentText.data,
      '${ItemEntry(key: ValueKey(CupertinoSidebarSample.items[selectedIndex].$1))} content',
    );
  }

  void testSidebar({
    required int selectedIndex,
    required int focusedIndex,
    required bool sidebarExpanded,
  }) {
    if (!sidebarExpanded) {
      final headerFinder = find.byKey(
        CupertinoSidebarSample.collapsedHeaderKey,
      );
      expect(headerFinder, findsOneWidget);

      final (title, iconData) = CupertinoSidebarSample.items[selectedIndex];

      final item = CupertinoSidebarSample.buildItem(
        title: title,
        icon: iconData,
      );

      const states = {WidgetState.selected, WidgetState.focused};

      // check icon
      final realIcon = item.icon!.resolve(states) as Icon;

      final expectedIcon = CupertinoSidebarSample.buildIcon(
        iconData,
      ).resolve(states);

      expect(realIcon.icon, expectedIcon.icon);
      expect(realIcon.color, expectedIcon.color);
      expect(realIcon.size, expectedIcon.size);

      final titleFinder = find.descendant(
        of: headerFinder,
        matching: find.byType(Text),
      );

      final titleWidget = firstWidget<Text>(titleFinder);

      expect(titleWidget.data, title);
      expect(titleWidget.maxLines, 1);
      expect(
        titleWidget.style?.color,
        CupertinoSidebarSample.buildContentColor(states),
      );

      return;
    }

    for (int i = 0; i < CupertinoSidebarSample.items.length; ++i) {
      final (title, iconData) = CupertinoSidebarSample.items[i];

      final item = CupertinoSidebarSample.buildItem(
        title: title,
        icon: iconData,
      );
      final itemFinder = find.byKey(ValueKey(title));
      expect(itemFinder, findsOneWidget);

      final states = {
        if (i == selectedIndex) WidgetState.selected,
        if (i == focusedIndex) WidgetState.focused,
      };

      // check decoration
      final containerFinder = find.descendant(
        of: itemFinder,
        matching: find.byType(AnimatedContainer),
      );

      final container = firstWidget<AnimatedContainer>(containerFinder);

      expect(
        container.decoration! as BoxDecoration,
        CupertinoSidebarSample.buildDecoration().resolve(states),
      );

      // check icon
      final realIcon = item.icon!.resolve(states) as Icon;

      final expectedIcon = CupertinoSidebarSample.buildIcon(
        iconData,
      ).resolve(states);

      expect(realIcon.icon, expectedIcon.icon);
      expect(realIcon.color, expectedIcon.color);
      expect(realIcon.size, expectedIcon.size);

      // check title
      final titleFinder = find.descendant(
        of: itemFinder,
        matching: find.byType(Text),
      );

      final titleWidget = firstWidget<Text>(titleFinder);

      expect(titleWidget.data, title);
      expect(titleWidget.maxLines, 1);
      expect(
        titleWidget.style?.color,
        CupertinoSidebarSample.buildContentColor(states),
      );
    }
  }
}
