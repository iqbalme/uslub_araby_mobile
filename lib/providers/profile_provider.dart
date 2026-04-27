import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ProfileProvider with ChangeNotifier {
  static const String _usernameKey = 'user_profile_name';
  static const String _profileImagePathKey = 'user_profile_image_path';
  static const String _defaultUsername = 'Pengguna Uslub';

  String _username = _defaultUsername;
  String? _profileImagePath;
  late SharedPreferences _prefs;

  String get username => _username;
  String? get profileImagePath => _profileImagePath;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _username = _prefs.getString(_usernameKey) ?? _defaultUsername;
    _profileImagePath = _prefs.getString(_profileImagePathKey);
    notifyListeners();
  }

  Future<void> setUsername(String newUsername) async {
    if (newUsername.trim().isEmpty) {
      throw Exception('Nama pengguna tidak boleh kosong');
    }

    _username = newUsername.trim();
    await _prefs.setString(_usernameKey, _username);
    notifyListeners();
  }

  Future<void> setProfileImage(File imageFile) async {
    try {
      // Get app documents directory
      final appDir = await getApplicationDocumentsDirectory();
      final profileDir = Directory('${appDir.path}/profile');

      // Create profile directory if it doesn't exist
      if (!await profileDir.exists()) {
        await profileDir.create(recursive: true);
      }

      // Save image with timestamp to ensure unique names
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final newPath = '${profileDir.path}/$fileName';
      final savedImage = await imageFile.copy(newPath);

      // Delete old image if exists
      if (_profileImagePath != null) {
        final oldFile = File(_profileImagePath!);
        if (await oldFile.exists()) {
          await oldFile.delete();
        }
      }

      _profileImagePath = savedImage.path;
      await _prefs.setString(_profileImagePathKey, _profileImagePath!);
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal menyimpan gambar profil: $e');
    }
  }

  Future<void> removeProfileImage() async {
    if (_profileImagePath != null) {
      final file = File(_profileImagePath!);
      if (await file.exists()) {
        await file.delete();
      }
    }
    _profileImagePath = null;
    await _prefs.remove(_profileImagePathKey);
    notifyListeners();
  }

  void resetProfile() async {
    await removeProfileImage();
    _username = _defaultUsername;
    await _prefs.remove(_usernameKey);
    notifyListeners();
  }
}
