import 'package:flutter/material.dart';
import 'package:kitahack_frontend/GlassButton.dart';
import 'package:kitahack_frontend/camera%20result.dart';

class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  // 2. Added a state variable to track the current mode
  bool isReceiptMode = true;

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
            height: screenHeight * 0.6,
            child: Center(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: Container(
                        color: Colors.grey[850], 
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
                Center(
                  child: GlassButton( 
                    // 3. Dynamically change text based on state
                    text: isReceiptMode ? "Receipt" : "Meal",
                    onPressed: () {
                      // Optional: You can also toggle the state by pressing this top button
                    },
                  ),
                ),
                const SizedBox(height: 60),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Result()), 
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
              // 4. Dynamically change the toggle button text
              text: isReceiptMode ? 'Capture a\nMeal' : 'Capture a\nReceipt', 
              color: Colors.black,
              onPressed: () { 
                // 5. Update the state and rebuild the UI
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