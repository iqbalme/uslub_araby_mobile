import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uslub_araby/data/database.dart';

class UslubProvider with ChangeNotifier {
  final AppDatabase _db = AppDatabase();
  List<UslubData> _words = [];
  List<String> _recentSearches = [];
  bool _isLoading = true;
  String _currentQuery = '';
  String _searchText = '';

  UslubProvider() {
    fetchWords();
    _loadRecentSearches();
  }

  List<UslubData> get words => _words;
  List<String> get recentSearches => _recentSearches;
  bool get isLoading => _isLoading;
  String get currentQuery => _currentQuery;
  String get searchText => _searchText;

  Future<void> fetchWords() async {
    _isLoading = true;
    notifyListeners();
    try {
      _words = await _db.getAllWords();

      // If no data, seed initial data
      if (_words.isEmpty) {
        await _seedInitialData();
        _words = await _db.getAllWords();
      }
    } catch (e, s) {
      developer.log(
        'Error fetching words from Drift',
        name: 'uslub_araby.uslub_provider',
        error: e,
        stackTrace: s,
      );
      _words = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _recentSearches = prefs.getStringList('recent_searches') ?? [];
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading recent searches: $e');
    }
  }

  Future<void> _seedInitialData() async {
    try {
      await _db.seedInitialData();
    } catch (e, s) {
      developer.log(
        'Error seeding initial data',
        name: 'uslub_provider',
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> addToRecentSearches(String query) async {
    if (query.isEmpty) return;

    try {
      // Remove if already exists
      _recentSearches.remove(query);
      // Add to beginning
      _recentSearches.insert(0, query);
      // Keep only 3 recent searches
      if (_recentSearches.length > 3) {
        _recentSearches = _recentSearches.sublist(0, 3);
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('recent_searches', _recentSearches);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving recent search: $e');
    }
  }

  Future<void> removeFromRecentSearches(String query) async {
    try {
      _recentSearches.remove(query);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('recent_searches', _recentSearches);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing recent search: $e');
    }
  }

  Future<void> clearAllRecentSearches() async {
    try {
      _recentSearches.clear();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('recent_searches', _recentSearches);
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing all recent searches: $e');
    }
  }

  void triggerSearchFromHistory(String query) {
    _searchText = query;
    notifyListeners();
    searchAndSave(query);
  }

  void clearSearchText() {
    _searchText = '';
    // Don't notify listeners here to avoid clearing the text immediately
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
      developer.log(
        'Error searching words in Drift',
        name: 'uslub_araby_provider',
        error: e,
        stackTrace: s,
      );
      _words = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchAndSave(String query) async {
    _currentQuery = query;
    _isLoading = true;
    notifyListeners();
    try {
      if (query.isEmpty) {
        _words = await _db.getAllWords();
      } else {
        _words = await _db.searchWords(query);
        // Add to recent searches only when submitted
        if (_words.isNotEmpty) {
          await addToRecentSearches(query);
        }
      }
    } catch (e, s) {
      developer.log(
        'Error searching words in Drift',
        name: 'uslub_araby_provider',
        error: e,
        stackTrace: s,
      );
      _words = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> clearSearch() async {
    _currentQuery = '';
    _words = await _db.getAllWords();
    notifyListeners();
  }

  Future<UslubData?> getWordById(int id) async {
    try {
      return await _db.getWordById(id);
    } catch (e, s) {
      developer.log(
        'Error fetching word by id from Drift',
        name: 'uslub_araby.uslub_provider',
        error: e,
        stackTrace: s,
      );
      return null;
    }
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }
}
