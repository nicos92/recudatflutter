# Flutter Project: flutter_idea_uno

## Project Overview

This is a Flutter application project named `flutter_idea_uno`. It's a Windows application for managing DAT files and executing recovery commands. The project follows a layered architecture approach with a modular structure organized into different directories for data models, database, services, UI pages, and widgets. The project is configured to use Material Design and includes SQLite for data persistence.

## Project Structure

```
flutter_idea_uno/
├── lib/
│   ├── data/
│   │   ├── models/                  # Data models (TablasDat, Sector)
│   │   ├── database/                # SQLite database helper
│   │   └── services/                # Business logic services
│   ├── ui/
│   │   ├── pages/                   # UI screens (Home, Config, CRUD pages)
│   │   └── widgets/                 # Reusable UI components
│   └── main.dart                    # Application entry point
├── test/
│   └── widget_test.dart             # Widget tests
├── pubspec.yaml                     # Project dependencies and assets
├── analysis_options.yaml            # Linting and analysis configuration
├── README.md                        # Project documentation
└── windows/                         # Windows-specific files (desktop app)
    ├── flutter/
    ├── runner/
    ├── .gitignore
    └── CMakeLists.txt
```

## Key Technologies and Dependencies

- **Flutter SDK**: ^3.10.4
- **Dart SDK**: ^3.10.4
- **Dependencies**:
  - flutter (SDK)
  - cupertino_icons: ^1.0.8
  - sqflite: ^2.3.0 (SQLite database)
  - path: ^1.8.3 (path operations)
  - process_run: ^0.13.0 (system command execution)
  - shared_preferences: ^2.2.2 (configuration storage)
- **Dev Dependencies**:
  - flutter_test (SDK)
  - flutter_lints: ^6.0.0

## Architecture

The project follows a clean architecture pattern:
- **data/models**: Data models representing TablasDat and Sector entities
- **data/database**: SQLite database helper with table creation and CRUD operations
- **data/services**: Business logic services for data operations and command execution
- **ui/pages**: UI screens for home, configuration, and CRUD operations
- **ui/widgets**: Reusable UI components like the DAT table widget

## Building and Running

### Prerequisites
- Flutter SDK installed (version 3.10.4 or higher)
- Windows development tools for desktop applications

### Setup
1. Clone or download the project
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies

### Running the Application
- For development: `flutter run`
- For Windows specifically: `flutter run -d windows`

### Building the Application
- Debug build: `flutter build windows`
- Release build: `flutter build windows --release`

### Testing
- Run all tests: `flutter test`
- Run widget tests: `flutter test test/widget_test.dart`

### Code Analysis
- Check for issues: `flutter analyze`
- Format code: `flutter format lib/ test/`

## Features

### Data Management
- **TablasDat**: Full CRUD for managing DAT files with properties (id, nombre, archivo, error, img_error, observación, id_sector)
- **Sectores**: Full CRUD for managing sectors with 17 predefined sectors

### Main Features
- **Home Screen**: Filter DAT files by sector and keywords, execute recovery commands
- **Configuration**: Set base path for commands, theme preferences, and notification settings
- **Command Execution**: Execute `recover1 {archivo} zz` command for selected DAT files
- **Navigation**: Bottom navigation for easy access to different sections

### Predefined Sectors
1. Producción de Despostada
2. Control de Stock
3. Producción de Cuarteo
4. Ingreso de Hacienda
5. Ventas Carne Sub - Prod
6. Compras de Hacienda
7. Proveedores Varios
8. Proveedores Carnes-Sub Prod.
9. Gestión Exportación
10. Caja y Bancos
11. Contabilidad General
12. Sueldos y Jornales
13. Bascula de Entrada
14. Archivos de Sistema
15. Faena Porcina
16. Ciclo 3
17. Cámara Remate

## Current State

The project is a fully functional Windows application with:
- SQLite database with automatic table creation and predefined sectors
- Complete CRUD operations for both entities
- Main screen with filtering and command execution
- Configuration screen for paths, themes, and notifications
- Responsive UI with Material Design components
- Proper error handling and user feedback

## Version Information

- Application version: 1.0.0+1
- Target platform: Windows desktop application
- Private package (not intended for publication to pub.dev)