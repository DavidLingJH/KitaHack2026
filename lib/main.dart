import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:kitahack_frontend/homepage.dart';

// 1. Removed the underscore so this variable is PUBLIC and accessible to homepage.dart
late List<CameraDescription> globalCameras;

Future<void> main() async {
  // 2. Ensure plugin services are initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();
  
  // 3. Fetch the list of available cameras with error handling
  try {
    globalCameras = await availableCameras();
  } catch (e) {
    globalCameras = []; // Fallback to an empty list so the app doesn't crash
    debugPrint('Camera initialization error: $e');
  }
  
  // 4. Run the app
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kitahack App', 
      home: HomePage(),
    );
  }
}