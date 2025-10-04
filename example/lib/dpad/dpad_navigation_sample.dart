import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tv_plus_example/dpad/sample_dpad_focus.dart';

final class DpadNavigationSample extends StatefulWidget {
  const DpadNavigationSample({super.key});

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

  late final Timer reverseTimer;

  @override
  void initState() {
    reverseTimer = Timer.periodic(Duration(seconds: 5), (_) {
      setState(() => isOddFocusable = !isOddFocusable);
    });

    super.initState();
  }

  @override
  void dispose() {
    reverseTimer.cancel();

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
    return Stack(
      children: [
        Align(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 400,
                child: SampleDpadFocus(
                  focusNode: onlyFromCenterFn,
                  onDown: (_, _) {
                    fn5.requestFocus();
                    return KeyEventResult.handled;
                  },
                  onSelect: (_, _) {
                    fn5.requestFocus();
                    return KeyEventResult.handled;
                  },
                  child: Text('Focusable only from center (fn5)'),
                ),
              ),

              SizedBox(height: 12),

              // | * | $ | * |
              // | $ | * | $ |
              // | * | $ | * |

              SizedBox.square(
                dimension: 400,
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    // ----- row 1 -----
                    SampleDpadFocus(
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

              SizedBox(height: 12),

              SizedBox(
                width: 400,
                child: SampleDpadFocus(
                  focusNode: reverseFn,
                  onSelect: (_, _) {
                    setState(() => isOddFocusable = !isOddFocusable);

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      fn5.requestFocus();
                    });

                    return KeyEventResult.handled;
                  },
                  child: Text('Reverse grid'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}