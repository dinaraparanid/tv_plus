part of 'dpad.dart';

mixin DpadEvents {
  KeyEventResult onUpEvent(FocusNode node, KeyDownEvent event) =>
      KeyEventResult.ignored;
  KeyEventResult onDownEvent(FocusNode node, KeyDownEvent event) =>
      KeyEventResult.ignored;
  KeyEventResult onLeftEvent(FocusNode node, KeyDownEvent event) =>
      KeyEventResult.ignored;
  KeyEventResult onRightEvent(FocusNode node, KeyDownEvent event) =>
      KeyEventResult.ignored;
  KeyEventResult onSelectEvent(FocusNode node, KeyDownEvent event) =>
      KeyEventResult.ignored;
  KeyEventResult onBackEvent(FocusNode node, KeyDownEvent event) =>
      KeyEventResult.ignored;
}
