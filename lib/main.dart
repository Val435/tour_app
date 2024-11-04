import 'package:flutter/material.dart';
import 'screens/camera_screen.dart';
import 'screens/gallery_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(EcoTourismCameraApp());
}

class EcoTourismCameraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoTourism Camera',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => CameraScreen(),
        '/gallery': (context) => GalleryScreen(),
        '/settings': (context) => SettingsScreen(
              initialFilterState:
                  false, // Establece el valor inicial del filtro
              onFilterToggle: (bool isEnabled) {
                // Lógica para manejar el cambio de estado del filtro si es necesario
              },
            ),
      },
    );
  }
}
