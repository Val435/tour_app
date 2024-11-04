import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:image/image.dart' as img;
import 'gallery_screen.dart';
import 'settings_screen.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool _isRecording = false;
  bool _isFrontCamera = false;
  bool _isFlashOn = false;
  double _zoomLevel = 1.0;
  bool _applyFilter = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras == null || cameras!.isEmpty) {
        _showError("No se encontró ninguna cámara en el dispositivo.");
        return;
      }

      _controller = CameraController(
        cameras![_isFrontCamera ? 1 : 0],
        ResolutionPreset.high,
        enableAudio: true,
      );

      await _controller!.initialize();
      setState(() {});
    } catch (e) {
      _showError("Error al iniciar la cámara. Inténtalo de nuevo.");
    }
  }

  Future<void> _capturePhoto() async {
    if (!_controller!.value.isInitialized) return;

    try {
      XFile photo = await _controller!.takePicture();
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      if (_applyFilter) {
        final originalImage = img.decodeImage(await photo.readAsBytes());
        final filteredImage = _applyNatureFilter(originalImage!);
        await File(filePath).writeAsBytes(img.encodeJpg(filteredImage));
      } else {
        await photo.saveTo(filePath);
      }

      _showMessage("Foto guardada con éxito.");
    } catch (e) {
      _showError("No se pudo capturar la foto. Inténtalo de nuevo.");
    }
  }

  img.Image _applyNatureFilter(img.Image image) {
    // Aumenta la saturación y el contraste manualmente
    img.adjustColor(image, saturation: 1.5, contrast: 1.2);

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        int pixel = image.getPixel(x, y);
        int r = img.getRed(pixel);
        int g = img.getGreen(pixel);
        int b = img.getBlue(pixel);

        // Aumenta los tonos de verde y azul
        g = (g * 1.2).clamp(0, 255).toInt();
        b = (b * 1.1).clamp(0, 255).toInt();

        image.setPixel(x, y, img.getColor(r, g, b));
      }
    }
    return image;
  }

  Future<void> _startRecording() async {
    if (!_controller!.value.isInitialized || _isRecording) return;
    try {
      await _controller!.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
      _showMessage("Grabación iniciada.");
    } catch (e) {
      _showError("No se pudo iniciar la grabación. Inténtalo de nuevo.");
    }
  }

  Future<void> _stopRecording() async {
    if (!_controller!.value.isInitialized || !_isRecording) return;

    try {
      XFile video = await _controller!.stopVideoRecording();
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
      await video.saveTo(filePath);

      _showMessage("Video guardado con éxito.");

      setState(() {
        _isRecording = false;
      });
    } catch (e) {
      _showError("No se pudo detener la grabación. Inténtalo de nuevo.");
    }
  }

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    _controller?.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
    _showMessage("Flash ${_isFlashOn ? 'activado' : 'desactivado'}.");
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onScaleUpdate: (ScaleUpdateDetails details) async {
          // Control de zoom mediante pellizco
          if (details.scale != 1.0) {
            double newZoomLevel = _zoomLevel * details.scale;
            newZoomLevel = newZoomLevel.clamp(1.0, 4.0);
            setState(() {
              _zoomLevel = newZoomLevel;
            });
            await _controller?.setZoomLevel(_zoomLevel);
          }
        },
        onTapUp: (TapUpDetails details) async {
          // Enfoque en la posición tocada
          final offset = details.localPosition;
          final screenSize = MediaQuery.of(context).size;
          final focusX = offset.dx / screenSize.width;
          final focusY = offset.dy / screenSize.height;
          await _controller?.setFocusPoint(Offset(focusX, focusY));
          await _controller?.setFocusMode(FocusMode.locked);
          _showMessage("Enfoque ajustado.");
        },
        child: Column(
          children: [
            Expanded(
              child: CameraPreview(_controller!),
            ),
            _buildBottomBar(),
            SizedBox(height: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 120,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.flash_on,
                color: _isFlashOn ? Colors.yellow : Colors.white),
            onPressed: _toggleFlash,
            iconSize: 24,
          ),
          IconButton(
            icon: Icon(Icons.switch_camera, color: Colors.white),
            onPressed: () {
              setState(() {
                _isFrontCamera = !_isFrontCamera;
                _initializeCamera();
              });
            },
            iconSize: 24,
          ),
          GestureDetector(
            onTap: () {
              if (_isRecording) {
                _stopRecording();
              } else {
                _capturePhoto();
              }
            },
            onLongPress: _startRecording,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: _isRecording ? Colors.red : Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.photo_library, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GalleryScreen()),
            ),
            iconSize: 24,
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    initialFilterState: _applyFilter,
                    onFilterToggle: (bool isEnabled) {
                      setState(() {
                        _applyFilter = isEnabled;
                      });
                    },
                  ),
                ),
              );
            },
            iconSize: 24,
          ),
        ],
      ),
    );
  }
}
