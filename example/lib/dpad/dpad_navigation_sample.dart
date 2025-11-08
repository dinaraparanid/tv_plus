import 'dart:async';

import 'package:flutter/material.dart';
import 'sample_dpad_focus.dart';

final class DpadNavigationSample extends StatefulWidget {
  const DpadNavigationSample({super.key, this.isReverseTimerEnabled = true});

  static const keyOnlyFromCenterButton = ValueKey('only_from_center');
  static const keyF1 = ValueKey('f1');
  static const keyF2 = ValueKey('f2');
  static const keyF3 = ValueKey('f3');
  static const keyF4 = ValueKey('f4');
  static const keyF5 = ValueKey('f5');
  static const keyF6 = ValueKey('f6');
  static const keyF7 = ValueKey('f7');
  static const keyF8 = ValueKey('f8');
  static const keyF9 = ValueKey('f9');
  static const keyReverseButton = ValueKey('reverse');

  final bool isReverseTimerEnabled;

  @override
  State<StatefulWidget> createState() => _DpadNavigationSampleState();
}

final class _DpadNavigationSampleState extends State<DpadNavigationSample> {
  late final fn1 = FocusNode();
  late final fn2 = FocusNode();
  late final fn3 = FocusNode();
  late final fn4 = FocusNode();
  late final fn5 = FocusNode();
  late final fn6 = FocusNode();
  late final fn7 = FocusNode();
  late final fn8 = FocusNode();
  late final fn9 = FocusNode();
  late final onlyFromCenterFn = FocusNode();
  late final reverseFn = FocusNode();

  var isOddFocusable = true;

  late final Timer? reverseTimer;

  @override
  void initState() {
    reverseTimer = widget.isReverseTimerEnabled
        ? Timer.periodic(
            const Duration(seconds: 5),
            (_) => setState(() => isOddFocusable = !isOddFocusable),
          )
        : null;

    super.initState();
  }

