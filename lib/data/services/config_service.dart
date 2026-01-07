import 'package:shared_preferences/shared_preferences.dart';

class ConfigService {
  static const String _basePathKey = 'base_path';
  static const String _themeModeKey = 'theme_mode';
  static const String _notificationsEnabledKey = 'notifications_enabled';
  
  static const String _defaultPath = r'C:\ruta\por\defecto';

  // Obtener la ruta base configurada
  Future<String> getBasePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_basePathKey) ?? _defaultPath;
  }

  // Guardar la ruta base
  Future<void> setBasePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_basePathKey, path);
  }

  // Obtener el modo de tema (0=light, 1=dark, 2=system)
  Future<int> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_themeModeKey) ?? 0;
  }

  // Guardar el modo de tema
  Future<void> setThemeMode(int mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode);
  }

  // Verificar si las notificaciones están habilitadas
  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsEnabledKey) ?? true;
  }

  // Habilitar/deshabilitar notificaciones
  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);
  }
}