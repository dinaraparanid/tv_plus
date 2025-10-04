import 'package:flutter/material.dart';
import 'package:tv_plus/tv_plus.dart';

final class SampleDpadFocus extends StatefulWidget {
  const SampleDpadFocus({
    super.key,
    this.isEnabled = true,
    this.autofocus = false,
    this.focusNode,
    this.onUp,
    this.onDown,
    this.onLeft,
    this.onRight,
    this.onSelect,
    this.onBack,
    this.onFocusChanged,
    this.onFocusDisabledWhenWasFocused,
    this.child,
  });

  final bool isEnabled;
  final bool autofocus;
  final FocusNode? focusNode;
  final DpadEventCallback? onUp;
  final DpadEventCallback? onDown;
  final DpadEventCallback? onLeft;
  final DpadEventCallback? onRight;
  final DpadEventCallback? onSelect;
  final DpadEventCallback? onBack;
  final void Function(FocusNode)? onFocusChanged;
  final void Function()? onFocusDisabledWhenWasFocused;
  final Widget? child;

  @override
  State<StatefulWidget> createState() => _SampleDpadFocusState();
}

final class _SampleDpadFocusState extends State<SampleDpadFocus> {
  static const textEnabled = 'enabled';
  static const textDisabled = 'disabled';
  static const textFocused = 'focused';

  static const colorEnabled = Colors.indigoAccent;
  static const colorDisabled = Colors.blueGrey;
  static const colorFocused = Colors.green;

  late final FocusNode _focusNode;
  bool ownsFocusNode = true;

  String text = textEnabled;
  Color color = colorEnabled;

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    ownsFocusNode = widget.focusNode == null;

    if (widget.autofocus) {
      _focusNode.requestFocus();
      text = textFocused;
      color = colorFocused;
    } else if (!widget.isEnabled) {
      text = textDisabled;
      color = colorDisabled;
    }

    _focusNode.addListener(onFocusChange);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant SampleDpadFocus oldWidget) {
    if (widget.isEnabled != oldWidget.isEnabled) {
      onFocusChange();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _focusNode.removeListener(onFocusChange);
    if (ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  void onFocusChange() {
    setState(() {
      if (_focusNode.hasFocus) {
        text = textFocused;
        color = colorFocused;
        return;
      }

      text = widget.isEnabled ? textEnabled : textDisabled;
      color = widget.isEnabled ? colorEnabled : colorDisabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DpadFocus(
      focusNode: _focusNode,
      canRequestFocus: widget.isEnabled,
      autofocus: widget.autofocus,
      onUp: widget.onUp,
      onDown: widget.onDown,
      onLeft: widget.onLeft,
      onRight: widget.onRight,
      onSelect: widget.onSelect,
      onBack: widget.onBack,
      onFocusDisabledWhenWasFocused: widget.onFocusDisabledWhenWasFocused,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
        ),
        child: Align(child: widget.child ?? Text(text)),
      ),
    );
  }
}
