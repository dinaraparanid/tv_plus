import 'package:flutter/material.dart';
import 'package:tv_plus/tv_plus.dart';

final class SliverTvListSample extends StatefulWidget {
  const SliverTvListSample({super.key});

  static const backgroundColor = Color(0xFF131314);

  static const itemCount = 20;
  static const focusedColor = Colors.indigoAccent;

  static final listKey = GlobalKey();
  static final goToLastButtonKey = GlobalKey();
  static final goToFirstButtonKey = GlobalKey();

  static String buildItemName({required int index}) => 'Item $index';

  @override
  State<StatefulWidget> createState() => _SliverTvListSampleState();
}

final class _SliverTvListSampleState extends State<SliverTvListSample> {
  late final _listFocusScopeNode = FocusScopeNode();

  late final _listFocusNodes = List.generate(
    SliverTvListSample.itemCount,
    (_) => FocusNode(),
  );

  late final _upButtonFocusNode = FocusNode();
  late final _downButtonFocusNode = FocusNode();
  late final _scrollController = ScrollController();

  @override
  void dispose() {
    _listFocusScopeNode.dispose();

    for (final node in _listFocusNodes) {
      node.dispose();
    }

    _upButtonFocusNode.dispose();
    _downButtonFocusNode.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, _) {
        return Scaffold(
          backgroundColor: SliverTvListSample.backgroundColor,
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: DpadFocus(
                  focusNode: _upButtonFocusNode,
                  onDown: (_, _) {
                    _requestFocusOnListItem(fallbackIndex: 0);
                    return KeyEventResult.handled;
                  },
                  onSelect: (_, _) {
                    _scrollController
                        .animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(seconds: 1),
                          curve: Curves.linear,
                        )
                        .then((_) {
                          _listFocusNodes.last.requestFocus();
                        });

                    return KeyEventResult.handled;
                  },
                  builder: (context, node) => TvListButtonItem(
                    key: SliverTvListSample.goToLastButtonKey,
                    node: node,
                    text: 'Go to last',
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              SliverTVScrollAdapter(
                focusScopeNode: _listFocusScopeNode,
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
                sliver: SliverTvList.separated(
                  key: SliverTvListSample.listKey,
                  itemCount: SliverTvListSample.itemCount,
                  itemBuilder: (context, index) {
                    return ScrollGroupDpadFocus(
                      key: ValueKey(
                        SliverTvListSample.buildItemName(index: index),
                      ),
                      focusNode: _listFocusNodes[index],
                      autofocus: index == 0,
                      builder: (context, node) {
                        return TvListItem(node: node, index: index);
                      },
                    );
                  },
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              SliverToBoxAdapter(
                child: DpadFocus(
                  focusNode: _downButtonFocusNode,
                  onUp: (_, _) {
                    _requestFocusOnListItem(
                      fallbackIndex: SliverTvListSample.itemCount - 1,
                    );
                    return KeyEventResult.handled;
                  },
                  onSelect: (_, _) {
                    _scrollController
                        .animateTo(
                          0,
                          duration: const Duration(seconds: 1),
                          curve: Curves.linear,
                        )
                        .then((_) {
                          _listFocusNodes.first.requestFocus();
                        });

                    return KeyEventResult.handled;
                  },
                  builder: (context, node) => TvListButtonItem(
                    key: SliverTvListSample.goToFirstButtonKey,
                    node: node,
                    text: 'Go to first',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _requestFocusOnListItem({required int fallbackIndex}) {
    final nextNode = _listFocusScopeNode.focusedChild;

    if (nextNode != null) {
      nextNode.requestFocus();
      return;
    }

    _listFocusNodes[fallbackIndex].requestFocus();
  }
}

@visibleForTesting
final class TvListItem extends StatelessWidget {
  const TvListItem({super.key, required this.node, required this.index});
  final FocusNode node;
  final int index;

  @override
  Widget build(BuildContext context) {
    return TvListButtonItem(
      node: node,
      text: SliverTvListSample.buildItemName(index: index),
    );
  }
}

@visibleForTesting
final class TvListButtonItem extends StatelessWidget {
  const TvListButtonItem({super.key, required this.node, required this.text});
  final FocusNode node;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: node.hasFocus
            ? SliverTvListSample.focusedColor
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
