import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

mixin DpadScopeEvents {
  KeyEventResult onUpEvent(
    FocusNode node,
    KeyDownEvent event,
    bool isOutOfScope,
  ) => KeyEventResult.ignored;
  KeyEventResult onDownEvent(
    FocusNode node,
    KeyDownEvent event,
    bool isOutOfScope,
  ) => KeyEventResult.ignored;
  KeyEventResult onLeftEvent(
    FocusNode node,
    KeyDownEvent event,
    bool isOutOfScope,
  ) => KeyEventResult.ignored;
  KeyEventResult onRightEvent(
    FocusNode node,
    KeyDownEvent event,
    bool isOutOfScope,
  ) => KeyEventResult.ignored;
  KeyEventResult onSelectEvent(FocusNode node, KeyDownEvent event) =>
      KeyEventResult.ignored;
  KeyEventResult onBackEvent(FocusNode node, KeyDownEvent event) =>
      KeyEventResult.ignored;
}
