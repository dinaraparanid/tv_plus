import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterExt on WidgetTester {
  Future<void> sendDpadEvent(LogicalKeyboardKey key) async {
    await sendKeyEvent(key);
    await pumpAndSettle();
  }
}
