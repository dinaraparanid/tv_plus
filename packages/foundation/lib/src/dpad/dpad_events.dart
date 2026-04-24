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
  KeyEventResult onSelectEvent(FocusNode node, KeyEvent event) =>
      KeyEventResult.ignored;
  KeyEventResult onBackEvent(FocusNode node, KeyEvent event) =>
      KeyEventResult.ignored;
}
