import 'package:flutter/material.dart';
import 'package:tv_plus_example/material/navigation/navigation_drawer_sample.dart';

final class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, _) {
        return NavigationDrawerSample();
      },
    );
  }
}