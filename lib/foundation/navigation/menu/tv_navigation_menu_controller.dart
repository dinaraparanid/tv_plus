import 'package:flutter/widgets.dart';

import 'tv_navigation_menu_selection_entry.dart';

final class TvNavigationMenuController extends ChangeNotifier {
  TvNavigationMenuController({
    required TvNavigationMenuSelectionEntry initialEntry,
    required this.focusScopeNode,
    this.headerNode,
    this.footerNode,
    required this.itemsNodes,
  }) : _entry = initialEntry;

  TvNavigationMenuSelectionEntry _entry;
  TvNavigationMenuSelectionEntry get selectedEntry => _entry;

  final FocusScopeNode focusScopeNode;
  final FocusNode? headerNode;
  final FocusNode? footerNode;
  final Map<Key, FocusNode> itemsNodes;
  final mediatorFocusNode = FocusNode();

  bool get hasFocus => focusScopeNode.hasFocus || mediatorFocusNode.hasFocus;

  FocusNode get selectedFocusNode {
    return switch (selectedEntry) {
      HeaderEntry() => headerNode,
      ItemEntry(key: final key) => itemsNodes[key],
      FooterEntry() => footerNode,
    }!;
  }

  void select(TvNavigationMenuSelectionEntry entry) {
    _entry = entry;
    notifyListeners();
  }

  void requestFocusOnMenu() {
    mediatorFocusNode.requestFocus();
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
