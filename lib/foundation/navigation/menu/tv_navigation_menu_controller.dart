part of 'menu.dart';

final class TvNavigationMenuController extends ChangeNotifier {
  TvNavigationMenuController({
    required TvNavigationMenuSelectionEntry initialEntry,
    FocusScopeNode? focusScopeNode,
    FocusNode? headerNode,
    FocusNode? footerNode,
    FocusNode? mediatorFocusNode,
    Map<Key, FocusNode>? itemsNodes,
  }) : _entry = initialEntry,
       _focusScopeNode = focusScopeNode ?? FocusScopeNode(),
       _headerNode = headerNode,
       _footerNode = footerNode,
       mediatorFocusNode = mediatorFocusNode ?? FocusNode(),
       _itemsNodes = itemsNodes ?? {};

  TvNavigationMenuSelectionEntry _entry;
  TvNavigationMenuSelectionEntry get selectedEntry => _entry;

  final FocusScopeNode _focusScopeNode;

  FocusNode? _headerNode;
  FocusNode? get headerNode => _headerNode;

  FocusNode? _footerNode;
  FocusNode? get footerNode => _footerNode;

  final FocusNode mediatorFocusNode;

  Map<Key, FocusNode> _itemsNodes;
  Map<Key, FocusNode> get itemsNodes => _itemsNodes;

  bool get hasFocus => _focusScopeNode.hasFocus || mediatorFocusNode.hasFocus;

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
    _focusScopeNode.dispose();
    _headerNode?.dispose();
    _footerNode?.dispose();
    mediatorFocusNode.dispose();

    for (final node in itemsNodes.values) {
      node.dispose();
    }

    super.dispose();
  }
}
