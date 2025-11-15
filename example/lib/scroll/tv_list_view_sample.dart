import 'package:flutter/material.dart';
import 'package:tv_plus/tv_plus.dart';

final class TvListViewSample extends StatefulWidget {
  const TvListViewSample({super.key});

  static const itemCount = 50;
  static const focusedColor = Colors.indigoAccent;

  @override
  State<StatefulWidget> createState() => _TvListViewSampleState();
}

final class _TvListViewSampleState extends State<TvListViewSample> {
  late final _horizontalListFocusNodes = List.generate(
    TvListViewSample.itemCount,
    (_) => FocusNode(),
  );

  late final _verticalListFocusNodes = List.generate(
    TvListViewSample.itemCount,
    (_) => FocusNode(),
  );

  late FocusNode _currentHorizontalNode;
  late FocusNode _currentVerticalNode;

  @override
  void initState() {
    _currentHorizontalNode = _horizontalListFocusNodes.first;
    _currentVerticalNode = _verticalListFocusNodes.first;
    super.initState();
  }

  @override
  void dispose() {
    for (final node in _horizontalListFocusNodes) {
      node.dispose();
    }

    for (final node in _verticalListFocusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, _) {
        return Material(
          child: Column(
            spacing: 12,
            children: [
              SizedBox(
                height: 80,
                child: TvListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: TvListViewSample.itemCount,
                  itemBuilder: (context, index) {
                    return ScrollGroupDpadFocus(
                      focusNode: _horizontalListFocusNodes[index],
                      autofocus: index == 0,
                      viewportAlignment: 0,
                      downHandler: ScrollGroupDpadEventHandler(
                        onEvent: (_, _) {
                          _currentVerticalNode.requestFocus();
                          return KeyEventResult.handled;
                        },
                      ),
                      leftHandler: ScrollGroupDpadEventHandler(
                        nextNode: index != 0
                            ? _horizontalListFocusNodes[index - 1]
                            : null,
                      ),
                      rightHandler: ScrollGroupDpadEventHandler(
                        nextNode: index != TvListViewSample.itemCount - 1
                            ? _horizontalListFocusNodes[index + 1]
                            : null,
                      ),
                      onFocusChanged: (node) {
                        if (node.hasFocus) {
                          _currentHorizontalNode = node;
                        }
                      },
                      builder: (node) => _itemBuilder(node: node, index: index),
                    );
                  },
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                ),
              ),

              Expanded(
                child: TvListView.separated(
                  itemCount: TvListViewSample.itemCount,
                  itemBuilder: (context, index) {
                    return ScrollGroupDpadFocus(
                      focusNode: _verticalListFocusNodes[index],
                      upHandler: ScrollGroupDpadEventHandler(
                        onEvent: index != 0
                            ? null
                            : (_, _) {
                                _currentHorizontalNode.requestFocus();
                                return KeyEventResult.handled;
                              },
                        nextNode: index != 0
                            ? _verticalListFocusNodes[index - 1]
                            : null,
                      ),
                      downHandler: ScrollGroupDpadEventHandler(
                        nextNode: index != TvListViewSample.itemCount - 1
                            ? _verticalListFocusNodes[index + 1]
                            : null,
                      ),
                      onFocusChanged: (node) {
                        if (node.hasFocus) {
                          _currentVerticalNode = node;
                        }
                      },
                      builder: (node) => _itemBuilder(node: node, index: index),
                    );
                  },
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                ),
              ),
            ],
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
            ? TvListViewSample.focusedColor
            : Colors.transparent,
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Text('Item $index'),
    );
  }
}
