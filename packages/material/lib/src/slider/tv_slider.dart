part of 'slider.dart';

final class TvSlider extends StatefulWidget {
  const TvSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.step,
    this.divisions,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.secondaryActiveColor,
    this.thumbColor,
    this.overlayColor,
    this.mouseCursor,
    this.semanticFormatterCallback,
    this.allowedInteraction,
    this.padding,
    this.showValueIndicator,
    this.focusNode,
    this.parentNode,
    this.autofocus = false,
    this.canRequestFocus = true,
    this.skipTraversal,
    this.rebuildOnFocusChange = true,
    this.onUp,
    this.onDown,
    this.onLeft,
    this.onRight,
    this.onSelect,
    this.onBack,
    this.onKeyEvent,
    this.onFocusChanged,
    this.onFocusDisabledWhenWasFocused,
  }) : assert(step == null || step > 0.0, 'step must be positive');

  final double value;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final double min;
  final double max;
  final double? step;
  final int? divisions;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? secondaryActiveColor;
  final Color? thumbColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final MouseCursor? mouseCursor;
  final SemanticFormatterCallback? semanticFormatterCallback;
  final SliderInteraction? allowedInteraction;
  final EdgeInsetsGeometry? padding;
  final ShowValueIndicator? showValueIndicator;

  final FocusNode? focusNode;
  final FocusNode? parentNode;
  final bool autofocus;
  final bool canRequestFocus;
  final bool? skipTraversal;
  final bool rebuildOnFocusChange;
  final DpadEventCallback? onUp;
  final DpadEventCallback? onDown;
  final DpadEventCallback? onLeft;
  final DpadEventCallback? onRight;
  final DpadEventCallback? onSelect;
  final DpadEventCallback? onBack;
  final KeyEventResult Function(FocusNode, KeyEvent)? onKeyEvent;
  final void Function(FocusNode, bool)? onFocusChanged;
  final void Function()? onFocusDisabledWhenWasFocused;

  @override
  State<StatefulWidget> createState() => _TvSliderState();
}

final class _TvSliderState extends State<TvSlider> with DpadEvents {
  late var _value = widget.value;
  late var _showValueIndicator = widget.showValueIndicator;

  late var _focusNode = widget.focusNode ?? FocusNode();
  late var _ownsFocusNode = widget.focusNode == null;

  @override
  void initState() {
    _focusNode.addListener(_focusListener);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TvSlider oldWidget) {
    final passedNode = widget.focusNode;

    if (passedNode != null && passedNode != oldWidget.focusNode) {
      _focusNode.removeListener(_focusListener);

      if (_ownsFocusNode) {
        _focusNode.dispose();
      }

      _focusNode = passedNode..addListener(_focusListener);
      _ownsFocusNode = false;
    }

    super.didUpdateWidget(oldWidget);
  }

  void _focusListener() {
    setState(() {
      _showValueIndicator = _focusNode.hasFocus
          ? ShowValueIndicator.alwaysVisible
          : widget.showValueIndicator;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusListener);

    if (_ownsFocusNode) {
      _focusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DpadFocus(
      focusNode: widget.focusNode,
      parentNode: widget.parentNode,
      autofocus: widget.autofocus,
      canRequestFocus: widget.canRequestFocus,
      skipTraversal: widget.skipTraversal,
      rebuildOnFocusChange: widget.rebuildOnFocusChange,
      onUp: onUpEvent,
      onDown: onDownEvent,
      onLeft: onLeftEvent,
      onRight: onRightEvent,
      onSelect: widget.onSelect,
      onBack: widget.onBack,
      onKeyEvent: widget.onKeyEvent,
      onFocusChanged: widget.onFocusChanged,
      onFocusDisabledWhenWasFocused: widget.onFocusDisabledWhenWasFocused,
      builder: (context, _) => Slider(
        value: widget.value,
        onChanged: _onChanged,
        onChangeStart: widget.onChangeStart,
        onChangeEnd: widget.onChangeEnd,
        min: widget.min,
        max: widget.max,
        divisions: widget.divisions,
        label: widget.label,
        activeColor: widget.activeColor,
        inactiveColor: widget.inactiveColor,
        secondaryActiveColor: widget.secondaryActiveColor,
        thumbColor: widget.thumbColor,
        overlayColor: widget.overlayColor,
        mouseCursor: widget.mouseCursor,
        semanticFormatterCallback: widget.semanticFormatterCallback,
        allowedInteraction: widget.allowedInteraction,
        padding: widget.padding,
        showValueIndicator: _showValueIndicator,
      ),
    );
  }

  @override
  KeyEventResult onUpEvent(FocusNode node, KeyDownEvent event) {
    if (widget.onUp != null) {
      return widget.onUp!(node, event);
    }

    final handled = _adjustValue(increase: true);
    return handled ? KeyEventResult.handled : KeyEventResult.ignored;
  }

  @override
  KeyEventResult onDownEvent(FocusNode node, KeyDownEvent event) {
    if (widget.onDown != null) {
      return widget.onDown!(node, event);
    }

    final handled = _adjustValue(increase: false);
    return handled ? KeyEventResult.handled : KeyEventResult.ignored;
  }

  @override
  KeyEventResult onLeftEvent(FocusNode node, KeyDownEvent event) {
    if (widget.onLeft != null) {
      return widget.onLeft!(node, event);
    }

    final handled = _adjustValue(increase: false);
    return handled ? KeyEventResult.handled : KeyEventResult.ignored;
  }

  @override
  KeyEventResult onRightEvent(FocusNode node, KeyDownEvent event) {
    if (widget.onRight != null) {
      return widget.onRight!(node, event);
    }

    final handled = _adjustValue(increase: true);
    return handled ? KeyEventResult.handled : KeyEventResult.ignored;
  }

  void _onChanged(double value) {
    _value = value;

    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }

    widget.onChanged?.call(value);
  }

  bool _adjustValue({required bool increase}) {
    final range = widget.max - widget.min;
    final div = widget.divisions;

    final step = div != null ? range / div : (widget.step ?? range / 100);

    final nextValue = (_value + (increase ? step : -step)).clamp(
      widget.min,
      widget.max,
    );

    if (nextValue == _value) {
      return false;
    }

    _onChanged(nextValue);
    return true;
  }
}
