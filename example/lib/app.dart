import 'package:flutter/material.dart';

import 'dpad/dpad_navigation_sample.dart';

final class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const DpadNavigationSample(isReverseTimerEnabled: false);
  }
}
