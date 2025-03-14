import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en'); // Default to English
  final _storage = const FlutterSecureStorage(); // Persistent storage

  Locale get locale => _locale;

  LocaleProvider() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    String? languageCode = await _storage.read(key: 'language_code');
    if (languageCode != null) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _storage.write(key: 'language_code', value: locale.languageCode);
    notifyListeners();
  }
}