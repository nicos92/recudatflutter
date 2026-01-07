import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/services/config_service.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final ConfigService _configService = ConfigService();
  final TextEditingController _pathController = TextEditingController();
  
  int _selectedThemeMode = 0;
  bool _notificationsEnabled = true;
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    try {
      String basePath = await _configService.getBasePath();
      int themeMode = await _configService.getThemeMode();
      bool notificationsEnabled = await _configService.areNotificationsEnabled();
      
      setState(() {
        _pathController.text = basePath;
        _selectedThemeMode = themeMode;
        _notificationsEnabled = notificationsEnabled;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar la configuración: $e')),
      );
    }
  }

  Future<void> _saveConfig() async {
    try {
      await _configService.setBasePath(_pathController.text);
      await _configService.setThemeMode(_selectedThemeMode);
      await _configService.setNotificationsEnabled(_notificationsEnabled);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configuración guardada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar la configuración: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveConfig,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Configuración de la Aplicación',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  
                  // Configuración de ruta
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ruta de Ejecución',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _pathController,
                            decoration: const InputDecoration(
                              labelText: 'Ruta base para comandos',
                              border: OutlineInputBorder(),
                              hintText: r'C:\ruta\de\ejecucion',
                            ),
                            keyboardType: TextInputType.url,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Esta ruta se usará para ejecutar el comando recover1 con los archivos DAT.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Configuración de tema
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tema de la Aplicación',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<int>(
                            value: _selectedThemeMode,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 0,
                                child: Text('Tema Claro'),
                              ),
                              DropdownMenuItem(
                                value: 1,
                                child: Text('Tema Oscuro'),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text('Sistema'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedThemeMode = value ?? 0;
                              });
                            },
                            hint: const Text('Seleccionar tema'),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Selecciona cómo deseas que se vea la aplicación.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Configuración de notificaciones
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Notificaciones',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          SwitchListTile(
                            title: const Text('Habilitar notificaciones'),
                            value: _notificationsEnabled,
                            onChanged: (value) {
                              setState(() {
                                _notificationsEnabled = value;
                              });
                            },
                          ),
                          const Text(
                            'Activa o desactiva las notificaciones de la aplicación.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Botón de guardar
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: _saveConfig,
                      icon: const Icon(Icons.save),
                      label: const Text('Guardar Configuración'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _pathController.dispose();
    super.dispose();
  }
}