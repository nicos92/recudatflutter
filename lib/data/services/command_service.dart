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
  
  // Copiar archivo con formato de fecha y hora
  Future<CommandResult> copyFileWithTimestamp(String fileName) async {
    try {
      // Asegurarse de tener la ruta base
      if (_basePath == null) {
        await initialize();
      }
      
      // Construir la ruta completa del archivo original
      String sourcePath = '$_basePath\\$fileName';
      
      // Verificar si el archivo existe
      File sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        throw Exception('El archivo no existe: $sourcePath');
      }

      // Generar timestamp en formato YYYYMMDDHHMMSS
      DateTime now = DateTime.now();
      String timestamp = '${now.year}'
          '${now.month.toString().padLeft(2, '0')}'
          '${now.day.toString().padLeft(2, '0')}'
          '${now.hour.toString().padLeft(2, '0')}'
          '${now.minute.toString().padLeft(2, '0')}'
          '${now.second.toString().padLeft(2, '0')}';
      
      // Obtener la extensión del archivo original
      String extension = '';
      int lastDotIndex = fileName.lastIndexOf('.');
      if (lastDotIndex != -1) {
        extension = fileName.substring(lastDotIndex);
      }
      
      // Crear el nombre del archivo destino
      String baseFileName = fileName.substring(0, lastDotIndex != -1 ? lastDotIndex : fileName.length);
      String destinationFileName = '${baseFileName}_${timestamp}${extension}';
      String destinationPath = '$_basePath\\$destinationFileName';
      
      // Copiar el archivo
      await sourceFile.copy(destinationPath);
      
      return CommandResult(
        success: true,
        output: 'Archivo copiado exitosamente a: $destinationFileName',
        error: '',
        exitCode: 0,
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