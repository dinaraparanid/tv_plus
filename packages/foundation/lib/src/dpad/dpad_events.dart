part of 'dpad.dart';

mixin DpadEvents {
  KeyEventResult onUpEvent(FocusNode node, KeyEvent event) =>
      KeyEventResult.ignored;
  KeyEventResult onDownEvent(FocusNode node, KeyEvent event) =>
      KeyEventResult.ignored;
  KeyEventResult onLeftEvent(FocusNode node, KeyEvent event) =>
      KeyEventResult.ignored;
  KeyEventResult onRightEvent(FocusNode node, KeyEvent event) =>
      KeyEventResult.ignored;
  KeyEventResult onSelectStartEvent(FocusNode node, KeyEvent event) =>
      KeyEventResult.ignored;
  KeyEventResult onSelectEndEvent(FocusNode node, KeyEvent event) =>
      KeyEventResult.ignored;
  KeyEventResult onBackEvent(FocusNode node, KeyEvent event) =>
      KeyEventResult.ignored;
}
