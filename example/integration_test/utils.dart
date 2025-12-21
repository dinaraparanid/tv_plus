import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterExt on WidgetTester {
  Future<void> sendDpadEventAndSettle(LogicalKeyboardKey key) async {
    await sendKeyEvent(key);
    await pumpAndSettle();
  }
}
