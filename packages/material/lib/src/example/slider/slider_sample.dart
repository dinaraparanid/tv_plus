import 'package:flutter/material.dart';

import 'package:tv_plus_material/src/slider/slider.dart';

final class SliderSample extends StatefulWidget {
  const SliderSample({super.key});

  static const backgroundColor = Color(0xFF131314);

  static const continuousSliderInitialValue = 0.0;
  static const continuousSliderMin = 0.0;
  static const continuousSliderMax = 1.0;
  static const continuousSliderStep = 0.2;

  static const stepSliderInitialValue = 1.0;
  static const stepSliderMin = 0.5;
  static const stepSliderMax = 2.0;
  static const stepSliderDivisions = 5;

  static final continuousSliderKey = GlobalKey();
  static final stepSliderKey = GlobalKey();

  @override
  State<StatefulWidget> createState() => _SliderSampleState();
}

final class _SliderSampleState extends State<SliderSample> {
  var _value1 = SliderSample.continuousSliderInitialValue;
  var _value2 = SliderSample.stepSliderInitialValue;

  late final _node1 = FocusNode();
  late final _node2 = FocusNode();

  @override
  void dispose() {
    _node1.dispose();
    _node2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: SliderSample.backgroundColor,
      theme: ThemeData(
        // ignore: deprecated_member_use
        sliderTheme: const SliderThemeData(year2023: false),
      ),
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Row(
            spacing: 64,
            children: [
              Expanded(
                child: TvSlider(
                  key: SliderSample.continuousSliderKey,
                  value: _value1,
                  min: SliderSample.continuousSliderMin,
                  max: SliderSample.continuousSliderMax,
                  step: SliderSample.continuousSliderStep,
                  onChanged: (value) => setState(() => _value1 = value),
                  focusNode: _node1,
                  autofocus: true,
                  onRight: (_, _) {
                    _node2.requestFocus();
                    return KeyEventResult.handled;
                  },
                ),
              ),
              Expanded(
                child: TvSlider(
                  key: SliderSample.stepSliderKey,
                  value: _value2,
                  onChanged: (value) => setState(() => _value2 = value),
                  min: SliderSample.stepSliderMin,
                  max: SliderSample.stepSliderMax,
                  divisions: SliderSample.stepSliderDivisions,
                  focusNode: _node2,
                  autofocus: true,
                  label: _value2.toStringAsFixed(1),
                  onLeft: (_, _) {
                    _node1.requestFocus();
                    return KeyEventResult.handled;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
