import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterExt on WidgetTester {
  Future<void> sendDpadEventAndSettle(LogicalKeyboardKey key) async {
    await sendKeyEvent(key);
    await pumpAndSettle();
  }

  Future<void> sendLongDpadEventAndSettle(
    LogicalKeyboardKey key, {
    Duration longPressDuration = kLongPressTimeout,
  }) async {
    await sendKeyDownEvent(key);
    await pump(longPressDuration);
    await sendKeyUpEvent(key);
    await pumpAndSettle();
  }
}
