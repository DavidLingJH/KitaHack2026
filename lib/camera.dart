import 'package:flutter/material.dart';

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
          // This widget takes up 70% of the vertical space
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
        ],
      ),
    );
  }
}