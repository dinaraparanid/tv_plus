import 'package:flutter/material.dart';

import 'package:tv_plus_material/src/slider/slider.dart';

final class SliderSample extends StatefulWidget {
  const SliderSample({super.key});

  static const backgroundColor = Color(0xFF131314);

  @override
  State<StatefulWidget> createState() => _SliderSampleState();
}

final class _SliderSampleState extends State<SliderSample> {
  var _value1 = 0.0;
  var _value2 = 1.0;

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
                  value: _value1,
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
                  value: _value2,
                  onChanged: (value) => setState(() => _value2 = value),
                  min: 0.5,
                  max: 2,
                  divisions: 5,
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
