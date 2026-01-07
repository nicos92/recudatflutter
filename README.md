# Gestión de Archivos DAT

Una aplicación Flutter para Windows que permite gestionar archivos DAT y ejecutar comandos de recuperación.

## Características

- Gestión completa de tablas DAT y sectores
- Filtro por sectores y palabras clave
- Ejecución de comandos CMD (recover1)
- Configuración de rutas, tema y notificaciones
- Interfaz intuitiva con navegación por menú inferior

## Funcionalidades

### Gestión de Datos
- **Tablas DAT**: CRUD completo para gestionar archivos DAT con nombre, archivo, error, imagen de error, observación y sector
- **Sectores**: CRUD completo para gestionar sectores predefinidos

### Filtros y Búsqueda
- Filtrar tablas DAT por sector
- Búsqueda por nombre, archivo, error u observación
- Selección de filas para operaciones específicas

### Ejecución de Comandos
- Ejecutar el comando `recover1 {archivo} zz` para archivos DAT seleccionados
- Configuración de ruta base para la ejecución de comandos

### Configuración
- Configuración de ruta base para comandos
- Selección de tema (claro, oscuro, sistema)
- Habilitación/deshabilitación de notificaciones

## Instalación

1. Asegúrate de tener Flutter instalado en tu sistema
2. Clona o descarga este repositorio
3. Ejecuta `flutter pub get` para instalar las dependencias
4. Ejecuta `flutter run` para iniciar la aplicación

## Uso

1. **Inicio**: Vista principal con filtros y tabla de datos
2. **Sectores**: Gestión de sectores disponibles
3. **Tablas DAT**: Gestión de archivos DAT
4. **Configuración**: Configuración de la aplicación

## Estructura del Proyecto

```
lib/
├── data/
│   ├── models/          # Modelos de datos
│   ├── database/        # Base de datos SQLite
│   └── services/        # Servicios de negocio
└── ui/
    ├── pages/          # Páginas de la aplicación
    └── widgets/        # Widgets reutilizables
```

## Dependencias

- `sqflite`: Para la base de datos SQLite
- `path`: Para operaciones con rutas de archivos
- `process_run`: Para ejecutar comandos del sistema
- `shared_preferences`: Para almacenamiento de configuración

## Notas

- La aplicación está diseñada específicamente para Windows
- Los sectores predeterminados se insertan automáticamente en la base de datos
- La ruta base para comandos se puede configurar en la sección de configuración