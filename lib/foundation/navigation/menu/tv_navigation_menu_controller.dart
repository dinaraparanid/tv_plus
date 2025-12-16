import 'package:flutter/widgets.dart';

import 'tv_navigation_menu_selection_entry.dart';

final class TvNavigationMenuController extends ChangeNotifier {
  TvNavigationMenuController({
    required TvNavigationMenuSelectionEntry initialEntry,
    required this.focusScopeNode,
    this.headerNode,
    this.footerNode,
    FocusNode? mediatorFocusNode,
    required this.itemsNodes,
  }) : _entry = initialEntry,
       mediatorFocusNode = mediatorFocusNode ?? FocusNode();

  TvNavigationMenuSelectionEntry _entry;
  TvNavigationMenuSelectionEntry get selectedEntry => _entry;

  final FocusScopeNode focusScopeNode;
  final FocusNode? headerNode;
  final FocusNode? footerNode;
  final FocusNode mediatorFocusNode;
  final Map<Key, FocusNode> itemsNodes;

  bool get hasFocus => focusScopeNode.hasFocus || mediatorFocusNode.hasFocus;

  FocusNode? get selectedFocusNodeOrNull => switch (selectedEntry) {
    HeaderEntry() => headerNode,
    ItemEntry(key: final key) => itemsNodes[key],
    FooterEntry() => footerNode,
  };

  FocusNode get selectedFocusNode => selectedFocusNodeOrNull!;

  void select(TvNavigationMenuSelectionEntry entry) {
    _entry = entry;
    notifyListeners();
  }

  void requestFocusOnMenu() {
    mediatorFocusNode.requestFocus();
  }

  void invalidateItemsNodes({
    required Map<Key, FocusNode> newItems,
    required TvNavigationMenuSelectionEntry Function() onSelectedItemRemoved,
  }) {
    final selectedKey = selectedEntry.key;

    itemsNodes.removeWhere((key, node) {
      final isRemoved = !newItems.containsKey(key);

      if (isRemoved) {
        node.dispose();

        if (key == selectedKey) {
          select(onSelectedItemRemoved());
        }
      }

      return isRemoved;
    });

    newItems.forEach((key, node) => itemsNodes.putIfAbsent(key, () => node));
  }

  @override
  void dispose() {
    focusScopeNode.dispose();
    headerNode?.dispose();
    footerNode?.dispose();
    mediatorFocusNode.dispose();

    for (final node in itemsNodes.values) {
      node.dispose();
    }

    super.dispose();
  }
}
