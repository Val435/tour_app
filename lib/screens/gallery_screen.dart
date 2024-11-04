import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tour_app/screens/image_screen.dart';
import 'package:tour_app/screens/video_screen.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<FileSystemEntity> _mediaFiles = [];

  @override
  void initState() {
    super.initState();
    _loadMediaFiles();
  }

  Future<void> _loadMediaFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      _mediaFiles = directory.listSync().where((file) {
        return file.path.endsWith('.jpg') || file.path.endsWith('.mp4');
      }).toList();
    });
  }

  Future<Widget> _getThumbnail(File file) async {
    try {
      if (file.path.endsWith('.mp4')) {
        // Usa VideoPlayerController para cargar el primer cuadro del video
        VideoPlayerController controller = VideoPlayerController.file(file);
        await controller.initialize();
        controller.setLooping(false);
        controller.pause(); // Pausa en el primer cuadro

        return AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        );
      } else if (file.path.endsWith('.jpg')) {
        return Image.file(file, fit: BoxFit.cover);
      } else {
        return Icon(Icons.error, color: Colors.red);
      }
    } catch (e) {
      print("Error al cargar el video para la miniatura: $e");
      return Icon(Icons.error, color: Colors.red);
    }
  }

  void _openMedia(FileSystemEntity file) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return file.path.endsWith('.jpg')
              ? FullScreenImageScreen(imageFile: File(file.path))
              : VideoPlayerScreen(videoFile: File(file.path));
        },
      ),
    );

    // Si result es true, recarga la galería
    if (result == true) {
      _loadMediaFiles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Galería'),
        backgroundColor: Colors.black,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: _mediaFiles.length,
        itemBuilder: (context, index) {
          final file = _mediaFiles[index];
          return FutureBuilder<Widget>(
            future: _getThumbnail(File(file.path)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return GestureDetector(
                  onTap: () => _openMedia(file),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      snapshot.data!,
                      if (file.path.endsWith('.mp4'))
                        Icon(Icons.play_circle_outline,
                            color: Colors.white, size: 30),
                    ],
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
        },
      ),
    );
  }
}
