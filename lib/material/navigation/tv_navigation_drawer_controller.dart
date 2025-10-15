import 'package:flutter/material.dart';

import 'selection_entry.dart';

final class TvNavigationDrawerController extends ChangeNotifier {
  TvNavigationDrawerController({
    required int initialSelectedIndex,
    required this.itemCount,
    FocusNode? childNode,
  })
      : assert(itemCount > 0),
        _entry = ItemEntry(index: initialSelectedIndex) {
    childFocusNode = childNode ?? FocusNode();
    _ownsChildNode = childNode == null;

    headerFocusNode = FocusNode();
    footerFocusNode = FocusNode();
    itemsFocusNodes = List.generate(itemCount, (_) => FocusNode());
    _focusNodes = [headerFocusNode, footerFocusNode, ...itemsFocusNodes];

    _focusListenable = Listenable
      .merge(_focusNodes)
      ..addListener(_focusChangeListener);
  }

  final int itemCount;

  SelectionEntry _entry;
  SelectionEntry get entry => _entry;

  late final FocusNode childFocusNode;
  bool _ownsChildNode = false;

  late final FocusNode headerFocusNode;
  late final FocusNode footerFocusNode;
  late final List<FocusNode> itemsFocusNodes;

  late final List<FocusNode> _focusNodes;
  late final Listenable _focusListenable;

  bool _hasFocus = false;

  /// = isExpanded
  bool get hasFocus => _hasFocus;

  FocusNode get selectedNode {
    return switch (entry) {
      HeaderEntry() => headerFocusNode,
      ItemEntry(index: final index) => itemsFocusNodes[index],
      FooterEntry() => footerFocusNode,
    };
  }

  void _focusChangeListener() {
    final nextHasFocus = _focusNodes.any((it) {
      return it.hasFocus;
    });

    if (nextHasFocus != _hasFocus) {
      _hasFocus = nextHasFocus;
      notifyListeners();
    }
  }

  void select(SelectionEntry entry) {
    _entry = entry;
    notifyListeners();
  }

  @override
  void dispose() {
    _focusListenable.removeListener(_focusChangeListener);

    if (_ownsChildNode) {
      childFocusNode.dispose();
    }

    headerFocusNode.dispose();
    footerFocusNode.dispose();

    for (final it in itemsFocusNodes) {
      it.dispose();
    }

    super.dispose();
  }
}
