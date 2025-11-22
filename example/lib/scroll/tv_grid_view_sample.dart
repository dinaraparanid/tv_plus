import 'package:flutter/material.dart';
import 'package:tv_plus/tv_plus.dart';

final class TvGridViewSample extends StatefulWidget {
  const TvGridViewSample({super.key});

  static const backgroundColor = Color(0xFF131314);

  static const itemCount = 50;
  static const focusedColor = Colors.indigoAccent;

  @override
  State<StatefulWidget> createState() => _TvGridViewSampleState();
}

final class _TvGridViewSampleState extends State<TvGridViewSample> {
  late final _gridFocusScopeNode = FocusScopeNode();

  late final _gridFocusNodes = List.generate(
    TvGridViewSample.itemCount,
    (_) => FocusNode(),
  );

  late final _upButtonFocusNode = FocusNode();
  late final _downButtonFocusNode = FocusNode();
  late final _leftButtonFocusNode = FocusNode();
  late final _rightButtonFocusNode = FocusNode();

  @override
  void dispose() {
    _gridFocusScopeNode.dispose();

    for (final node in _gridFocusNodes) {
      node.dispose();
    }

    for (final node in _gridFocusNodes) {
      node.dispose();
    }

    _upButtonFocusNode.dispose();
    _downButtonFocusNode.dispose();
    _leftButtonFocusNode.dispose();
    _rightButtonFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, _) {
        return Scaffold(
          backgroundColor: TvGridViewSample.backgroundColor,
          body: Column(
            spacing: 12,
            children: [
              DpadFocus(
                focusNode: _upButtonFocusNode,
                onDown: (_, _) {
                  _requestFocusOnGridItem();
                  return KeyEventResult.handled;
                },
                onLeft: (_, _) => KeyEventResult.handled,
                onRight: (_, _) => KeyEventResult.handled,
                builder: (node) =>
                    _buttonBuilder(node: node, text: 'Up Button'),
              ),
              Expanded(
                child: Row(
                  spacing: 12,
                  children: [
                    DpadFocus(
                      focusNode: _leftButtonFocusNode,
                      autofocus: true,
                      onUp: (_, _) => KeyEventResult.handled,
                      onDown: (_, _) => KeyEventResult.handled,
                      onLeft: (_, _) => KeyEventResult.handled,
                      onRight: (_, _) {
                        _requestFocusOnGridItem();
                        return KeyEventResult.handled;
                      },
                      builder: (node) =>
                          _buttonBuilder(node: node, text: 'Left Button'),
                    ),

                    Expanded(
                      child: TvGridView.builder(
                        itemCount: TvGridViewSample.itemCount,
                        focusScopeNode: _gridFocusScopeNode,
                        onOutOfScopeUp: (_, _) {
                          _gridFocusScopeNode.unfocus();
                          _upButtonFocusNode.requestFocus();
                          return KeyEventResult.handled;
                        },
                        onOutOfScopeDown: (_, _) {
                          _gridFocusScopeNode.unfocus();
                          _downButtonFocusNode.requestFocus();
                          return KeyEventResult.handled;
                        },
                        onOutOfScopeLeft: (_, _) {
                          _gridFocusScopeNode.unfocus();
                          _leftButtonFocusNode.requestFocus();
                          return KeyEventResult.handled;
                        },
                        onOutOfScopeRight: (_, _) {
                          _gridFocusScopeNode.unfocus();
                          _rightButtonFocusNode.requestFocus();
                          return KeyEventResult.handled;
                        },
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 250,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              mainAxisExtent: 80,
                            ),
                        itemBuilder: (context, index) {
                          return ScrollGroupDpadFocus(
                            focusNode: _gridFocusNodes[index],
                            builder: (node) =>
                                _itemBuilder(node: node, index: index),
                          );
                        },
                      ),
                    ),

                    DpadFocus(
                      focusNode: _rightButtonFocusNode,
                      onUp: (_, _) => KeyEventResult.handled,
                      onDown: (_, _) => KeyEventResult.handled,
                      onLeft: (_, _) {
                        _requestFocusOnGridItem();
                        return KeyEventResult.handled;
                      },
                      onRight: (_, _) => KeyEventResult.handled,
                      builder: (node) =>
                          _buttonBuilder(node: node, text: 'Right Button'),
                    ),
                  ],
                ),
              ),
              DpadFocus(
                focusNode: _downButtonFocusNode,
                onUp: (_, _) {
                  _requestFocusOnGridItem();
                  return KeyEventResult.handled;
                },
                onLeft: (_, _) => KeyEventResult.handled,
                onRight: (_, _) => KeyEventResult.handled,
                builder: (node) =>
                    _buttonBuilder(node: node, text: 'Down Button'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _requestFocusOnGridItem() {
    final nextNode = _gridFocusScopeNode.focusedChild;

    if (nextNode != null) {
      nextNode.requestFocus();
      return;
    }

    _gridFocusNodes[0].requestFocus();
  }

  static Widget _itemBuilder({required FocusNode node, required int index}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: node.hasFocus
            ? TvGridViewSample.focusedColor
            : Colors.transparent,
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Text(
        'Item $index',
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static Widget _buttonBuilder({
    required FocusNode node,
    required String text,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: node.hasFocus
            ? TvGridViewSample.focusedColor
            : Colors.transparent,
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
