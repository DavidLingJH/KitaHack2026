import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:kitahack_frontend/GlassButton.dart';
import 'package:kitahack_frontend/camera%20result.dart';
import 'package:kitahack_frontend/main.dart'; // IMPORTANT: Gives access to globalCameras

class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  bool isReceiptMode = true;
  
  // 1. Add Camera Variables
  CameraController? controller;
  bool isCameraReady = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // 2. Initialize the Camera
  Future<void> _initializeCamera() async {
    if (globalCameras.isNotEmpty) {
      // Using the first camera (usually the rear lens)
      controller = CameraController(globalCameras[0], ResolutionPreset.max);
      try {
        await controller!.initialize();
        if (mounted) {
          setState(() {
            isCameraReady = true;
          });
        }
      } catch (e) {
        debugPrint("Camera Error: $e");
      }
    }
  }

  @override
  void dispose() {
    // 3. Free the camera when the user leaves the screen
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          isReceiptMode ? "Receipt Capture" : "Meal Capture",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/Wall Upper.png',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.3, 
              width: double.infinity, 
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Wall Bottom.png'), 
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            height: screenHeight * 0.6,
            child: Center(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 80, left: 10, right: 10, top: 10),
                      // 4. THE LIVE CAMERA FEED
                      child: isCameraReady && controller != null
                          ? ClipRect( // Keeps the feed from spilling out of the bounds
                              child: OverflowBox(
                                alignment: Alignment.center,
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                    width: controller!.value.previewSize?.height ?? 1,
                                    height: controller!.value.previewSize?.width ?? 1,
                                    child: CameraPreview(controller!),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              // Fallback while loading
                              color: Colors.grey[850], 
                              child: const Center(
                                child: CircularProgressIndicator(color: Colors.white),
                              ),
                            ),
                    )
                  ),
                  Image.asset(
                    'assets/images/Frame3.png',
                    fit: BoxFit.fitHeight, 
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 35 + (screenHeight * 0.6), 
            left: 120, 
            right: 120,
            child: Column(
              children: [
                const SizedBox(height: 60),
                GestureDetector(
                  onTap: () async {
                    // Prevent tapping if camera isn't ready
                    if (!isCameraReady || controller == null) return;

                    try {
                      final XFile photoFile = await controller!.takePicture();
                      if (!mounted) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Result(imagePath: photoFile.path), 
                        ), 
                      );
                    } catch (e) {
                      debugPrint("Failed to take picture: $e");
                    }
                  },
                  child: Container(
                    height: 80, 
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white, // The background of the button
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.camera_alt_rounded, // The camera icon itself
                        size: 40, // Adjust size as needed
                        color: Colors.black87, // Dark color for good contrast against the white
                      ),
                    ),
                  ),
                ),
              ],
            )
          ),
          Positioned(
            bottom: 10,
            left: 10,
            width: 120,
            child: GlassButton(
              text: isReceiptMode ? 'Capture a\nMeal' : 'Capture a\nReceipt', 
              color: Colors.black,
              onPressed: () { 
                setState(() {
                  isReceiptMode = !isReceiptMode;
                });
              },
            )
          )
        ],
      ),
    );
  }
}