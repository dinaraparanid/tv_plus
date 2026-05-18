import 'package:flutter/material.dart';
import 'package:tv_plus_foundation/tv_plus_foundation.dart';
import 'package:tv_plus_sandstone/src/modal/alert/alert.dart';

final class SandstoneOverlayAlertSample extends StatelessWidget {
  const SandstoneOverlayAlertSample({super.key});

  static const backgroundColor = Color(0xFF131314);
  static const alertBackgroundColor = Color(0xFFC1C1C1);
  static const alertContentColor = Color(0xFF2E3239);
  static const alertButtonBackgroundColor = Color(0xFF7D848C);
  static const alertButtonContentColor = Color(0xFFE6E6E6);
  static const contentAnimationDuration = Duration(milliseconds: 100);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: SandstoneOverlayAlertSample.backgroundColor,
        body: Stack(children: [Align(child: _AlertTriggerButton())]),
      ),
    );
  }
}

final class _AlertTriggerButton extends StatelessWidget {
  const _AlertTriggerButton();

  @override
  Widget build(BuildContext context) {
    return DpadFocus(
      autofocus: true,
      onSelect: (_, _) {
        SandstoneAlert.show(
          context: context,
          type: SandstoneAlertType.overlay,
          builder: (context, scopeNode) => const Padding(
            padding: EdgeInsets.only(bottom: 32, left: 64, right: 64),
            child: _AlertContent(),
          ),
        );

        return KeyEventResult.handled;
      },
      builder: (context, _) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text('Trigger Alert'),
      ),
    );
  }
}

final class _AlertContent extends StatelessWidget {
  const _AlertContent();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SandstoneOverlayAlertSample.alertBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(blurRadius: 16)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 32,
          children: [
            const Icon(
              Icons.info,
              size: 48,
              color: SandstoneOverlayAlertSample.alertContentColor,
            ),

            const SizedBox(
              width: 256,
              child: Text(
                'Sandstone overlay alert',
                style: TextStyle(
                  fontSize: 18,
                  color: SandstoneOverlayAlertSample.alertContentColor,
                ),
              ),
            ),

            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                _AlertButton(
                  text: 'Button 1',
                  autofocus: true,
                  onSelect: () => SandstoneAlert.hide(context),
                ),
                _AlertButton(
                  text: 'Button 2',
                  onSelect: () => SandstoneAlert.hide(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final class _AlertButton extends StatelessWidget {
  const _AlertButton({
    required this.text,
    this.autofocus = false,
    required this.onSelect,
  });

  final String text;
  final bool autofocus;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return DpadFocus(
      autofocus: autofocus,
      onSelect: (_, _) {
        onSelect();
        return KeyEventResult.handled;
      },
      builder: (context, node) => AnimatedScale(
        duration: SandstoneOverlayAlertSample.contentAnimationDuration,
        scale: node.hasFocus ? 1.1 : 1,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: SandstoneOverlayAlertSample.alertButtonBackgroundColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              color: SandstoneOverlayAlertSample.alertButtonContentColor,
            ),
          ),
        ),
      ),
    );
  }
}
