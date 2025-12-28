import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tv_plus/tv_plus.dart';
import 'package:tv_plus_example/tab/tv_tab_bar_foundation_sample.dart';

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Tab bar foundation tests', () {
    testWidgets('...', (tester) async {
      await tester.pumpWidget(const TvTabBarFoundationSample());
      await tester.testScenario();
    });
  });
}

extension TabBarFoundationTest on WidgetTester {
  Future<void> testScenario() async {
    // Wait for the indicator to be displayed
    await pumpAndSettle();

    // Go to right until last item
    for (
      int i = TvTabBarFoundationSample.initialIndex;
      i < TvTabBarFoundationSample.items.length;
      ++i
    ) {
      await testTabBar(selectedIndex: i);
      await testIndicator(isFocused: true);
      await testContent(selectedIndex: i, isFocused: false);

      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowDown);

      await testTabBar(selectedIndex: i);
      await testIndicator(isFocused: false);
      await testContent(selectedIndex: i, isFocused: true);

      await sendDpadEventAndSettle(LogicalKeyboardKey.select);

      await testTabBar(selectedIndex: i);
      await testIndicator(isFocused: true);
      await testContent(selectedIndex: i, isFocused: false);

      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowRight);
    }

    // Go to left until first item
    for (int i = TvTabBarFoundationSample.items.length - 1; i >= 0; --i) {
      await testTabBar(selectedIndex: i);
      await testIndicator(isFocused: true);
      await testContent(selectedIndex: i, isFocused: false);

      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowDown);

      await testTabBar(selectedIndex: i);
      await testIndicator(isFocused: false);
      await testContent(selectedIndex: i, isFocused: true);

      await sendDpadEventAndSettle(LogicalKeyboardKey.select);

      await testTabBar(selectedIndex: i);
      await testIndicator(isFocused: true);
      await testContent(selectedIndex: i, isFocused: false);

      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowLeft);
    }
  }

  Future<void> testTabBar({required int selectedIndex}) async {
    final tabBarFinder = find.byKey(TvTabBarFoundationSample.tabBarKey);
    expect(tabBarFinder, findsOneWidget);

    final tabBar = firstWidget<TvTabBarFoundation>(tabBarFinder);
    expect(tabBar.mainAxisSize, MainAxisSize.min);

    final itemsFinder = find.descendant(
      of: tabBarFinder,
      matching: find.byType(TabItem),
    );

    for (final (i, element) in itemsFinder.evaluate().indexed) {
      final item = element.widget as TabItem;
      final index = item.index;

      final (text, iconData) = TvTabBarFoundationSample.items[index];

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

      if (selectedIndex == index) {
        expect(icon.color, TvTabBarFoundationSample.contentSelectedColor);
        expect(
          title.style?.color,
          TvTabBarFoundationSample.contentSelectedColor,
        );
      } else {
        expect(icon.color, TvTabBarFoundationSample.contentColor);
        expect(title.style?.color, TvTabBarFoundationSample.contentColor);
      }
    }
  }

  Future<void> testIndicator({required bool isFocused}) async {
    final indicatorFinder = find.byKey(TvTabBarFoundationSample.indicatorKey);
    expect(indicatorFinder, findsOneWidget);

    final containerFinder = find.descendant(
      of: indicatorFinder,
      matching: find.byType(AnimatedContainer),
    );

    expect(containerFinder, findsOneWidget);

    final indicatorContainer = firstWidget<AnimatedContainer>(containerFinder);
    final indicatorDecoration = indicatorContainer.decoration! as BoxDecoration;

    expect(
      indicatorDecoration.color,
      isFocused
          ? TvTabBarFoundationSample.focusedColor
          : TvTabBarFoundationSample.selectedColor,
    );
  }

  Future<void> testContent({
    required int selectedIndex,
    required bool isFocused,
  }) async {
    final contentFinder = find.byKey(TvTabBarFoundationSample.contentKey);
    expect(contentFinder, findsOneWidget);

    final (text, iconData) = TvTabBarFoundationSample.items[selectedIndex];

    final iconFinder = find.descendant(
      of: contentFinder,
      matching: find.byKey(TvTabBarFoundationSample.contentIconKey),
    );

    expect(iconFinder, findsOneWidget);

    final icon = firstWidget<Icon>(iconFinder);
    expect(icon.icon, iconData);

    final titleFinder = find.descendant(
      of: contentFinder,
      matching: find.byKey(TvTabBarFoundationSample.contentTitleKey),
    );

    expect(titleFinder, findsOneWidget);

    final jumpFinder = find.descendant(
      of: contentFinder,
      matching: find.byKey(TvTabBarFoundationSample.contentJumpKey),
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
      isFocused ? TvTabBarFoundationSample.focusedColor : Colors.transparent,
    );
  }
}
