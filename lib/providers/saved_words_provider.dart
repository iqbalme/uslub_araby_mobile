
import 'package:flutter/foundation.dart';
import 'package:uslub_araby/data/database.dart';

class SavedWordsProvider with ChangeNotifier {
  final List<UslubData> _savedWords = [];

  List<UslubData> get savedWords => _savedWords;

  bool isSaved(UslubData uslub) {
    return _savedWords.any((item) => item.id == uslub.id);
  }

  void toggleSaved(UslubData uslub) {
    if (isSaved(uslub)) {
      _savedWords.removeWhere((item) => item.id == uslub.id);
    } else {
      _savedWords.add(uslub);
    }
    notifyListeners();
  }
}
