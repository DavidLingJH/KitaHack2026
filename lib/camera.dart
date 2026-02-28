import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:kitahack_frontend/GlassButton.dart';
import 'package:kitahack_frontend/camera%20result.dart';
import 'package:kitahack_frontend/main.dart'; // IMPORTANT: Gives access to globalCameras
import 'package:http/http.dart' as http; 
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';

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
      controller = CameraController(
        globalCameras[0], 
        ResolutionPreset.max,
        enableAudio: false
      );
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

  //  Future<void> extractReceipt(Uint8List imageBytes) async {
  //     try {
  //       var request = http.MultipartRequest(
  //         'POST',
  //         Uri.parse('http://localhost:8000/extract-receipt'),
  //       );

  //       request.files.add(
  //         http.MultipartFile.fromBytes(
  //           'image',
  //           imageBytes,
  //           filename: 'receipt.jpg',
  //         ),
  //       );

  //       var streamedResponse = await request.send();
  //       var response = await http.Response.fromStream(streamedResponse);

  //       print('Status: ${response.statusCode}');
  //       print('Body: ${response.body}');
  //     } catch (e) {
  //       print('Upload failed: $e');
  //     }
  //   }

  // Future<void> pickImage() async {
  //     final picker = ImagePicker();

  //     final pickedFile = await picker.pickImage(
  //       source: ImageSource.camera,
  //     );

  //     if (pickedFile != null) {
  //         Uint8List bytes = await pickedFile.readAsBytes();
  //         extractReceipt(bytes); // call your upload function
  //     } else {
  //       print("No image selected");
  //     }
  // }

  // Future<void> extractItem(path) async {
  //   var request = http.MultipartRequest('POST', Uri.parse('http://127.0.0.1:8000/extract-item'));
    
  //   // This is how you "pass" the file to the request
  //   request.files.add(
  //     await http.MultipartFile.fromPath(
  //       'image', // This is the 'key' your backend expects
  //       path, 
  //     )
  //   );

  //   var response = await request.send();
  //   print(response);
  // }

  Future<String?> uploadImageWeb(XFile photoFile, bool isReceipt) async {
      try {
        // Convert XFile to bytes for web compatibility
        Uint8List imageBytes = await photoFile.readAsBytes();
        
        String endpoint = isReceipt ? '/extract-receipt' : '/extract-item';
        
        // Note: Use your actual server URL. 
        // 'localhost' works for web-to-local, but check CORS settings on your backend!
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://localhost:8000$endpoint'),
        );

        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            imageBytes,
            filename: 'upload.jpg',
          ),
        );

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          print(response.body); // Return the JSON data from your API
          return(response.body);
        } else {
          debugPrint('Server Error: ${response.statusCode}');
          return null;
        }
      } catch (e) {
        debugPrint('Upload Error: $e');
        return null;
      }
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
                      // 1. Capture the photo
                      final XFile photoFile = await controller!.takePicture();

                      // 2. Show Loading Overlay
                      if (!mounted) return;
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      );

                      // 3. Upload to API
                      String? apiResponse = await uploadImageWeb(photoFile, isReceiptMode);
                      

                      // 4. Close Loading Overlay
                      if (!mounted) return;
                      Navigator.pop(context); 

                      if (apiResponse != null) {
                        // 5. Navigate and pass the API data
                        List<dynamic> parsedList = jsonDecode(apiResponse);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Result(
                              imagePath: photoFile.path, // This is the Blob URL for the <img> tag
                              scannedItems: parsedList,
                              isRecipemode: isReceiptMode,
                              // apiData: apiResponse, // Pass your parsed JSON here
                            ), 
                          ), 
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Failed to process image. Check CORS settings.")),
                        );
                      }
                    } catch (e) {
                      debugPrint("Capture failed: $e");
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