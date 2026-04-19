part of 'search.dart';

final class TVSearchController extends ChangeNotifier {
  TVSearchController({TextEditingController? textEditingController})
    : textEditingController = textEditingController ?? TextEditingController();

  late final TextEditingController textEditingController;

  String get query => textEditingController.text;

  set query(String value) {
    textEditingController.text = value;
    notifyListeners();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
