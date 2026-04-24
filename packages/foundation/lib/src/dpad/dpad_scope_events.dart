part of 'dpad.dart';

mixin DpadScopeEvents {
  KeyEventResult onUpEvent(
    FocusNode node,
    KeyUpEvent event,
    bool isOutOfScope,
  ) => KeyEventResult.ignored;
  KeyEventResult onDownEvent(
    FocusNode node,
    KeyUpEvent event,
    bool isOutOfScope,
  ) => KeyEventResult.ignored;
  KeyEventResult onLeftEvent(
    FocusNode node,
    KeyUpEvent event,
    bool isOutOfScope,
  ) => KeyEventResult.ignored;
  KeyEventResult onRightEvent(
    FocusNode node,
    KeyUpEvent event,
    bool isOutOfScope,
  ) => KeyEventResult.ignored;
  KeyEventResult onSelectEvent(FocusNode node, KeyUpEvent event) =>
      KeyEventResult.ignored;
  KeyEventResult onBackEvent(FocusNode node, KeyUpEvent event) =>
      KeyEventResult.ignored;
}
