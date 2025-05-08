import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;
  
  bool get isArabic => _locale.languageCode == 'ar';

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('language_code');
    
    if (savedLanguage != null) {
      _locale = Locale(savedLanguage);
      notifyListeners();
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (languageCode == _locale.languageCode) return;
    
    _locale = Locale(languageCode);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    
    notifyListeners();
  }
}