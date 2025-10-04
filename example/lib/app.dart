import 'package:flutter/material.dart';
import 'package:tv_plus_example/dpad_navigation_sample.dart';

final class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, _) {
        return Material(
          color: Colors.transparent,
          child: DpadNavigationSample(),
        );
      },
    );
  }
}