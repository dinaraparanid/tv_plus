import 'package:flutter/cupertino.dart';

import 'package:tv_plus_cupertino/src/slider/slider.dart';

final class CupertinoSliderSample extends StatefulWidget {
  const CupertinoSliderSample({super.key});

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
  State<StatefulWidget> createState() => _CupertinoSliderSampleState();
}

final class _CupertinoSliderSampleState extends State<CupertinoSliderSample> {
  var _value1 = CupertinoSliderSample.continuousSliderInitialValue;
  var _value2 = CupertinoSliderSample.stepSliderInitialValue;

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
    return CupertinoApp(
      home: CupertinoPageScaffold(
        backgroundColor: CupertinoSliderSample.backgroundColor,
        child: Center(
          child: Row(
            spacing: 64,
            children: [
              Expanded(
                child: CupertinoTvSlider(
                  key: CupertinoSliderSample.continuousSliderKey,
                  value: _value1,
                  min: CupertinoSliderSample.continuousSliderMin,
                  max: CupertinoSliderSample.continuousSliderMax,
                  step: CupertinoSliderSample.continuousSliderStep,
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
                child: CupertinoTvSlider(
                  key: CupertinoSliderSample.stepSliderKey,
                  value: _value2,
                  onChanged: (value) => setState(() => _value2 = value),
                  min: CupertinoSliderSample.stepSliderMin,
                  max: CupertinoSliderSample.stepSliderMax,
                  divisions: CupertinoSliderSample.stepSliderDivisions,
                  focusNode: _node2,
                  autofocus: true,
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
