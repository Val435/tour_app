import 'package:flutter/material.dart';
import 'dart:io';

class FullScreenImageScreen extends StatelessWidget {
  final File imageFile;

  FullScreenImageScreen({required this.imageFile});

  void _deleteImage(BuildContext context) async {
    try {
      if (await imageFile.exists()) {
        await imageFile.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Imagen eliminada con éxito"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(
            context, true); // Regresa a la galería y notifica el cambio
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No se pudo eliminar la imagen. Inténtalo de nuevo."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Visualización Imagen'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteImage(context),
          ),
        ],
      ),
      body: Center(
        child: Image.file(imageFile),
      ),
    );
  }
}
