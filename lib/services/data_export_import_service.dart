import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uslub_araby/providers/saved_words_provider.dart';
import 'package:uslub_araby/providers/flashcard_deck_provider.dart';
import 'package:uslub_araby/providers/theme_provider.dart';
import 'package:flutter/material.dart';

class DataExportImportService {
  static const String _exportFileName = 'uslub_data_backup.json';

  // Data structure for export/import
  static const String _savedWordsKey = 'saved_words';
  static const String _flashcardProgressKey = 'flashcard_progress';
  static const String _themeModeKey = 'theme_mode';
  static const String _learningReminderKey = 'learning_reminder_enabled';
  static const String _newWordReminderKey = 'new_word_reminder_enabled';
  static const String _exportDateKey = 'export_date';
  static const String _appVersionKey = 'app_version';

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true; // iOS doesn't need explicit storage permission for documents
  }

  Future<String?> exportData({
    required SavedWordsProvider savedWordsProvider,
    required FlashcardDeckProvider flashcardProvider,
    required ThemeProvider themeProvider,
  }) async {
    try {
      // Request permission first
      final hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        throw Exception('Storage permission denied');
      }

      // Get all data
      final savedWords = savedWordsProvider.savedWords;
      final flashcardProgress = await flashcardProvider.getAllFlashcardData();
      final themeMode = themeProvider.themeMode.name;

      // Get notification settings
      final prefs = await SharedPreferences.getInstance();
      final learningReminder = prefs.getBool(_learningReminderKey) ?? false;
      final newWordReminder = prefs.getBool(_newWordReminderKey) ?? false;

      // Create export data structure
      final exportData = {
        _exportDateKey: DateTime.now().toIso8601String(),
        _appVersionKey: '1.0.0',
        _savedWordsKey: savedWords.map((word) => word.id).toList(),
        _flashcardProgressKey: flashcardProgress
            .map(
              (card) => {
                'id': card['id'],
                'deckId': card['deckId'],
                'wordId': card['wordId'],
                'isLearned': card['isLearned'],
                'isMastered': card['isMastered'],
                'createdAt': card['createdAt'],
              },
            )
            .toList(),
        _themeModeKey: themeMode,
        _learningReminderKey: learningReminder,
        _newWordReminderKey: newWordReminder,
      };

      // Convert to JSON
      final jsonString = jsonEncode(exportData);

      // Get download directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
        if (directory == null) {
          directory = await getApplicationDocumentsDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final filePath = '${directory.path}/$_exportFileName';
      final file = File(filePath);

      // Write to file
      await file.writeAsString(jsonString);

      return filePath;
    } catch (e) {
      throw Exception('Failed to export data: $e');
    }
  }

  Future<bool> importData({
    required SavedWordsProvider savedWordsProvider,
    required FlashcardDeckProvider flashcardProvider,
    required ThemeProvider themeProvider,
  }) async {
    try {
      // Request permission first
      final hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        throw Exception('Storage permission denied');
      }

      // Pick file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return false; // User cancelled
      }

      final file = File(result.files.first.path!);

      // Read and parse JSON
      final jsonString = await file.readAsString();
      final importData = jsonDecode(jsonString) as Map<String, dynamic>;

      // Validate data structure
      if (!importData.containsKey(_savedWordsKey) ||
          !importData.containsKey(_flashcardProgressKey)) {
        throw Exception('Invalid backup file format');
      }

      // Import saved words
      final savedWordsIds = importData[_savedWordsKey] as List<dynamic>;
      await savedWordsProvider.importSavedWords(savedWordsIds);

      // Import flashcard progress
      final flashcardData = importData[_flashcardProgressKey] as List<dynamic>;
      await flashcardProvider.importFlashcardProgress(flashcardData);

      // Import theme settings
      if (importData.containsKey(_themeModeKey)) {
        final themeModeString = importData[_themeModeKey] as String;
        ThemeMode themeMode;
        switch (themeModeString) {
          case 'light':
            themeMode = ThemeMode.light;
            break;
          case 'dark':
            themeMode = ThemeMode.dark;
            break;
          case 'system':
            themeMode = ThemeMode.system;
            break;
          default:
            themeMode = ThemeMode.system;
        }
        themeProvider.setThemeMode(themeMode);
      }

      // Import notification settings
      final prefs = await SharedPreferences.getInstance();
      if (importData.containsKey(_learningReminderKey)) {
        final learningReminder = importData[_learningReminderKey] as bool;
        await prefs.setBool(_learningReminderKey, learningReminder);
      }
      if (importData.containsKey(_newWordReminderKey)) {
        final newWordReminder = importData[_newWordReminderKey] as bool;
        await prefs.setBool(_newWordReminderKey, newWordReminder);
      }

      return true;
    } catch (e) {
      throw Exception('Failed to import data: $e');
    }
  }

  Future<Map<String, dynamic>?> previewImportData() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return null;
      }

      final file = File(result.files.first.path!);
      final jsonString = await file.readAsString();
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      // Return preview info
      return {
        'fileName': result.files.first.name,
        'exportDate': data[_exportDateKey],
        'appVersion': data[_appVersionKey],
        'savedWordsCount': (data[_savedWordsKey] as List).length,
        'flashcardProgressCount': (data[_flashcardProgressKey] as List).length,
      };
    } catch (e) {
      throw Exception('Failed to preview data: $e');
    }
  }
}
