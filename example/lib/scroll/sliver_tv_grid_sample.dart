import 'package:flutter/material.dart';
import 'package:tv_plus/tv_plus.dart';

final class SliverTvGridSample extends StatefulWidget {
  const SliverTvGridSample({super.key, this.fallbackIndex = 0});

  final int fallbackIndex;

  static const backgroundColor = Color(0xFF131314);

  static const itemCount = 50;
  static const focusedColor = Colors.indigoAccent;

  static final gridKey = GlobalKey();
  static final upButtonKey = GlobalKey();
  static final downButtonKey = GlobalKey();
  static final leftButtonKey = GlobalKey();
  static final rightButtonKey = GlobalKey();

  static String buildItemName({required int index}) => 'Item $index';

  @override
  State<StatefulWidget> createState() => _SliverTvGridSampleState();
}

final class _SliverTvGridSampleState extends State<SliverTvGridSample> {
  late final _gridFocusScopeNode = FocusScopeNode();

  late final _gridFocusNodes = List.generate(
    SliverTvGridSample.itemCount,
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
          backgroundColor: SliverTvGridSample.backgroundColor,
          body: Row(
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
                builder: (context, node) => Wrap(
                  children: [
                    TvGridButtonItem(
                      key: SliverTvGridSample.leftButtonKey,
                      node: node,
                      text: 'Left Button',
                    ),
                  ],
                ),
              ),

              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DpadFocus(
                            focusNode: _upButtonFocusNode,
                            onDown: (_, _) {
                              _requestFocusOnGridItem();
                              return KeyEventResult.handled;
                            },
                            onLeft: (_, _) => KeyEventResult.handled,
                            onRight: (_, _) => KeyEventResult.handled,
                            builder: (context, node) => TvGridButtonItem(
                              key: SliverTvGridSample.upButtonKey,
                              node: node,
                              text: 'Up Button',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 12)),

                    SliverTVScrollAdapter(
                      focusScopeNode: _gridFocusScopeNode,
                      onUp: (_, _, isOutOfScope) {
                        if (isOutOfScope) {
                          _upButtonFocusNode.requestFocus();
                        }

                        return KeyEventResult.handled;
                      },
                      onDown: (_, _, isOutOfScope) {
                        if (isOutOfScope) {
                          _downButtonFocusNode.requestFocus();
                        }

                        return KeyEventResult.handled;
                      },
                      onLeft: (_, _, isOutOfScope) {
                        if (isOutOfScope) {
                          _leftButtonFocusNode.requestFocus();
                        }

                        return KeyEventResult.handled;
                      },
                      onRight: (_, _, isOutOfScope) {
                        if (isOutOfScope) {
                          _rightButtonFocusNode.requestFocus();
                        }

                        return KeyEventResult.handled;
                      },
                      sliver: SliverGrid.builder(
                        key: SliverTvGridSample.gridKey,
                        itemCount: SliverTvGridSample.itemCount,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 250,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              mainAxisExtent: 80,
                            ),
                        itemBuilder: (context, index) {
                          return ScrollGroupDpadFocus(
                            key: ValueKey(
                              SliverTvGridSample.buildItemName(index: index),
                            ),
                            focusNode: _gridFocusNodes[index],
                            builder: (context, node) =>
                                TvGridItem(node: node, index: index),
                          );
                        },
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 12)),

                    SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DpadFocus(
                            focusNode: _downButtonFocusNode,
                            onUp: (_, _) {
                              _requestFocusOnGridItem();
                              return KeyEventResult.handled;
                            },
                            onLeft: (_, _) => KeyEventResult.handled,
                            onRight: (_, _) => KeyEventResult.handled,
                            builder: (context, node) => TvGridButtonItem(
                              key: SliverTvGridSample.downButtonKey,
                              node: node,
                              text: 'Down Button',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                builder: (context, node) => Wrap(
                  children: [
                    TvGridButtonItem(
                      key: SliverTvGridSample.rightButtonKey,
                      node: node,
                      text: 'Right Button',
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

  void _requestFocusOnGridItem() {
    final nextNode = _gridFocusScopeNode.focusedChild;

    if (nextNode != null) {
      nextNode.requestFocus();
      return;
    }

    _gridFocusNodes[widget.fallbackIndex].requestFocus();
  }
}

@visibleForTesting
final class TvGridItem extends StatelessWidget {
  const TvGridItem({super.key, required this.node, required this.index});

  final FocusNode node;
  final int index;

  @override
  Widget build(BuildContext context) {
    return TvGridButtonItem(
      node: node,
      text: SliverTvGridSample.buildItemName(index: index),
    );
  }
}

@visibleForTesting
final class TvGridButtonItem extends StatelessWidget {
  const TvGridButtonItem({super.key, required this.node, required this.text});

  final FocusNode node;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: node.hasFocus
            ? SliverTvGridSample.focusedColor
            : Colors.transparent,
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      alignment: Alignment.center,
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
