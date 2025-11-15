import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tv_plus/foundation/dpad/dpad.dart';

final class TvListView extends StatefulWidget {
  const TvListView({super.key});

  @override
  State<StatefulWidget> createState() => _TvListViewState();
}

final class _TvListViewState extends State<TvListView> {
  late final _scrollController = ScrollController();
  late final _focusNodes = List.generate(50, (_) => FocusNode());

  @override
  void dispose() {
    _scrollController.dispose();

    for (final node in _focusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 50,
      controller: _scrollController,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        return DpadFocus(
          focusNode: _focusNodes[index],
          autofocus: index == 0,
          onUp: (node, _) {
            if (index == 0) {
              return KeyEventResult.handled;
            }

            final nextNode = _focusNodes[index - 1]..requestFocus();
            final nextBox =
                nextNode.context!.findRenderSliverChild() as RenderBox;
            final listSliver = context.findRenderObject() as RenderSliverList;
            final nextScrollPosition = listSliver.childScrollOffset(nextBox)!;

            _scrollController.animateTo(
              nextScrollPosition,
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
            );

            return KeyEventResult.handled;
          },
          onDown: (node, _) {
            if (index == _focusNodes.length - 1) {
              return KeyEventResult.handled;
            }

            final nextNode = _focusNodes[index + 1]..requestFocus();
            final nextBox =
                nextNode.context!.findRenderSliverChild() as RenderBox;
            final listSliver = context.findRenderObject() as RenderSliverList;
            final nextScrollPosition = listSliver.childScrollOffset(nextBox)!;

            _scrollController.animateTo(
              nextScrollPosition,
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
            );

            return KeyEventResult.handled;
          },
          builder: (node) {
            return Container(
              decoration: BoxDecoration(
                color: node.hasFocus ? Colors.green : Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
              child: Text(
                'Item $index',
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        );
      },
    );
  }
}

extension _FindRenderSliverChild on BuildContext {
  RenderBox? findRenderSliverChild() {
    var box = findRenderObject();

    if (box is! RenderBox) {
      return null;
    }

    while (box != null && box.parentData is! SliverMultiBoxAdaptorParentData) {
      box = box.parent;
    }

    if (box == null) {
      return null;
    }

    return box as RenderBox;
  }
}
