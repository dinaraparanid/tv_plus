import 'package:flutter/material.dart';
import 'package:tv_plus_foundation/tv_plus_foundation.dart';
import 'package:tv_plus_sandstone/src/modal/alert/alert.dart';

final class SandstoneFullscreenAlertSample extends StatelessWidget {
  const SandstoneFullscreenAlertSample({super.key});

  static const backgroundColor = Color(0xFF131314);
  static const alertBackgroundColor = Color(0xFF000000);
  static const alertContentColor = Color(0xFFE6E6E6);
  static const alertButtonBackgroundColor = Color(0xFF7D848C);
  static const contentAnimationDuration = Duration(milliseconds: 100);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: SandstoneFullscreenAlertSample.backgroundColor,
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
          type: SandstoneAlertType.fullscreen,
          builder: (context, scopeNode) => const _AlertContent(),
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
      child: ColoredBox(
        color: SandstoneFullscreenAlertSample.alertBackgroundColor,
        child: Stack(
          children: [
            Align(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 32,
                children: [
                  const Icon(
                    Icons.info,
                    size: 48,
                    color: SandstoneFullscreenAlertSample.alertContentColor,
                  ),

                  const SizedBox(
                    width: 512,
                    child: Text(
                      'Sandstone Fullscreen Alert Title',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        color: SandstoneFullscreenAlertSample.alertContentColor,
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 512,
                    child: Text(
                      'Sandstone Fullscreen Alert Description with a lot of'
                      ' text lorem ipsum dolor sit amet consectetur'
                      ' adipiscing elit sed do eiusmod tempor incididunt ut'
                      ' labore et dolore magna aliqua',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        color: SandstoneFullscreenAlertSample.alertContentColor,
                      ),
                    ),
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
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
        duration: SandstoneFullscreenAlertSample.contentAnimationDuration,
        scale: node.hasFocus ? 1.1 : 1,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: SandstoneFullscreenAlertSample.alertButtonBackgroundColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              color: SandstoneFullscreenAlertSample.alertContentColor,
            ),
          ),
        ),
      ),
    );
  }
}
