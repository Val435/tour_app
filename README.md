
# Documentación de la Aplicación de Cámara para Turismo Ecológico

## Descripción General

Esta aplicación de cámara para turismo ecológico permite capturar fotos, grabar videos, y ajustar configuraciones de la cámara, como el zoom, el enfoque, el flash y la aplicación de un filtro de color para mejorar la calidad de las capturas en entornos naturales. La interfaz es intuitiva y accesible, permitiendo a los usuarios (guías turísticos) capturar y visualizar contenido multimedia de forma rápida y sencilla.

---

## Bibliotecas Utilizadas

- **flutter/material.dart**: Biblioteca principal de Flutter para la construcción de interfaces de usuario.
- **camera.dart**: Permite acceder a la cámara del dispositivo, capturar fotos, grabar videos, y configurar opciones como zoom, flash y enfoque.
- **path_provider.dart**: Proporciona rutas a directorios del sistema para almacenar fotos y videos capturados.
- **dart:io**: Para la manipulación de archivos (guardado, eliminación y verificación de existencia).
- **image.dart**: Biblioteca para aplicar filtros de procesamiento de imágenes, en este caso, se usa para mejorar el contraste y la saturación.
- **video_player.dart**: Utilizado para reproducir videos dentro de la aplicación y generar miniaturas para los videos en la galería.

---

## Descripción del Código y Funcionalidades

### `main.dart`
Archivo principal de la aplicación que configura las rutas de navegación y define el tema visual.

- **EcoTourismCameraApp**: Define las rutas de la aplicación (`/`, `/gallery`, y `/settings`) para navegar entre la pantalla de la cámara, la galería, y la configuración.

### `CameraScreen`

La pantalla principal de la cámara, donde el usuario puede capturar fotos, grabar videos, y ajustar configuraciones de la cámara.

#### Variables Principales

- `_controller`: Controlador de la cámara, inicializado con la cámara seleccionada y configurado con una resolución alta.
- `_isRecording`, `_isFrontCamera`, `_isFlashOn`, `_applyFilter`: Variables de estado que indican si se está grabando, qué cámara está activa (frontal o trasera), si el flash está activado, y si el filtro está activado respectivamente.
_zoomLevel, _focusLevel: Niveles de zoom y enfoque. El nivel de zoom se ajusta mediante gestos de pellizco y el enfoque mediante un toque en la pantalla.
#### Funciones Importantes

- **_initializeCamera**: Inicializa la cámara seleccionada y configura la resolución.
- **_capturePhoto**: Captura una foto, aplica un filtro de color opcionalmente, y la guarda en un directorio específico.
- **_startRecording** y **_stopRecording**: Inician y detienen la grabación de video. Al detener la grabación, el video se guarda en un directorio específico.
- **_toggleFlash**: Alterna el estado del flash entre activado y desactivado.
- **_showMessage** y **_showError**: Muestran mensajes de éxito y error en un `SnackBar` para dar retroalimentación al usuario.

#### Widgets Clave

- **CameraPreview**: Muestra la vista previa de la cámara en la pantalla.
- **GestureDetector**: Detecta gestos en la pantalla, como pellizcos para el zoom y toques para el enfoque.
- **_buildBottomBar**: Barra inferior que contiene los botones para cambiar de cámara, activar el flash, abrir la galería y acceder a la configuración.

### `GalleryScreen`

Pantalla de galería donde el usuario puede ver las fotos y videos capturados.

#### Variables Principales

- `_mediaFiles`: Lista de archivos multimedia (fotos y videos) obtenidos del directorio de almacenamiento.

#### Funciones Importantes

- **_loadMediaFiles**: Carga los archivos multimedia (fotos y videos) desde el directorio de almacenamiento.
- **_getThumbnail**: Genera una miniatura para cada archivo de video utilizando el primer cuadro del video.
- **_openMedia**: Abre el archivo seleccionado en pantalla completa; fotos y videos se abren en sus pantallas respectivas.

#### Widgets Clave

- **GridView.builder**: Muestra la galería de archivos multimedia en una cuadrícula. Cada elemento puede ser una foto o una miniatura de video con un icono de reproducción.

### `SettingsScreen`

Pantalla de configuración que permite activar o desactivar el filtro de color para las fotos capturadas.

#### Variables Principales

- `_isFilterEnabled`: Estado del switch que activa o desactiva el filtro de color.

#### Funciones Importantes

- **onFilterToggle**: Notifica el cambio en el estado del filtro al controlador de la cámara.

#### Widgets Clave

- **ListTile**: Contiene un switch que permite activar o desactivar el filtro de color.

### `FullScreenImageScreen`

Pantalla para visualizar una imagen en pantalla completa y opción para eliminarla.

#### Funciones Importantes

- **_deleteImage**: Elimina el archivo de imagen y notifica a la galería del cambio. Muestra un mensaje de confirmación o error al usuario.

### `VideoPlayerScreen`

Pantalla para reproducir un video en pantalla completa y opción para eliminarlo.

#### Variables Principales

- `_controller`: Controlador de `VideoPlayer` que administra la reproducción del video.
- `_isInitialized`: Indica si el video está listo para ser reproducido.

#### Funciones Importantes

- **_initializeVideoPlayer**: Inicializa el controlador del video y comienza la reproducción.
- **_deleteVideo**: Elimina el archivo de video y notifica a la galería del cambio. Muestra un mensaje de confirmación o error al usuario.

#### Widgets Clave

- **AspectRatio**: Muestra el video en pantalla completa, manteniendo la relación de aspecto original.
- **FloatingActionButton**: Controla la reproducción y pausa del video.

---

## Decisiones de Diseño

1. **Interfaz Intuitiva**: La interfaz ha sido diseñada para que los botones estén claramente identificados y sean accesibles con una sola mano. La barra de controles de la cámara está en la parte inferior, mientras que los controles de zoom y enfoque están a los lados para facilitar el acceso.
2. **Mensajes Amigables**: Se utilizan `SnackBar` para mostrar mensajes de éxito y error. Esto asegura que el usuario reciba retroalimentación visual inmediata sobre cada operación.
3. **Filtros de Color Opcionales**: La opción de activar un filtro de color en la configuración permite mejorar la calidad de las fotos sin sobrecargar al usuario con opciones adicionales.
4. **Miniaturas de Video**: La galería utiliza el primer cuadro del video como miniatura, lo cual mejora la experiencia visual en la galería y facilita la identificación de los videos.
5. **Reproducción de Video en Pantalla Completa**: Se usa `VideoPlayer` para la reproducción en pantalla completa y un botón de control para pausar o reproducir el video.

---

## Conclusión

La aplicación de cámara para turismo ecológico proporciona una interfaz funcional y fácil de usar para guías turísticos, permitiéndoles capturar y gestionar contenido multimedia de manera eficiente. Las funciones avanzadas, como los controles de zoom y enfoque, junto con los mensajes de retroalimentación amigables, mejoran la experiencia del usuario en entornos naturales, cumpliendo así con el propósito de la aplicación.
