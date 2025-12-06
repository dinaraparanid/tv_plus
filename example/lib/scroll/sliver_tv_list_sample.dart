import 'package:flutter/material.dart';
import 'package:tv_plus/tv_plus.dart';

final class SliverTvListSample extends StatefulWidget {
  const SliverTvListSample({super.key});

  static const backgroundColor = Color(0xFF131314);

  static const itemCount = 50;
  static const focusedColor = Colors.indigoAccent;

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

  @override
  void dispose() {
    _listFocusScopeNode.dispose();

    for (final node in _listFocusNodes) {
      node.dispose();
    }

    _upButtonFocusNode.dispose();
    _downButtonFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, _) {
        return Scaffold(
          backgroundColor: SliverTvListSample.backgroundColor,
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: DpadFocus(
                  focusNode: _upButtonFocusNode,
                  autofocus: true,
                  onDown: (_, _) {
                    _requestFocusOnHorizontalListItem();
                    return KeyEventResult.handled;
                  },
                  builder: (node) =>
                      _buttonBuilder(node: node, text: 'Up Button'),
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
                  itemCount: SliverTvListSample.itemCount,
                  itemBuilder: (context, index) {
                    return ScrollGroupDpadFocus(
                      focusNode: _listFocusNodes[index],
                      builder: (node) => _itemBuilder(node: node, index: index),
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
                    _requestFocusOnHorizontalListItem();
                    return KeyEventResult.handled;
                  },
                  builder: (node) =>
                      _buttonBuilder(node: node, text: 'Down Button'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _requestFocusOnHorizontalListItem() {
    final nextNode = _listFocusScopeNode.focusedChild;

    if (nextNode != null) {
      nextNode.requestFocus();
      return;
    }

    _listFocusNodes[0].requestFocus();
  }

  static Widget _itemBuilder({required FocusNode node, required int index}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: node.hasFocus
            ? SliverTvListSample.focusedColor
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
