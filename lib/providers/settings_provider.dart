import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  final SharedPreferences _prefs;

  SettingsProvider(this._prefs) {
    _loadSettings();
  }

  // State
  ThemeMode _themeMode = ThemeMode.system;
  bool _useDynamicColor = true;
  List<String> _starredEmails = [];
  List<String> _deletedEmails = [];

  // Getters
  ThemeMode get themeMode => _themeMode;
  bool get useDynamicColor => _useDynamicColor;
  List<String> get starredEmails => _starredEmails;
  List<String> get deletedEmails => _deletedEmails;

  // Load from prefs
  void _loadSettings() {
    final themeIndex = _prefs.getInt('themeMode') ?? 0;
    _themeMode = ThemeMode.values[themeIndex];
    
    _useDynamicColor = _prefs.getBool('useDynamicColor') ?? true;
    _starredEmails = _prefs.getStringList('starredEmails') ?? [];
    _deletedEmails = _prefs.getStringList('deletedEmails') ?? [];
    notifyListeners();
  }

  // Setters
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setInt('themeMode', mode.index);
    notifyListeners();
  }

  Future<void> setUseDynamicColor(bool useDynamic) async {
    _useDynamicColor = useDynamic;
    await _prefs.setBool('useDynamicColor', useDynamic);
    notifyListeners();
  }

  Future<void> toggleStar(String emailId) async {
    if (_starredEmails.contains(emailId)) {
      _starredEmails.remove(emailId);
    } else {
      _starredEmails.add(emailId);
    }
    await _prefs.setStringList('starredEmails', _starredEmails);
    notifyListeners();
  }

  bool isStarred(String emailId) => _starredEmails.contains(emailId);

  Future<void> deleteEmail(String emailId) async {
    if (!_deletedEmails.contains(emailId)) {
      _deletedEmails.add(emailId);
      await _prefs.setStringList('deletedEmails', _deletedEmails);
      
      // Also unstar if it was starred
      if (_starredEmails.contains(emailId)) {
        _starredEmails.remove(emailId);
        await _prefs.setStringList('starredEmails', _starredEmails);
      }
      
      notifyListeners();
    }
  }

  bool isDeleted(String emailId) => _deletedEmails.contains(emailId);
}
