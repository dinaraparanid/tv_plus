part of 'search.dart';

final class TvSearchController extends ChangeNotifier {
  TvSearchController({TextEditingController? textEditingController})
    : textEditingController = textEditingController ?? TextEditingController() {
    this.textEditingController.addListener(_listener);
  }

  late final TextEditingController textEditingController;

  var _query = '';

  String get query => _query;

  set query(String value) {
    if (value == _query) {
      return;
    }

    _query = value;
    textEditingController.text = value;
    notifyListeners();
  }

  void append(String letter) {
    textEditingController.text += letter;
    notifyListeners();
  }

  void removeLast() {
    textEditingController.text = query.substring(0, query.length - 1);
    notifyListeners();
  }

  void _listener() {
    final nextQuery = textEditingController.text;

    if (_query != nextQuery) {
      _query = nextQuery;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
