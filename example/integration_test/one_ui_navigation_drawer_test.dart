import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tv_plus/tv_plus.dart';
import 'package:tv_plus_example/one_ui/navigation_drawer_sample.dart';

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('One Ui navigation drawer tests', () {
    testWidgets('Standard', (tester) async {
      await tester.pumpWidget(const OneUiNavigationDrawerSample());
      await tester.testScenario();
    });
  });
}

extension NavigationDrawerTest on WidgetTester {
  Future<void> testScenario() async {
    testContent(focused: true, selectedIndex: 0);
    testDrawer(selectedIndex: 0, focusedIndex: 0, drawerExpanded: false);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowLeft);
    testContent(focused: false, selectedIndex: 0);
    testDrawer(selectedIndex: 0, focusedIndex: 0, drawerExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowDown);
    testContent(focused: false, selectedIndex: 0);
    testDrawer(selectedIndex: 0, focusedIndex: 1, drawerExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowDown);
    testContent(focused: false, selectedIndex: 0);
    testDrawer(selectedIndex: 0, focusedIndex: 2, drawerExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.select);
    testContent(focused: false, selectedIndex: 2);
    testDrawer(selectedIndex: 2, focusedIndex: 2, drawerExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowRight);
    testContent(focused: true, selectedIndex: 2);
    testDrawer(selectedIndex: 2, focusedIndex: 2, drawerExpanded: false);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowLeft);
    testContent(focused: false, selectedIndex: 2);
    testDrawer(selectedIndex: 2, focusedIndex: 2, drawerExpanded: true);

    // nothing should change
    await sendDpadEventAndSettle(LogicalKeyboardKey.select);
    testContent(focused: false, selectedIndex: 2);
    testDrawer(selectedIndex: 2, focusedIndex: 2, drawerExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowDown);
    testContent(focused: false, selectedIndex: 2);
    testDrawer(selectedIndex: 2, focusedIndex: 3, drawerExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.select);
    testContent(focused: false, selectedIndex: 3);
    testDrawer(selectedIndex: 3, focusedIndex: 3, drawerExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowRight);
    testContent(focused: true, selectedIndex: 3);
    testDrawer(selectedIndex: 3, focusedIndex: 3, drawerExpanded: false);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowLeft);
    testContent(focused: false, selectedIndex: 3);
    testDrawer(selectedIndex: 3, focusedIndex: 3, drawerExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowUp);
    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowUp);
    testContent(focused: false, selectedIndex: 3);
    testDrawer(selectedIndex: 3, focusedIndex: 1, drawerExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.select);
    testContent(focused: false, selectedIndex: 1);
    testDrawer(selectedIndex: 1, focusedIndex: 1, drawerExpanded: true);

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowRight);
    testContent(focused: true, selectedIndex: 1);
    testDrawer(selectedIndex: 1, focusedIndex: 1, drawerExpanded: false);
  }

  void testContent({required bool focused, required int selectedIndex}) {
    final contentFinder = find.byKey(OneUiNavigationDrawerSample.contentKey);
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
      '${ItemEntry(key: ValueKey(OneUiNavigationDrawerSample.items[selectedIndex].$1))} content',
    );
  }

  void testDrawer({
    required int selectedIndex,
    required int focusedIndex,
    required bool drawerExpanded,
  }) {
    for (int i = 0; i < OneUiNavigationDrawerSample.items.length; ++i) {
      final (title, iconData) = OneUiNavigationDrawerSample.items[i];

      final itemFinder = find.byKey(ValueKey(title));
      expect(itemFinder, findsOneWidget);

      final states = {
        if (i == selectedIndex) WidgetState.selected,
        if (i == focusedIndex && drawerExpanded) WidgetState.focused,
      };

      // check decoration
      final containerFinder = find.descendant(
        of: itemFinder,
        matching: find.byType(Container),
      );

      final container = firstWidget<Container>(containerFinder);

      expect(
        container.decoration! as BoxDecoration,
        OneUiNavigationDrawerSample.buildDecoration().resolve(states),
      );

      // check title
      final titleOpacityFinder = find.descendant(
        of: itemFinder,
        matching: find.byType(Opacity),
      );

      final titleOpacity = firstWidget<Opacity>(titleOpacityFinder);
      expect(titleOpacity.opacity, drawerExpanded ? 1.0 : 0.0);

      if (drawerExpanded) {
        final titleFinder = find.descendant(
          of: titleOpacityFinder,
          matching: find.byType(Text),
        );

        final titleWidget = firstWidget<Text>(titleFinder);

        expect(titleWidget.data, title);
        expect(titleWidget.maxLines, 1);
        expect(
          titleWidget.style?.color,
          OneUiNavigationDrawerSample.buildContentColor(states),
        );
      }
    }
  }
}
