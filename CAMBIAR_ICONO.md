# Cambiar el Icono de la Aplicación Windows

Este documento explica cómo cambiar el icono predeterminado de Flutter por un icono personalizado en la aplicación Windows.

## Pasos para Cambiar el Icono

### Paso 1: Preparar el Archivo de Icono

1. Crea o obtén una imagen que deseas usar como icono (formato PNG, JPG, etc.)
2. Convierte la imagen al formato ICO con múltiples tamaños (16x16, 32x32, 48x48, 256x256)
   - Puedes usar herramientas online como:
     - https://icoconvert.com/
     - https://www.favicon-generator.org/
     - https://convertio.co/png-ico/
   - O programas como GIMP, Photoshop o IcoFX

### Paso 2: Reemplazar el Archivo de Icono

1. Navega al directorio: `windows/runner/resources/`
2. Localiza el archivo `app_icon.ico`
3. Haz una copia de seguridad del archivo original (opcional)
4. Reemplaza `app_icon.ico` con tu archivo de icono personalizado manteniendo el mismo nombre

### Paso 3: Reconstruir la Aplicación

Después de reemplazar el archivo de icono, debes reconstruir la aplicación:

```bash
flutter clean
flutter build windows --release
```

## Notas Importantes

- El archivo debe mantener el nombre `app_icon.ico` para que funcione correctamente
- Asegúrate de que el archivo ICO contenga múltiples tamaños para una mejor calidad en diferentes resoluciones
- El icono aparecerá en:
  - La barra de título de la ventana
  - La barra de tareas de Windows
  - El menú Inicio (si se fija la aplicación)
  - El explorador de archivos

## Verificación

Después de reconstruir la aplicación, puedes verificar que el icono haya cambiado:

1. Ejecuta la aplicación en modo debug: `flutter run -d windows`
2. O compila la versión de lanzamiento: `flutter build windows --release`
3. Verifica que el nuevo icono aparezca en la ventana y en la barra de tareas

## Recomendaciones

- Usa imágenes con fondo transparente para mejores resultados
- Asegúrate de que el diseño del icono sea reconocible incluso en tamaños pequeños
- Considera crear un diseño específico para los tamaños pequeños (16x16, 32x32) para mayor claridad