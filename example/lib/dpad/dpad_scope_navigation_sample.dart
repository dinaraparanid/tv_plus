import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tv_plus/tv_plus.dart';
import 'sample_dpad_focus.dart';

final class DpadScopeNavigationSample extends StatefulWidget {
  const DpadScopeNavigationSample({
    super.key,
    this.isReverseTimerEnabled = false,
    this.isTraverseTimerEnabled = false,
  });

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

  static const timerDelay = Duration(seconds: 1);

  final bool isReverseTimerEnabled;
  final bool isTraverseTimerEnabled;

  @override
  State<StatefulWidget> createState() => _DpadScopeNavigationSampleState();
}

final class _DpadScopeNavigationSampleState
    extends State<DpadScopeNavigationSample> {
  late final _focusScopeNode = FocusScopeNode();
  late final _focusNodes = List.generate(9, (_) => FocusNode());
  late final _onlyFromCenterFn = FocusNode();
  late final _reverseFn = FocusNode();

  var _isOddFocusable = true;

  late final Timer? _reverseTimer;
  late final Timer? _traverseTimer;

  @override
  void initState() {
    _reverseTimer = widget.isReverseTimerEnabled
        ? Timer.periodic(
            DpadScopeNavigationSample.timerDelay,
            (_) => setState(() => _isOddFocusable = !_isOddFocusable),
          )
        : null;

    _traverseTimer = widget.isTraverseTimerEnabled
        ? Timer.periodic(DpadScopeNavigationSample.timerDelay, (_) {
            if (!_focusScopeNode.nextFocus()) {
              _focusScopeNode.traversalChildren.first.requestFocus();
            }
          })
        : null;

    super.initState();
  }

  @override
  void dispose() {
    _reverseTimer?.cancel();
    _traverseTimer?.cancel();

    for (final node in _focusNodes) {
      node.dispose();
    }

    _focusScopeNode.dispose();
    _onlyFromCenterFn.dispose();
    _reverseFn.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
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
                        key: DpadScopeNavigationSample.keyOnlyFromCenterButton,
                        focusNode: _onlyFromCenterFn,
                        onDown: (_, _) {
                          _focusNodes[4].requestFocus();
                          return KeyEventResult.handled;
                        },
                        onSelect: (_, _) {
                          _focusNodes[4].requestFocus();
                          return KeyEventResult.handled;
                        },
                        child: const Text('Focusable only from center (fn5)'),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox.square(
                      dimension: 400,
                      child: DpadFocusScope(
                        focusScopeNode: _focusScopeNode,
                        policy: ReadingOrderTraversalPolicy(),
                        builder: (_, _) => GridView.count(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          children: [
                            // ----- row 1 -----
                            SampleDpadFocus(
                              key: DpadScopeNavigationSample.keyF1,
                              isEnabled: _isOddFocusable,
                              autofocus: true,
                              focusNode: _focusNodes[0],
                              onUp: (_, _) => KeyEventResult.handled,
                              onDown: (_, _) {
                                _focusNodes[6].requestFocus();
                                return KeyEventResult.handled;
                              },
                              onLeft: (_, _) => KeyEventResult.handled,
                              onRight: (_, _) {
                                _focusNodes[2].requestFocus();
                                return KeyEventResult.handled;
                              },
                              onFocusDisabledWhenWasFocused: () {
                                _reverseFn.requestFocus();
                              },
                            ),
                            SampleDpadFocus(
                              key: DpadScopeNavigationSample.keyF2,
                              isEnabled: !_isOddFocusable,
                              focusNode: _focusNodes[1],
                              onUp: (_, _) => KeyEventResult.handled,
                              onDown: (_, _) {
                                _focusNodes[7].requestFocus();
                                return KeyEventResult.handled;
                              },
                              onLeft: (_, _) => KeyEventResult.handled,
                              onRight: (_, _) => KeyEventResult.handled,
                              onFocusDisabledWhenWasFocused: () {
                                _reverseFn.requestFocus();
                              },
                            ),
                            SampleDpadFocus(
                              key: DpadScopeNavigationSample.keyF3,
                              isEnabled: _isOddFocusable,
                              focusNode: _focusNodes[2],
                              onUp: (_, _) => KeyEventResult.handled,
                              onDown: (_, _) {
                                _focusNodes[8].requestFocus();
                                return KeyEventResult.handled;
                              },
                              onLeft: (_, _) {
                                _focusNodes[0].requestFocus();
                                return KeyEventResult.handled;
                              },
                              onRight: (_, _) => KeyEventResult.handled,
                              onFocusDisabledWhenWasFocused: () {
                                _reverseFn.requestFocus();
                              },
                            ),

                            // ----- row 2 -----
                            SampleDpadFocus(
                              key: DpadScopeNavigationSample.keyF4,
                              isEnabled: !_isOddFocusable,
                              focusNode: _focusNodes[3],
                              onUp: (_, _) => KeyEventResult.handled,
                              onDown: (_, _) => KeyEventResult.handled,
                              onLeft: (_, _) => KeyEventResult.handled,
                              onRight: (_, _) {
                                _focusNodes[5].requestFocus();
                                return KeyEventResult.handled;
                              },
                              onFocusDisabledWhenWasFocused: () {
                                _reverseFn.requestFocus();
                              },
                            ),
                            SampleDpadFocus(
                              key: DpadScopeNavigationSample.keyF5,
                              isEnabled: _isOddFocusable,
                              focusNode: _focusNodes[4],
                              onUp: (_, _) {
                                _onlyFromCenterFn.requestFocus();
                                return KeyEventResult.handled;
                              },
                              onDown: (_, _) {
                                _reverseFn.requestFocus();
                                return KeyEventResult.handled;
                              },
                              onLeft: (_, _) => KeyEventResult.handled,
                              onRight: (_, _) => KeyEventResult.handled,
                              onFocusDisabledWhenWasFocused: () {
                                _reverseFn.requestFocus();
                              },
                            ),
                            SampleDpadFocus(
                              key: DpadScopeNavigationSample.keyF6,
                              isEnabled: !_isOddFocusable,
                              focusNode: _focusNodes[5],
                              onUp: (_, _) => KeyEventResult.handled,
                              onDown: (_, _) => KeyEventResult.handled,
                              onLeft: (_, _) {
                                _focusNodes[3].requestFocus();
                                return KeyEventResult.handled;
                              },
                              onRight: (_, _) => KeyEventResult.handled,
                              onFocusDisabledWhenWasFocused: () {
                                _reverseFn.requestFocus();
                              },
                            ),

                            // ----- row 3 -----
                            SampleDpadFocus(
                              key: DpadScopeNavigationSample.keyF7,
                              isEnabled: _isOddFocusable,
                              focusNode: _focusNodes[6],
                              onUp: (_, _) {
                                _focusNodes[0].requestFocus();
                                return KeyEventResult.handled;
                              },
                              onDown: (_, _) {
                                _reverseFn.requestFocus();
                                return KeyEventResult.handled;
                              },
                              onLeft: (_, _) => KeyEventResult.handled,
                              onRight: (_, _) {
                                _focusNodes[8].requestFocus();
                                return KeyEventResult.handled;
                              },
                              onFocusDisabledWhenWasFocused: () {
                                _reverseFn.requestFocus();
                              },
                            ),
                            SampleDpadFocus(
                              key: DpadScopeNavigationSample.keyF8,
                              isEnabled: !_isOddFocusable,
                              focusNode: _focusNodes[7],
                              onUp: (_, _) {
                                _focusNodes[1].requestFocus();
                                return KeyEventResult.handled;
                              },
                              onDown: (_, _) {
                                _reverseFn.requestFocus();
                                return KeyEventResult.handled;
                              },
                              onLeft: (_, _) => KeyEventResult.handled,
                              onRight: (_, _) => KeyEventResult.handled,
                              onFocusDisabledWhenWasFocused: () {
                                _reverseFn.requestFocus();
                              },
                            ),
                            SampleDpadFocus(
                              key: DpadScopeNavigationSample.keyF9,
                              isEnabled: _isOddFocusable,
                              focusNode: _focusNodes[8],
                              onUp: (_, _) {
                                _focusNodes[2].requestFocus();
                                return KeyEventResult.handled;
                              },
                              onDown: (_, _) {
                                _reverseFn.requestFocus();
                                return KeyEventResult.handled;
                              },
                              onLeft: (_, _) {
                                _focusNodes[6].requestFocus();
                                return KeyEventResult.handled;
                              },
                              onRight: (_, _) => KeyEventResult.handled,
                              onFocusDisabledWhenWasFocused: () {
                                _reverseFn.requestFocus();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: 400,
                      child: SampleDpadFocus(
                        key: DpadScopeNavigationSample.keyReverseButton,
                        focusNode: _reverseFn,
                        onUp: (_, _) {
                          _focusScopeNode.requestFocus();
                          return KeyEventResult.handled;
                        },
                        onSelect: (_, _) {
                          setState(() => _isOddFocusable = !_isOddFocusable);

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _focusNodes[4].requestFocus();
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
          ),
        );
      },
    );
  }
}
