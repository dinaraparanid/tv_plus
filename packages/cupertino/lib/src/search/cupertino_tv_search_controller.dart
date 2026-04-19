part of 'search.dart';

final class CupertinoTvSearchController extends ChangeNotifier {
  CupertinoTvSearchController({
    TvSearchController? controller,
    FocusScopeNode? focusScopeNode,
    FocusScopeNode? lettersScopeNode,
    required this.localization,
    required Locale currentLocale,
  }) : _controller = controller ?? TvSearchController(),
       _currentLocale = currentLocale,
       focusScopeNode = focusScopeNode ?? FocusScopeNode(),
       lettersScopeNode = lettersScopeNode ?? FocusScopeNode() {
    if (!localization.supportedAlphabets.containsKey(currentLocale)) {
      throw Exception('Unsupported locale: $currentLocale');
    }

    _controller.addListener(notifyListeners);
  }

  final TvSearchController _controller;
  final CupertinoTvSearchBarLocalization localization;
  Locale _currentLocale;

  final FocusScopeNode focusScopeNode;
  final FocusScopeNode lettersScopeNode;

  Locale get currentLocale => _currentLocale;

  TextEditingController get textEditingController {
    return _controller.textEditingController;
  }

  String get query => _controller.query;

  set query(String value) => _controller.query = value;

  void append(String letter) => _controller.append(letter);

  void removeLast() => _controller.removeLast();

  void switchToNextLocale() {
    final iter = localization.supportedAlphabets.entries.iterator;

    while (iter.moveNext()) {
      if (iter.current.key != currentLocale) {
        continue;
      }

      _currentLocale = iter.moveNext()
          ? iter.current.key
          : localization.supportedAlphabets.keys.first;

      notifyListeners();
      break;
    }
  }

  void requestFocusOnFirstLetter() {
    lettersScopeNode.traversalChildren.first.requestFocus();
  }

  @override
  void dispose() {
    _controller.removeListener(notifyListeners);
    _controller.dispose();

    focusScopeNode.dispose();
    lettersScopeNode.dispose();
    super.dispose();
  }
}
