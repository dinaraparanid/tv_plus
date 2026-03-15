import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_plus_material/src/example/slider/slider_sample.dart';
import 'package:tv_plus_material/src/slider/slider.dart';

import '../../foundation/test/utils.dart';

void main() {
  group('Material TvSlider tests', () {
    testWidgets('...', (tester) async {
      await tester.pumpWidget(const SliderSample());
      await tester.testScenario();
    });
  });
}

extension SliderTest on WidgetTester {
  Future<void> testScenario() async {
    await pumpAndSettle();

    var contValue = SliderSample.continuousSliderInitialValue;
    var stepValue = SliderSample.stepSliderInitialValue;
    const stepChange =
        (SliderSample.stepSliderMax - SliderSample.stepSliderMin) /
        SliderSample.stepSliderDivisions;

    for (
      ;
      contValue < SliderSample.continuousSliderMax;
      contValue += SliderSample.continuousSliderStep
    ) {
      await testContinuousSlider(value: contValue, hasFocus: true);
      await testStepSlider(value: stepValue, hasFocus: false);
      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowUp);
    }

    contValue = SliderSample.continuousSliderMax;

    for (
      ;
      contValue > SliderSample.continuousSliderMin;
      contValue -= SliderSample.continuousSliderStep
    ) {
      await testContinuousSlider(value: contValue, hasFocus: true);
      await testStepSlider(value: stepValue, hasFocus: false);
      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowDown);
    }

    contValue = SliderSample.continuousSliderMin;

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowRight);

    for (; stepValue < SliderSample.stepSliderMax; stepValue += stepChange) {
      await testContinuousSlider(value: contValue, hasFocus: false);
      await testStepSlider(value: stepValue, hasFocus: true);
      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowUp);
    }

    stepValue = SliderSample.stepSliderMax;

    for (; stepValue > SliderSample.stepSliderMin; stepValue -= stepChange) {
      await testContinuousSlider(value: contValue, hasFocus: false);
      await testStepSlider(value: stepValue, hasFocus: true);
      await sendDpadEventAndSettle(LogicalKeyboardKey.arrowDown);
    }

    stepValue = SliderSample.stepSliderMin;

    await sendDpadEventAndSettle(LogicalKeyboardKey.arrowLeft);
    await testContinuousSlider(value: contValue, hasFocus: true);
    await testStepSlider(value: stepValue, hasFocus: false);
  }

  Future<void> testContinuousSlider({
    required double value,
    required bool hasFocus,
  }) async {
    final finder = find.byKey(SliderSample.continuousSliderKey);
    expect(finder, findsOneWidget);

    final slider = firstWidget<TvSlider>(finder);
    expect(slider.value, value);
    expect(slider.focusNode!.hasFocus, hasFocus);
  }

  Future<void> testStepSlider({
    required double value,
    required bool hasFocus,
  }) async {
    final finder = find.byKey(SliderSample.stepSliderKey);
    expect(finder, findsOneWidget);

    final slider = firstWidget<TvSlider>(finder);
    expect(slider.value, value);
    expect(slider.focusNode!.hasFocus, hasFocus);
  }
}
