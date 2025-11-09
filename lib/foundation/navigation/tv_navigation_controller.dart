import 'package:flutter/widgets.dart';

import 'tv_selection_entry.dart';

final class TvNavigationController extends ChangeNotifier {
  TvNavigationController({
    required TvSelectionEntry initialEntry,
    FocusNode? childNode,
  }) : _entry = initialEntry,
       _itemsKeys = [],
       _itemsFocusNodes = {} {
    childFocusNode = childNode ?? FocusNode();
    _ownsChildNode = childNode == null;

    headerFocusNode = FocusNode();
    footerFocusNode = FocusNode();
    mediatorFocusNode = FocusNode();
  }

  TvSelectionEntry _entry;
  TvSelectionEntry get selectedEntry => _entry;

  late final FocusNode childFocusNode;
  bool _ownsChildNode = false;

  late final FocusNode headerFocusNode;
  late final FocusNode footerFocusNode;
  late final FocusNode mediatorFocusNode;

  List<Key> _itemsKeys = [];
  late final Map<Key, FocusNode> _itemsFocusNodes;

  List<FocusNode> _focusNodes = [];
  Listenable? _focusListenable;

  bool _hasFocus = false;

  /// = isExpanded
  bool get hasFocus => _hasFocus;

  int get itemCount => _itemsKeys.length;

  FocusNode get selectedFocusNode {
    return switch (selectedEntry) {
      HeaderEntry() => headerFocusNode,
      ItemEntry(key: final key) => _itemsFocusNodes[key]!,
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

  FocusNode? getItemFocusNodeAt(int index) =>
      _itemsFocusNodes[_itemsKeys[index]];

  FocusNode? getItemFocusNodeByKey(Key key) => _itemsFocusNodes[key];

  void attachItemsFocusNodes(List<Key> keys) {
    _itemsKeys = keys;

    final presentKeys = _itemsKeys.toSet();

    for (final key in _itemsKeys) {
      _itemsFocusNodes.update(
        key,
        (focusNode) => focusNode,
        ifAbsent: () => FocusNode(),
      );
    }

    _itemsFocusNodes.keys
        .where((key) => !presentKeys.contains(key))
        .toList()
        .forEach((key) => _itemsFocusNodes.remove(key)?.dispose());

    _focusNodes = [
      headerFocusNode,
      footerFocusNode,
      mediatorFocusNode,
      ..._itemsFocusNodes.values,
    ];

    _focusListenable?.removeListener(_focusChangeListener);

    _focusListenable = Listenable.merge(_focusNodes)
      ..addListener(_focusChangeListener);
  }

  void select(TvSelectionEntry entry) {
    _entry = entry;
    notifyListeners();
  }

  @override
  void dispose() {
    _focusListenable?.removeListener(_focusChangeListener);

    if (_ownsChildNode) {
      childFocusNode.dispose();
    }

    headerFocusNode.dispose();
    footerFocusNode.dispose();
    mediatorFocusNode.dispose();

    for (final itemFocusNode in _itemsFocusNodes.values) {
      itemFocusNode.dispose();
    }

    super.dispose();
  }
}
