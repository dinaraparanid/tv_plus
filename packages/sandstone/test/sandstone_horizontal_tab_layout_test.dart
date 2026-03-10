import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_plus_sandstone/src/example/navigation/sandstone_horizontal_tab_layout_sample.dart';
import 'package:tv_plus_sandstone/tv_plus_sandstone.dart';

import '../../foundation/test/utils.dart';

void main() {
  group('Sandstone horizontal tab layout', () {
    testWidgets('...', (tester) async {
      await tester.pumpWidget(const SandstoneHorizontalTabLayoutSample());
      await tester.testScenario(
        initialIndex: SandstoneHorizontalTabLayoutSample.initialIndex,
        tabBarKey: SandstoneHorizontalTabLayoutSample.tabBarKey,
        indicatorKey: SandstoneHorizontalTabLayoutSample.indicatorKey,
        contentKey: SandstoneHorizontalTabLayoutSample.contentKey,
        contentIconKey: SandstoneHorizontalTabLayoutSample.contentIconKey,
        contentTitleKey: SandstoneHorizontalTabLayoutSample.contentTitleKey,
        contentJumpKey: SandstoneHorizontalTabLayoutSample.contentJumpKey,
        contentColor: SandstoneHorizontalTabLayoutSample.contentColor,
        items: SandstoneHorizontalTabLayoutSample.items,
      );
    });
  });
}

