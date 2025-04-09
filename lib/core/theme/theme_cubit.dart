
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/services/storage_service.dart'; // Import StorageService

class ThemeCubit extends Cubit<ThemeMode> {
  final StorageService _storageService;

  ThemeCubit(this._storageService) : super(ThemeMode.system) {
    _loadTheme(); // Load saved theme on initialization
  }

  // Load theme from storage
  Future<void> _loadTheme() async {
    final themeName = await _storageService.getTheme();
    if (themeName == 'light') {
      emit(ThemeMode.light);
    } else if (themeName == 'dark') {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.system);
    }
  }

  // Change theme and save preference
  Future<void> changeTheme(ThemeMode themeMode) async {
    String themeName;
    switch (themeMode) {
      case ThemeMode.light:
        themeName = 'light';
        break;
      case ThemeMode.dark:
        themeName = 'dark';
        break;
      case ThemeMode.system:
      default:
        themeName = 'system';
        break;
    }
    await _storageService.setTheme(themeName);
    emit(themeMode);
  }

  // Helper to toggle between light and dark
  void toggleTheme() {
    // If current theme is dark, switch to light. Otherwise, switch to dark.
    // Ignores system theme setting for direct toggle.
    final newTheme = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    changeTheme(newTheme);
  }
}
