part of 'search.dart';

final class TvSearchController extends ChangeNotifier {
  TvSearchController({TextEditingController? textEditingController})
    : textEditingController = textEditingController ?? TextEditingController();

  late final TextEditingController textEditingController;

  String get query => textEditingController.text;

  set query(String value) {
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

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
