part of 'menu.dart';

final class TvNavigationMenuController with ChangeNotifier {
  TvNavigationMenuController({
    required TvNavigationMenuEntry initialEntry,
    FocusScopeNode? focusScopeNode,
    FocusNode? headerNode,
    FocusNode? footerNode,
    FocusNode? mediatorNode,
    Map<Key, FocusNode>? itemsNodes,
  }) : _entry = initialEntry,
       focusScopeNode = focusScopeNode ?? FocusScopeNode(),
       _headerNode = headerNode,
       _footerNode = footerNode,
       mediatorNode = mediatorNode ?? FocusNode(),
       _itemsNodes = itemsNodes ?? {};

  TvNavigationMenuEntry _entry;
  TvNavigationMenuEntry get selectedEntry => _entry;

  final FocusScopeNode focusScopeNode;

  FocusNode? _headerNode;
  FocusNode? get headerNode => _headerNode;

  FocusNode? _footerNode;
  FocusNode? get footerNode => _footerNode;

  final FocusNode mediatorNode;

  Map<Key, FocusNode> _itemsNodes;
  Map<Key, FocusNode> get itemsNodes => _itemsNodes;

  bool get hasFocus => focusScopeNode.hasFocus || mediatorNode.hasFocus;

  FocusNode? get selectedFocusNodeOrNull => switch (selectedEntry) {
    HeaderEntry() => headerNode,
    ItemEntry(key: final key) => itemsNodes[key],
    FooterEntry() => footerNode,
  };

  FocusNode get selectedFocusNode => selectedFocusNodeOrNull!;

  void select(TvNavigationMenuEntry entry) {
    _entry = entry;
    notifyListeners();
  }

  void requestFocusOnMenu() {
    mediatorNode.requestFocus();
  }

  void invalidateItemsNodes({
    required Map<Key, FocusNode> newItems,
    required TvNavigationMenuEntry Function() onSelectedItemRemoved,
  }) {
    final selectedKey = switch (selectedEntry) {
      ItemEntry(key: final key) => key,
      HeaderEntry() || FooterEntry() => null,
    };

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
    _headerNode?.dispose();
    _footerNode?.dispose();
    mediatorNode.dispose();

    for (final node in itemsNodes.values) {
      node.dispose();
    }

    super.dispose();
  }
}
