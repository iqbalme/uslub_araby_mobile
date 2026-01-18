
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:uslub_araby/data/database.dart';

class UslubProvider with ChangeNotifier {
  final AppDatabase _db = AppDatabase();
  List<UslubData> _words = [];
  bool _isLoading = true;
  String _currentQuery = '';

  UslubProvider() {
    fetchWords();
  }

  List<UslubData> get words => _words;
  bool get isLoading => _isLoading;
  String get currentQuery => _currentQuery;

  Future<void> fetchWords() async {
    _isLoading = true;
    notifyListeners();
    try {
      _words = await _db.getAllWords();
    } catch (e, s) {
      developer.log('Error fetching words from Drift', name: 'uslub_araby.uslub_provider', error: e, stackTrace: s);
      _words = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> search(String query) async {
    _currentQuery = query;
    _isLoading = true;
    notifyListeners();
    try {
      if (query.isEmpty) {
        _words = await _db.getAllWords();
      } else {
        _words = await _db.searchWords(query);
      }
    } catch (e, s) {
      developer.log('Error searching words in Drift', name: 'uslub_araby.uslub_provider', error: e, stackTrace: s);
      _words = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<UslubData?> getWordById(int id) async {
    try {
      return await _db.getWordById(id);
    } catch (e, s) {
      developer.log('Error fetching word by id from Drift', name: 'uslub_araby.uslub_provider', error: e, stackTrace: s);
      return null;
    }
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }
}
