import 'package:flutter/foundation.dart';
import 'config_service.dart';

class ThemeService extends ChangeNotifier {
  final ConfigService _configService = ConfigService();
  int _currentThemeMode = 0; // 0: light, 1: dark, 2: system

  int get currentThemeMode => _currentThemeMode;

  ThemeService() {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    _currentThemeMode = await _configService.getThemeMode();
    notifyListeners();
  }

  Future<void> setThemeMode(int themeMode) async {
    await _configService.setThemeMode(themeMode);
    _currentThemeMode = themeMode;
    notifyListeners();
  }

  Future<void> refreshThemeMode() async {
    await _loadThemeMode();
  }
}

// Singleton instance
final themeService = ThemeService();