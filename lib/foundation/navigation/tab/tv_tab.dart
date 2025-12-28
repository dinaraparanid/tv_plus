import 'package:flutter/widgets.dart';
import 'package:tv_plus/foundation/foundation.dart';

const double _kTabHeight = 46.0;
const double _kTextAndIconTabHeight = 72.0;

final class TvTab extends StatelessWidget implements PreferredSizeWidget {
  const TvTab({
    super.key,
    this.text,
    this.icon,
    this.iconMargin = EdgeInsets.zero,
    this.height,
    this.child,
    this.focusNode,
    this.parentNode,
    this.autofocus = false,
    this.canRequestFocus = true,
    this.viewportAlignment = 0.5,
    this.leftHandler,
    this.rightHandler,
    this.onSelect,
    this.onBack,
    this.onFocusChanged,
    this.onFocusDisabledWhenWasFocused,
    this.scrollToNextNodeDuration,
  });

  final String? text;
  final Widget? child;
  final Widget? icon;
  final EdgeInsetsGeometry iconMargin;
  final double? height;
  final FocusNode? focusNode;
  final FocusNode? parentNode;
  final bool autofocus;
  final bool canRequestFocus;
  final double? viewportAlignment;
  final ScrollGroupDpadEventHandler? leftHandler;
  final ScrollGroupDpadEventHandler? rightHandler;
  final DpadEventCallback? onSelect;
  final DpadEventCallback? onBack;
  final void Function(FocusNode)? onFocusChanged;
  final void Function()? onFocusDisabledWhenWasFocused;
  final Duration? scrollToNextNodeDuration;

  Widget _buildLabelText() {
    return child ?? Text(text!, softWrap: false, overflow: TextOverflow.fade);
  }

  Widget _buildTab() {
    final double calculatedHeight;
    final Widget label;

    if (icon == null) {
      calculatedHeight = _kTabHeight;
      label = _buildLabelText();
    } else if (text == null && child == null) {
      calculatedHeight = _kTabHeight;
      label = icon!;
    } else {
      calculatedHeight = _kTextAndIconTabHeight;

      label = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: iconMargin, child: icon),
          _buildLabelText(),
        ],
      );
    }

    return SizedBox(
      height: height ?? calculatedHeight,
      child: Center(widthFactor: 1.0, child: label),
    );
  }

  @override
  Size get preferredSize {
    if (height != null) {
      return Size.fromHeight(height!);
    } else if ((text != null || child != null) && icon != null) {
      return const Size.fromHeight(_kTextAndIconTabHeight);
    } else {
      return const Size.fromHeight(_kTabHeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollGroupDpadFocus(
      focusNode: focusNode,
      parentNode: parentNode,
      autofocus: autofocus,
      canRequestFocus: canRequestFocus,
      viewportAlignment: viewportAlignment,
      leftHandler: leftHandler,
      rightHandler: rightHandler,
      onSelect: onSelect,
      onBack: onBack,
      onFocusChanged: onFocusChanged,
      onFocusDisabledWhenWasFocused: onFocusDisabledWhenWasFocused,
      scrollToNextNodeDuration: scrollToNextNodeDuration,
      builder: (focusNode) => _buildTab(),
    );
  }
}
