import 'package:flutter/material.dart';
import 'package:tv_plus/tv_plus.dart';

final class TvListViewSample extends StatefulWidget {
  const TvListViewSample({super.key});

  static const itemCount = 50;
  static const backgroundColor = Color(0xFF131314);
  static const focusedColor = Colors.indigoAccent;
  static const scrollDuration = Duration(milliseconds: 300);

  static final horizontalListKey = GlobalKey();
  static final verticalListKey = GlobalKey();

  static String buildItemName({required int index}) => 'Item $index';

  @override
  State<StatefulWidget> createState() => _TvListViewSampleState();
}

final class _TvListViewSampleState extends State<TvListViewSample> {
  late final _horizontalListFocusScopeNode = FocusScopeNode();

  late final _horizontalListFocusNodes = List.generate(
    TvListViewSample.itemCount,
    (_) => FocusNode(),
  );

  late final _verticalListFocusScopeNode = FocusScopeNode();

  late final _verticalListFocusNodes = List.generate(
    TvListViewSample.itemCount,
    (_) => FocusNode(),
  );

  @override
  void dispose() {
    _horizontalListFocusScopeNode.dispose();

    for (final node in _horizontalListFocusNodes) {
      node.dispose();
    }

    _verticalListFocusScopeNode.dispose();

    for (final node in _verticalListFocusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, _) {
        return Scaffold(
          backgroundColor: TvListViewSample.backgroundColor,
          body: Column(
            spacing: 12,
            children: [
              SizedBox(
                height: 80,
                child: TvListView.separated(
                  key: TvListViewSample.horizontalListKey,
                  scrollDirection: Axis.horizontal,
                  itemCount: TvListViewSample.itemCount,
                  focusScopeNode: _horizontalListFocusScopeNode,
                  onDown: (_, _, isOutOfScope) {
                    if (isOutOfScope) {
                      _requestFocusOnVerticalListItem();
                    }

                    return KeyEventResult.handled;
                  },
                  itemBuilder: (context, index) {
                    return ScrollGroupDpadFocus(
                      key: ValueKey(
                        TvListViewSample.buildItemName(index: index),
                      ),
                      focusNode: _horizontalListFocusNodes[index],
                      autofocus: index == 0,
                      viewportAlignment: 0,
                      scrollToNextNodeDuration: TvListViewSample.scrollDuration,
                      builder: (node) => TvListItem(index: index, node: node),
                    );
                  },
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                ),
              ),

              Expanded(
                child: TvListView.separated(
                  key: TvListViewSample.verticalListKey,
                  itemCount: TvListViewSample.itemCount,
                  focusScopeNode: _verticalListFocusScopeNode,
                  onUp: (_, _, isOutOfScope) {
                    if (isOutOfScope) {
                      _requestFocusOnHorizontalListItem();
                    }

                    return KeyEventResult.handled;
                  },
                  itemBuilder: (context, index) {
                    return ScrollGroupDpadFocus(
                      key: ValueKey(
                        TvListViewSample.buildItemName(index: index),
                      ),
                      focusNode: _verticalListFocusNodes[index],
                      scrollToNextNodeDuration: TvListViewSample.scrollDuration,
                      builder: (node) => TvListItem(index: index, node: node),
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

  void _requestFocusOnHorizontalListItem() {
    final nextNode = _horizontalListFocusScopeNode.focusedChild;

    if (nextNode != null) {
      nextNode.requestFocus();
      return;
    }

    _horizontalListFocusNodes[0].requestFocus();
  }

  void _requestFocusOnVerticalListItem() {
    final nextNode = _verticalListFocusScopeNode.focusedChild;

    if (nextNode != null) {
      nextNode.requestFocus();
      return;
    }

    _verticalListFocusNodes[0].requestFocus();
  }
}

final class TvListItem extends StatelessWidget {
  const TvListItem({super.key, required this.index, required this.node});

  final int index;
  final FocusNode node;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: node.hasFocus
            ? TvListViewSample.focusedColor
            : Colors.transparent,
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Text(
        TvListViewSample.buildItemName(index: index),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
