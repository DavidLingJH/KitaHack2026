import 'package:flutter/material.dart';
import 'package:kitahack_frontend/GlassButton.dart';
import 'package:kitahack_frontend/homepage.dart';

class CameraCaptureScreen extends StatelessWidget {
  const CameraCaptureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Camera Capture",
          style: TextStyle(
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
            height: screenHeight*0.6,
            child: Center(
              // The Stack shrinks to fit its non-positioned children (the Image)
              child: Stack(
                children: [
                  // 1. The Background
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsetsGeometry.directional(bottom: 80),
                      child: Container(
                        color: Colors.grey[850], 
                      ),
                    )
                  ),
                  
                  // 2. The Image (The "Boss")
                  // Since this is NOT wrapped in Positioned, the Stack takes its size from this widget.
                  Image.asset(
                    'assets/images/Frame3.png',
                    fit: BoxFit.fitHeight, // Ensures the full frame is visible
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            // Math: Start 100px down + height of frame (60%) + 20px gap
            top: 35 + (screenHeight * 0.6), 
            left: 120, 
            right: 120,
            //ADD A COLUMN HERE
            child: Column(
              children: [
                Center(
                  child: GlassButton( // Replace with your actual widget class name
                    text: "Receipt",
                    onPressed: () {
                      // Handle tap
                    },
                  ),
                ),
                SizedBox(height: 60),
                GestureDetector(
                  onTap: () {
                    // Navigate to the new page here
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()), // Replace NextPage with your actual screen
                    );
                  },
                  child: Image.asset(
                    'assets/images/camera shutter (1).png',
                    height: 200,
                    fit: BoxFit.fitHeight,
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
              text: 'Capture a\nMeal', 
              onPressed: () {  },
              color: Colors.black,
            )
          )
        ],
      ),
    );
  }
}