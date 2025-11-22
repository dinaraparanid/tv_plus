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
  late final _focusNodes = List.generate(
    TvGridViewSample.itemCount,
    (_) => FocusNode(),
  );

  late FocusNode _currentNode;

  @override
  void initState() {
    _currentNode = _focusNodes.first;
    super.initState();
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }

    for (final node in _focusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, _) {
        return Scaffold(
          backgroundColor: TvGridViewSample.backgroundColor,
          body: TvGridView.builder(
            itemCount: TvGridViewSample.itemCount,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 300,
            ),
            itemBuilder: (context, index) {
              return ScrollGroupDpadFocus(
                focusNode: _focusNodes[index],
                autofocus: index == 0,
                downHandler: ScrollGroupDpadEventHandler(
                  onEvent: (_, _) {
                    _currentNode.requestFocus();
                    return KeyEventResult.handled;
                  },
                ),
                leftHandler: ScrollGroupDpadEventHandler(
                  nextNode: index != 0 ? _focusNodes[index - 1] : null,
                ),
                rightHandler: ScrollGroupDpadEventHandler(
                  nextNode: index != TvGridViewSample.itemCount - 1
                      ? _focusNodes[index + 1]
                      : null,
                ),
                onFocusChanged: (node) {
                  if (node.hasFocus) {
                    _currentNode = node;
                  }
                },
                builder: (node) => _itemBuilder(node: node, index: index),
              );
            },
          ),
        );
      },
    );
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
}