  @override
  void dispose() {
    reverseTimer?.cancel();

    fn1.dispose();
    fn2.dispose();
    fn3.dispose();
    fn4.dispose();
    fn5.dispose();
    fn6.dispose();
    fn7.dispose();
    fn8.dispose();
    fn9.dispose();
    onlyFromCenterFn.dispose();
    reverseFn.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, _) {
        return Stack(
          children: [
            Align(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ( only from center )
                  //
                  //    | * | $ | * |
                  //    | $ | * | $ |
                  //    | * | $ | * |
                  //
                  // ( reverse buttons )
                  SizedBox(
                    width: 400,
                    child: SampleDpadFocus(
                      key: DpadNavigationSample.keyOnlyFromCenterButton,
                      focusNode: onlyFromCenterFn,
                      onDown: (_, _) {
                        fn5.requestFocus();
                        return KeyEventResult.handled;
                      },
                      onSelect: (_, _) {
                        fn5.requestFocus();
                        return KeyEventResult.handled;
                      },
                      child: const Text('Focusable only from center (fn5)'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox.square(
                    dimension: 400,
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: [
                        // ----- row 1 -----
                        SampleDpadFocus(
                          key: DpadNavigationSample.keyF1,
                          isEnabled: isOddFocusable,
                          autofocus: true,
                          focusNode: fn1,
                          onUp: (_, _) => KeyEventResult.handled,
                          onDown: (_, _) {
                            fn7.requestFocus();
                            return KeyEventResult.handled;
                          },
                          onLeft: (_, _) => KeyEventResult.handled,
                          onRight: (_, _) {
                            fn3.requestFocus();
                            return KeyEventResult.handled;
                          },
                          onFocusDisabledWhenWasFocused: () {
                            reverseFn.requestFocus();
                          },
                        ),
                        SampleDpadFocus(
                          key: DpadNavigationSample.keyF2,
                          isEnabled: !isOddFocusable,
                          focusNode: fn2,
                          onUp: (_, _) => KeyEventResult.handled,
                          onDown: (_, _) {
                            fn8.requestFocus();
                            return KeyEventResult.handled;
                          },
                          onLeft: (_, _) => KeyEventResult.handled,
                          onRight: (_, _) => KeyEventResult.handled,
                          onFocusDisabledWhenWasFocused: () {
                            reverseFn.requestFocus();
                          },
                        ),
                        SampleDpadFocus(
                          key: DpadNavigationSample.keyF3,
                          isEnabled: isOddFocusable,
                          focusNode: fn3,
                          onUp: (_, _) => KeyEventResult.handled,
                          onDown: (_, _) {
                            fn9.requestFocus();
                            return KeyEventResult.handled;
                          },
                          onLeft: (_, _) {
                            fn1.requestFocus();
                            return KeyEventResult.handled;
                          },
                          onRight: (_, _) => KeyEventResult.handled,
                          onFocusDisabledWhenWasFocused: () {
                            reverseFn.requestFocus();
                          },
                        ),

                        // ----- row 2 -----
                        SampleDpadFocus(
                          key: DpadNavigationSample.keyF4,
                          isEnabled: !isOddFocusable,
                          focusNode: fn4,
                          onUp: (_, _) => KeyEventResult.handled,
                          onDown: (_, _) => KeyEventResult.handled,
                          onLeft: (_, _) => KeyEventResult.handled,
                          onRight: (_, _) {
                            fn6.requestFocus();
                            return KeyEventResult.handled;
                          },
                          onFocusDisabledWhenWasFocused: () {
                            reverseFn.requestFocus();
                          },
                        ),
                        SampleDpadFocus(
                          key: DpadNavigationSample.keyF5,
                          isEnabled: isOddFocusable,
                          focusNode: fn5,
                          onUp: (_, _) {
                            onlyFromCenterFn.requestFocus();
                            return KeyEventResult.handled;
                          },
                          onDown: (_, _) {
                            reverseFn.requestFocus();
                            return KeyEventResult.handled;
                          },
                          onLeft: (_, _) => KeyEventResult.handled,
                          onRight: (_, _) => KeyEventResult.handled,
                          onFocusDisabledWhenWasFocused: () {
                            reverseFn.requestFocus();
                          },
                        ),
                        SampleDpadFocus(
                          key: DpadNavigationSample.keyF6,
                          isEnabled: !isOddFocusable,
                          focusNode: fn6,
                          onUp: (_, _) => KeyEventResult.handled,
                          onDown: (_, _) => KeyEventResult.handled,
                          onLeft: (_, _) {
                            fn4.requestFocus();
                            return KeyEventResult.handled;
                          },
                          onRight: (_, _) => KeyEventResult.handled,
                          onFocusDisabledWhenWasFocused: () {
                            reverseFn.requestFocus();
                          },
                        ),

                        // ----- row 3 -----
                        SampleDpadFocus(
                          key: DpadNavigationSample.keyF7,
                          isEnabled: isOddFocusable,
                          focusNode: fn7,
                          onUp: (_, _) {
                            fn1.requestFocus();
                            return KeyEventResult.handled;
                          },
                          onDown: (_, _) {
                            reverseFn.requestFocus();
                            return KeyEventResult.handled;
                          },
                          onLeft: (_, _) => KeyEventResult.handled,
                          onRight: (_, _) {
                            fn9.requestFocus();
                            return KeyEventResult.handled;
                          },
                          onFocusDisabledWhenWasFocused: () {
                            reverseFn.requestFocus();
                          },
                        ),
                        SampleDpadFocus(
                          key: DpadNavigationSample.keyF8,
                          isEnabled: !isOddFocusable,
                          focusNode: fn8,
                          onUp: (_, _) {
                            fn2.requestFocus();
                            return KeyEventResult.handled;
                          },
                          onDown: (_, _) {
                            reverseFn.requestFocus();
                            return KeyEventResult.handled;
                          },
                          onLeft: (_, _) => KeyEventResult.handled,
                          onRight: (_, _) => KeyEventResult.handled,
                          onFocusDisabledWhenWasFocused: () {
                            reverseFn.requestFocus();
                          },
                        ),
                        SampleDpadFocus(
                          key: DpadNavigationSample.keyF9,
                          isEnabled: isOddFocusable,
                          focusNode: fn9,
                          onUp: (_, _) {
                            fn3.requestFocus();
                            return KeyEventResult.handled;
                          },
                          onDown: (_, _) {
                            reverseFn.requestFocus();
                            return KeyEventResult.handled;
                          },
                          onLeft: (_, _) {
                            fn7.requestFocus();
                            return KeyEventResult.handled;
                          },
                          onRight: (_, _) => KeyEventResult.handled,
                          onFocusDisabledWhenWasFocused: () {
                            reverseFn.requestFocus();
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: 400,
                    child: SampleDpadFocus(
                      key: DpadNavigationSample.keyReverseButton,
                      focusNode: reverseFn,
                      onSelect: (_, _) {
                        setState(() => isOddFocusable = !isOddFocusable);

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          fn5.requestFocus();
                        });

                        return KeyEventResult.handled;
                      },
                      child: const Text('Reverse grid'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
