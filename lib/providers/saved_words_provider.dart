import 'package:flutter/foundation.dart';
import 'package:uslub_araby/data/database.dart';

class SavedWordsProvider with ChangeNotifier {
  final List<UslubData> _savedWords = [];
  bool _isLoading = false;

  List<UslubData> get savedWords => _savedWords;
  bool get isLoading => _isLoading;

  bool isSaved(UslubData uslub) {
    return _savedWords.any((item) => item.id == uslub.id);
  }

  bool isSavedById(int id) {
    return _savedWords.any((item) => item.id == id);
  }

  void toggleSaved(UslubData uslub) {
    if (isSaved(uslub)) {
      _savedWords.removeWhere((item) => item.id == uslub.id);
    } else {
      _savedWords.add(uslub);
    }
    notifyListeners();
  }

  void removeWord(int id) {
    _savedWords.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearAllSavedWords() {
    _savedWords.clear();
    notifyListeners();
  }
}
