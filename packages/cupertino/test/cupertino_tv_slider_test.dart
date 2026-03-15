import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_plus_cupertino/src/example/slider/slider_sample.dart';
import 'package:tv_plus_cupertino/src/slider/slider.dart';

import '../../foundation/test/utils.dart';

void main() {
  group('Cupertino TvSlider tests', () {
    testWidgets('...', (tester) async {
      await tester.pumpWidget(const CupertinoSliderSample());
      await tester.testScenario();
    });
  });
}

extension CupertinoSliderTest on WidgetTester {
  Future<void> testScenario() async {
    await pumpAndSettle();

    var contValue = CupertinoSliderSample.continuousSliderInitialValue;
    var stepValue = CupertinoSliderSample.stepSliderInitialValue;
    const stepChange =
        (CupertinoSliderSample.stepSliderMax -
            CupertinoSliderSample.stepSliderMin) /
        CupertinoSliderSample.stepSliderDivisions;

    for (
      ;
      contValue < CupertinoSliderSample.continuousSliderMax;
      contValue += CupertinoSliderSample.continuousSliderStep
    ) {
      await testContinuousSlider(value: contValue, hasFocus: true);
      await testStepSlider(value: stepValue, hasFocus: false);
      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowUp);
    }

    contValue = CupertinoSliderSample.continuousSliderMax;

    for (
      ;
      contValue > CupertinoSliderSample.continuousSliderMin;
      contValue -= CupertinoSliderSample.continuousSliderStep
    ) {
      await testContinuousSlider(value: contValue, hasFocus: true);
      await testStepSlider(value: stepValue, hasFocus: false);
      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowDown);
    }

    contValue = CupertinoSliderSample.continuousSliderMin;

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowRight);

    for (
      ;
      stepValue < CupertinoSliderSample.stepSliderMax;
      stepValue += stepChange
    ) {
      await testContinuousSlider(value: contValue, hasFocus: false);
      await testStepSlider(value: stepValue, hasFocus: true);
      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowUp);
    }

    stepValue = CupertinoSliderSample.stepSliderMax;

    for (
      ;
      stepValue > CupertinoSliderSample.stepSliderMin;
      stepValue -= stepChange
    ) {
      await testContinuousSlider(value: contValue, hasFocus: false);
      await testStepSlider(value: stepValue, hasFocus: true);
      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowDown);
    }

    stepValue = CupertinoSliderSample.stepSliderMin;

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowLeft);
    await testContinuousSlider(value: contValue, hasFocus: true);
    await testStepSlider(value: stepValue, hasFocus: false);
  }

  Future<void> testContinuousSlider({
    required double value,
    required bool hasFocus,
  }) async {
    final finder = find.byKey(CupertinoSliderSample.continuousSliderKey);
    expect(finder, findsOneWidget);

    final slider = firstWidget<CupertinoTvSlider>(finder);
    expect(slider.value, value);
    expect(slider.focusNode!.hasFocus, hasFocus);
  }

  Future<void> testStepSlider({
    required double value,
    required bool hasFocus,
  }) async {
    final finder = find.byKey(CupertinoSliderSample.stepSliderKey);
    expect(finder, findsOneWidget);

    final slider = firstWidget<CupertinoTvSlider>(finder);
    expect(slider.value, value);
    expect(slider.focusNode!.hasFocus, hasFocus);
  }
}