extension SandstoneHorizontalTabLayoutSampleTest on WidgetTester {
  Future<void> testScenario({
    required int initialIndex,
    required GlobalKey tabBarKey,
    required GlobalKey indicatorKey,
    required GlobalKey contentKey,
    required GlobalKey contentIconKey,
    required GlobalKey contentTitleKey,
    required GlobalKey contentJumpKey,
    required Color contentColor,
    required List<(String, IconData)> items,
  }) async {
    // Wait for the indicator to be displayed
    await pumpAndSettle();

    // Go to right until last item
    for (int i = initialIndex; i < items.length; ++i) {
      await testTabBar(
        selectedIndex: i,
        tabBarKey: tabBarKey,
        contentColor: contentColor,
        items: items,
      );
      await testIndicator(isFocused: true, indicatorKey: indicatorKey);
      await testContent(
        selectedIndex: i,
        isFocused: false,
        contentKey: contentKey,
        contentIconKey: contentIconKey,
        contentTitleKey: contentTitleKey,
        contentJumpKey: contentJumpKey,
        items: items,
      );

      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowDown);

      await testTabBar(
        selectedIndex: i,
        tabBarKey: tabBarKey,
        contentColor: contentColor,
        items: items,
      );
      await testIndicator(isFocused: false, indicatorKey: indicatorKey);
      await testContent(
        selectedIndex: i,
        isFocused: true,
        contentKey: contentKey,
        contentIconKey: contentIconKey,
        contentTitleKey: contentTitleKey,
        contentJumpKey: contentJumpKey,
        items: items,
      );

      await sendDpadEventAndSettle(LogicalKeyboardKey.select);

      await testTabBar(
        selectedIndex: i,
        tabBarKey: tabBarKey,
        contentColor: contentColor,
        items: items,
      );
      await testIndicator(isFocused: true, indicatorKey: indicatorKey);
      await testContent(
        selectedIndex: i,
        isFocused: false,
        contentKey: contentKey,
        contentIconKey: contentIconKey,
        contentTitleKey: contentTitleKey,
        contentJumpKey: contentJumpKey,
        items: items,
      );

      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowRight);
    }

    // Go to left until first item
    for (int i = items.length - 1; i >= 0; --i) {
      await testTabBar(
        selectedIndex: i,
        tabBarKey: tabBarKey,
        contentColor: contentColor,
        items: items,
      );
      await testIndicator(isFocused: true, indicatorKey: indicatorKey);
      await testContent(
        selectedIndex: i,
        isFocused: false,
        contentKey: contentKey,
        contentIconKey: contentIconKey,
        contentTitleKey: contentTitleKey,
        contentJumpKey: contentJumpKey,
        items: items,
      );

      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowDown);

      await testTabBar(
        selectedIndex: i,
        tabBarKey: tabBarKey,
        contentColor: contentColor,
        items: items,
      );
      await testIndicator(isFocused: false, indicatorKey: indicatorKey);
      await testContent(
        selectedIndex: i,
        isFocused: true,
        contentKey: contentKey,
        contentIconKey: contentIconKey,
        contentTitleKey: contentTitleKey,
        contentJumpKey: contentJumpKey,
        items: items,
      );

      await sendDpadEventAndSettle(LogicalKeyboardKey.select);

      await testTabBar(
        selectedIndex: i,
        tabBarKey: tabBarKey,
        contentColor: contentColor,
        items: items,
      );
      await testIndicator(isFocused: true, indicatorKey: indicatorKey);
      await testContent(
        selectedIndex: i,
        isFocused: false,
        contentKey: contentKey,
        contentIconKey: contentIconKey,
        contentTitleKey: contentTitleKey,
        contentJumpKey: contentJumpKey,
        items: items,
      );

      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowLeft);
    }
  }

  Future<void> testTabBar({
    required int selectedIndex,
    required GlobalKey tabBarKey,
    required Color contentColor,
    required List<(String, IconData)> items,
  }) async {
    final tabBarFinder = find.byKey(tabBarKey);
    expect(tabBarFinder, findsOneWidget);

    final tabBar = firstWidget<SandstoneHorizontalTabLayout>(tabBarFinder);
    expect(tabBar.mainAxisSize, MainAxisSize.max);

    final itemsFinder = find.descendant(
      of: tabBarFinder,
      matching: find.byType(TvTabItemSample),
    );

    for (final (i, element) in itemsFinder.evaluate().indexed) {
      final item = element.widget as TvTabItemSample;
      final index = item.index;

      final (text, iconData) = items[index];

      final itemFinder = itemsFinder.at(i);

      final tvTabFinder = find.descendant(
        of: itemFinder,
        matching: find.byType(TvTab),
      );

      expect(tvTabFinder, findsOneWidget);

      final tvTab = firstWidget<TvTab>(tvTabFinder);
      expect(tvTab.viewportAlignment, 0.5);

      final iconFinder = find.descendant(
        of: itemFinder,
        matching: find.byType(Icon),
      );

      expect(iconFinder, findsOneWidget);

      final icon = firstWidget<Icon>(iconFinder);
      expect(icon.icon, iconData);

      final titleFinder = find.descendant(
        of: itemFinder,
        matching: find.byType(Text),
      );

      expect(titleFinder, findsOneWidget);

      final title = firstWidget<Text>(titleFinder);
      expect(title.data, text);
      expect(icon.color, contentColor);
      expect(title.style?.color, contentColor);
    }
  }

  Future<void> testIndicator({
    required bool isFocused,
    required GlobalKey indicatorKey,
  }) async {
    final indicatorFinder = find.byKey(indicatorKey);
    expect(indicatorFinder, findsOneWidget);

    final indicatorContainer = firstWidget<Container>(indicatorFinder);
    final indicatorDecoration = indicatorContainer.decoration! as BoxDecoration;

    expect(
      indicatorDecoration.color,
      SandstoneHorizontalTabLayoutSample.indicatorColor,
    );
  }

  Future<void> testContent({
    required int selectedIndex,
    required bool isFocused,
    required GlobalKey contentKey,
    required GlobalKey contentIconKey,
    required GlobalKey contentTitleKey,
    required GlobalKey contentJumpKey,
    required List<(String, IconData)> items,
  }) async {
    final contentFinder = find.byKey(contentKey);
    expect(contentFinder, findsOneWidget);

    final (text, iconData) = items[selectedIndex];

    final iconFinder = find.descendant(
      of: contentFinder,
      matching: find.byKey(contentIconKey),
    );

    expect(iconFinder, findsOneWidget);

    final icon = firstWidget<Icon>(iconFinder);
    expect(icon.icon, iconData);

    final titleFinder = find.descendant(
      of: contentFinder,
      matching: find.byKey(contentTitleKey),
    );

    expect(titleFinder, findsOneWidget);

    final jumpFinder = find.descendant(
      of: contentFinder,
      matching: find.byKey(contentJumpKey),
    );

    expect(jumpFinder, findsOneWidget);

    final jumpButton = firstWidget<DpadFocus>(jumpFinder);
    expect(jumpButton.focusNode?.hasFocus, isFocused);

    final jumpContainerFinder = find.descendant(
      of: jumpFinder,
      matching: find.byType(Container),
    );

    expect(jumpContainerFinder, findsOneWidget);

    final jumpContainer = firstWidget<Container>(jumpContainerFinder);
    final jumpDecoration = jumpContainer.decoration! as BoxDecoration;

    expect(
      jumpDecoration.color,
      isFocused
          ? SandstoneHorizontalTabLayoutSample.indicatorColor
          : Colors.transparent,
    );
  }
}
