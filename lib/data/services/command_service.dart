import 'dart:io';
import 'package:process_run/process_run.dart';
import 'config_service.dart';

class CommandService {
  final ConfigService _configService = ConfigService();
  String? _basePath;

  // Inicializar la ruta base desde la configuración
  Future<void> initialize() async {
    _basePath = await _configService.getBasePath();
  }

  // Ejecutar el comando recover1
  Future<CommandResult> executeRecover1Command(String fileName) async {
    try {
      // Asegurarse de tener la ruta base
      if (_basePath == null) {
        await initialize();
      }

      // Construir la ruta completa del archivo
      String fullPath = '$_basePath\\$fileName';

      // Verificar si el archivo existe
      File file = File(fullPath);
      if (!await file.exists()) {
        throw Exception('El archivo no existe: $fullPath');
      }

      // Ejecutar el comando: recover1 {archivo} zz
      String command = 'recover1';
      List<String> arguments = [fullPath, 'zz'];

      // Usar runExecutableArguments para ejecutar el comando
      var result = await runExecutableArguments(command, arguments,
        workingDirectory: _basePath!,
        runInShell: true
      );

      return CommandResult(
        success: result.exitCode == 0,
        output: result.stdout.toString(),
        error: result.stderr.toString(),
        exitCode: result.exitCode,
      );
    } catch (e) {
      return CommandResult(
        success: false,
        output: '',
        error: e.toString(),
        exitCode: -1,
      );
    }
  }
}

class CommandResult {
  final bool success;
  final String output;
  final String error;
  final int exitCode;

  CommandResult({
    required this.success,
    required this.output,
    required this.error,
    required this.exitCode,
  });
}