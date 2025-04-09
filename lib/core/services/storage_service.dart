
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _onboardingCompleteKey = 'onboarding_complete';
  static const String _themeKey = 'app_theme'; // Key for theme preference

  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // --- Onboarding --- //
  Future<bool> isOnboardingComplete() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  Future<void> setOnboardingComplete(bool value) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_onboardingCompleteKey, value);
  }

  // --- Theme Preference --- //
  Future<String?> getTheme() async {
    final prefs = await _getPrefs();
    return prefs.getString(_themeKey); // Returns null if not set
  }

  Future<void> setTheme(String themeName) async {
    final prefs = await _getPrefs();
    await prefs.setString(_themeKey, themeName);
  }
}
