import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tv_plus/tv_plus.dart';
import 'package:tv_plus_example/dpad/dpad_navigation_sample.dart';
import 'package:tv_plus_example/dpad/dpad_scope_navigation_sample.dart';
import 'package:tv_plus_example/dpad/sample_dpad_focus.dart';

final class SampleDpadData {
  SampleDpadData({
    required this.key,
    required this.text,
    required this.autofocus,
    required this.canRequestFocus,
    required this.color,
  });

  final Key key;
  final String text;
  final bool autofocus;
  final bool canRequestFocus;
  final Color color;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Dpad scope navigation tests', () {
    testWidgets('...', (tester) async {
      await tester.pumpWidget(
        const DpadScopeNavigationSample(isTraverseTimerEnabled: true),
      );

      void testDpadFocus({
        required Key key,
        required String expectedText,
        required bool expectedAutofocus,
        required bool expectedCanRequestFocus,
        required Color expectedColor,
      }) {
        final focusFinder = find.byKey(key);
        final _ = tester.firstWidget<SampleDpadFocus>(focusFinder);

        final focusTextFinder = find.descendant(
          of: focusFinder,
          matching: find.byType(Text),
        );

        final focusText = tester.firstWidget<Text>(focusTextFinder);
        expect(focusText.data, expectedText);

        final focusDpadFinder = find.descendant(
          of: focusFinder,
          matching: find.byType(DpadFocus),
        );

        final focusDpad = tester.firstWidget<DpadFocus>(focusDpadFinder);
        expect(focusDpad.autofocus, expectedAutofocus);
        expect(focusDpad.canRequestFocus, expectedCanRequestFocus);

        final focusBoxFinder = find.descendant(
          of: focusDpadFinder,
          matching: find.byType(DecoratedBox),
        );
        final focusBox = tester.firstWidget<DecoratedBox>(focusBoxFinder);
        final f1BoxDecoration = focusBox.decoration as BoxDecoration;
        expect(f1BoxDecoration.color, expectedColor);
      }

      void testAllWidgets(List<SampleDpadData> widgetsData) {
        expect(widgetsData.length, 11);

        for (final data in widgetsData) {
          testDpadFocus(
            key: data.key,
            expectedText: data.text,
            expectedAutofocus: data.autofocus,
            expectedCanRequestFocus: data.canRequestFocus,
            expectedColor: data.color,
          );
        }
      }

      // ( only from center )
      //
      //    | F | $ | * |
      //    | $ | * | $ |
      //    | * | $ | * |
      //
      // ( reverse buttons )
      testAllWidgets(_buildSampleDataList(isOddEnabled: true, focusedIndex: 1));

      // ( only from center )
      //
      //    | * | $ | F |
      //    | $ | * | $ |
      //    | * | $ | * |
      //
      // ( reverse buttons )
      await tester.pumpAndSettle(DpadScopeNavigationSample.timerDelay);
      testAllWidgets(_buildSampleDataList(isOddEnabled: true, focusedIndex: 3));

      // ( only from center )
      //
      //    | * | $ | * |
      //    | $ | F | $ |
      //    | * | $ | * |
      //
      // ( reverse buttons )
      await tester.pumpAndSettle(DpadScopeNavigationSample.timerDelay);
      testAllWidgets(_buildSampleDataList(isOddEnabled: true, focusedIndex: 5));

      // ( only from center )
      //
      //    | * | $ | * |
      //    | $ | * | $ |
      //    | F | $ | * |
      //
      // ( reverse buttons )
      await tester.pumpAndSettle(DpadScopeNavigationSample.timerDelay);
      testAllWidgets(_buildSampleDataList(isOddEnabled: true, focusedIndex: 7));

      // ( only from center )
      //
      //    | * | $ | * |
      //    | $ | * | $ |
      //    | * | $ | F |
      //
      // ( reverse buttons )
      await tester.pumpAndSettle(DpadScopeNavigationSample.timerDelay);
      testAllWidgets(_buildSampleDataList(isOddEnabled: true, focusedIndex: 9));

      // ( only from center )
      //
      //    | F | $ | * |
      //    | $ | * | $ |
      //    | * | $ | * |
      //
      // ( reverse buttons )
      await tester.pumpAndSettle(DpadScopeNavigationSample.timerDelay);
      testAllWidgets(_buildSampleDataList(isOddEnabled: true, focusedIndex: 1));
    });
  });
}

List<SampleDpadData> _buildSampleDataList({
  required bool isOddEnabled,
  required int focusedIndex,
}) {
  String gridCellText(int index) {
    if (index == 0) {
      return 'Focusable only from center (fn5)';
    }

    if (index == 10) {
      return 'Reverse grid';
    }

    if (index == focusedIndex) {
      return SampleDpadFocus.textFocused;
    }

    if (isOddEnabled && index.isOdd) {
      return SampleDpadFocus.textEnabled;
    }

    if (!isOddEnabled && index.isEven) {
      return SampleDpadFocus.textEnabled;
    }

    return SampleDpadFocus.textDisabled;
  }

  Color gridCellColor(int index) {
    if (index == 0 || index == 10) {
      return focusedIndex == index
          ? SampleDpadFocus.colorFocused
          : SampleDpadFocus.colorEnabled;
    }

    if (index == focusedIndex) {
      return SampleDpadFocus.colorFocused;
    }

    if (isOddEnabled && index.isOdd) {
      return SampleDpadFocus.colorEnabled;
    }

    if (!isOddEnabled && index.isEven) {
      return SampleDpadFocus.colorEnabled;
    }

    return SampleDpadFocus.colorDisabled;
  }

  bool gridCellCanRequestFocus(int index) {
    if (index == 0 || index == 10) {
      return true;
    }

    return (isOddEnabled && index.isOdd) || (!isOddEnabled && index.isEven);
  }

  return [
        DpadNavigationSample.keyOnlyFromCenterButton,
        DpadNavigationSample.keyF1,
        DpadNavigationSample.keyF2,
        DpadNavigationSample.keyF3,
        DpadNavigationSample.keyF4,
        DpadNavigationSample.keyF5,
        DpadNavigationSample.keyF6,
        DpadNavigationSample.keyF7,
        DpadNavigationSample.keyF8,
        DpadNavigationSample.keyF9,
        DpadNavigationSample.keyReverseButton,
      ].indexed
      .map((indexWithKey) {
        return SampleDpadData(
          key: indexWithKey.$2,
          text: gridCellText(indexWithKey.$1),
          autofocus: indexWithKey.$1 == 1,
          canRequestFocus: gridCellCanRequestFocus(indexWithKey.$1),
          color: gridCellColor(indexWithKey.$1),
        );
      })
      .toList(growable: false);
}
