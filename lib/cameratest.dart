import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io'; // Required for displaying the captured image file

// 1. Pass the cameras into the widget instead of hardcoding null
class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras; 
  
  const CameraPage({super.key, required this.cameras});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    // 2. Use the cameras passed from the widget
    if (widget.cameras.isNotEmpty) {
      controller = CameraController(widget.cameras[0], ResolutionPreset.max);
      controller.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      }).catchError((e) {
        print("Camera initialization error: $e");
      });
    }
  }

  @override
  void dispose() {
    controller.dispose(); 
    super.dispose();
  }

  Future<void> onTakePictureButtonPressed() async {
    try {
      if (!controller.value.isInitialized) return;

      XFile file = await controller.takePicture();

      if (!mounted) return;
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(imagePath: file.path),
        ),
      );
    } catch (e) {
      print("Error taking picture: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading spinner if camera isn't ready or doesn't exist
    if (widget.cameras.isEmpty || !controller.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 3. Wrapped in a Scaffold to add a FloatingActionButton
    return Scaffold(
      appBar: AppBar(title: const Text('Camera Test')),
      body: CameraPreview(controller),
      floatingActionButton: FloatingActionButton(
        onPressed: onTakePictureButtonPressed, // Calls your capture function
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// --- PLACEHOLDER SCREEN TO VIEW THE CAPTURED IMAGE ---
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // Image.file is used to load images from the device's local storage
      body: Center(child: Image.file(File(imagePath))), 
    );
  }
}