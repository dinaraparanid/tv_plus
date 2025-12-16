import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tv_plus/foundation/foundation.dart';
import 'package:tv_plus/material/material.dart';
import 'package:tv_plus_example/material/navigation/navigation_drawer_sample.dart';

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Material navigation drawer tests', () {
    testWidgets('Modal', (tester) async {
      await tester.pumpWidget(const NavigationDrawerSample());
      await tester.testScenario();
    });

    testWidgets('Standard', (tester) async {
      await tester.pumpWidget(
        const NavigationDrawerSample(mode: TvNavigationDrawerMode.standard),
      );
      await tester.testScenario();
    });
  });
}

extension NavigationDrawerTest on WidgetTester {
  Future<void> testScenario() async {
    testContent(focused: true, selectedIndex: 0);
    testDrawerItems(selectedIndex: 0, focusedIndex: 0, drawerExpanded: false);

    await sendDpadEvent(LogicalKeyboardKey.arrowLeft);
    testContent(focused: false, selectedIndex: 0);
    testDrawerItems(selectedIndex: 0, focusedIndex: 0, drawerExpanded: true);

    await sendDpadEvent(LogicalKeyboardKey.arrowDown);
    testContent(focused: false, selectedIndex: 0);
    testDrawerItems(selectedIndex: 0, focusedIndex: 1, drawerExpanded: true);

    await sendDpadEvent(LogicalKeyboardKey.arrowDown);
    testContent(focused: false, selectedIndex: 0);
    testDrawerItems(selectedIndex: 0, focusedIndex: 2, drawerExpanded: true);

    await sendDpadEvent(LogicalKeyboardKey.select);
    testContent(focused: false, selectedIndex: 2);
    testDrawerItems(selectedIndex: 2, focusedIndex: 2, drawerExpanded: true);

    await sendDpadEvent(LogicalKeyboardKey.arrowRight);
    testContent(focused: true, selectedIndex: 2);
    testDrawerItems(selectedIndex: 2, focusedIndex: 2, drawerExpanded: false);

    await sendDpadEvent(LogicalKeyboardKey.arrowLeft);
    testContent(focused: false, selectedIndex: 2);
    testDrawerItems(selectedIndex: 2, focusedIndex: 2, drawerExpanded: true);

    // nothing should change
    await sendDpadEvent(LogicalKeyboardKey.select);
    testContent(focused: false, selectedIndex: 2);
    testDrawerItems(selectedIndex: 2, focusedIndex: 2, drawerExpanded: true);

    await sendDpadEvent(LogicalKeyboardKey.arrowDown);
    testContent(focused: false, selectedIndex: 2);
    testDrawerItems(selectedIndex: 2, focusedIndex: 3, drawerExpanded: true);

    await sendDpadEvent(LogicalKeyboardKey.select);
    testContent(focused: false, selectedIndex: 3);
    testDrawerItems(selectedIndex: 3, focusedIndex: 3, drawerExpanded: true);

    await sendDpadEvent(LogicalKeyboardKey.arrowRight);
    testContent(focused: true, selectedIndex: 3);
    testDrawerItems(selectedIndex: 3, focusedIndex: 3, drawerExpanded: false);

    await sendDpadEvent(LogicalKeyboardKey.arrowLeft);
    testContent(focused: false, selectedIndex: 3);
    testDrawerItems(selectedIndex: 3, focusedIndex: 3, drawerExpanded: true);

    await sendDpadEvent(LogicalKeyboardKey.arrowUp);
    await sendDpadEvent(LogicalKeyboardKey.arrowUp);
    testContent(focused: false, selectedIndex: 3);
    testDrawerItems(selectedIndex: 3, focusedIndex: 1, drawerExpanded: true);

    await sendDpadEvent(LogicalKeyboardKey.select);
    testContent(focused: false, selectedIndex: 1);
    testDrawerItems(selectedIndex: 1, focusedIndex: 1, drawerExpanded: true);

    await sendDpadEvent(LogicalKeyboardKey.arrowRight);
    testContent(focused: true, selectedIndex: 1);
    testDrawerItems(selectedIndex: 1, focusedIndex: 1, drawerExpanded: false);
  }

  void testContent({required bool focused, required int selectedIndex}) {
    final contentFinder = find.byKey(NavigationDrawerSample.contentKey);
    final contentDpadFocus = firstWidget(contentFinder) as DpadFocus;
    expect(contentDpadFocus.autofocus, true);
    expect(contentDpadFocus.canRequestFocus, true);
    expect(contentDpadFocus.focusNode?.hasFocus, focused);

    final contentTextFinder = find.descendant(
      of: contentFinder,
      matching: find.byType(Text),
    );

    final contentText = firstWidget(contentTextFinder) as Text;

    expect(
      contentText.data,
      '${ItemEntry(key: ValueKey(NavigationDrawerSample.items[selectedIndex].$1))} content',
    );
  }

  void testDrawerItems({
    required int selectedIndex,
    required int focusedIndex,
    required bool drawerExpanded,
  }) {
    for (int i = 0; i < NavigationDrawerSample.items.length; ++i) {
      final (title, iconData) = NavigationDrawerSample.items[i];

      final item = NavigationDrawerSample.buildItem(
        title: title,
        icon: iconData,
        isDrawerExpanded: () => drawerExpanded,
      );

      final itemFinder = find.byKey(ValueKey(title));

      final states = {
        if (i == selectedIndex) WidgetState.selected,
        if (i == focusedIndex && drawerExpanded) WidgetState.focused,
      };

      // check decoration
      final containerFinder = find.descendant(
        of: itemFinder,
        matching: find.byType(AnimatedContainer),
      );

      final container = firstWidget(containerFinder) as AnimatedContainer;

      expect(
        container.decoration! as BoxDecoration,
        NavigationDrawerSample.buildDecoration().resolve(states),
      );

      // check icon
      final realIcon = item.icon.resolve(states);

      final expectedIcon = NavigationDrawerSample.buildIcon(
        iconData,
      ).resolve(states);

      expect(realIcon.icon, expectedIcon.icon);
      expect(realIcon.color, expectedIcon.color);
      expect(realIcon.size, expectedIcon.size);

      // check title
      final titleOpacityFinder = find.descendant(
        of: itemFinder,
        matching: find.byType(AnimatedOpacity),
      );

      final titleOpacity = firstWidget(titleOpacityFinder) as AnimatedOpacity;
      expect(titleOpacity.opacity, drawerExpanded ? 1.0 : 0.0);

      if (drawerExpanded) {
        final titleFinder = find.descendant(
          of: titleOpacityFinder,
          matching: find.byType(Text),
        );

        final titleWidget = firstWidget(titleFinder) as Text;

        expect(titleWidget.data, title);
        expect(titleWidget.maxLines, 1);
        expect(
          titleWidget.style?.color,
          NavigationDrawerSample.buildContentColor(states),
        );
      }
    }
  }
}
