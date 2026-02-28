import 'package:flutter/foundation.dart'; 
import 'dart:io'; 
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kitahack_frontend/GlassButton.dart';
import 'package:http/http.dart' as http; 

class Result extends StatefulWidget {
  final String imagePath; 
  final bool isRecipemode;

  const Result({super.key, required this.imagePath, required this.isRecipemode}); 

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  // 1. Define your array of information here
  final List<Map<String, dynamic>> scannedItems = [
    {
      "title": "Milk",
      "subtitle": "Amount: 2 litres",
      "imagePath": "assets/images/Milk.png",
    },
    {
      "title": "Chicken",
      "subtitle": "Amount: 2kg",
      "imagePath": "assets/images/Chicken.png", 
    },
    {
      "title": "Eggs",
      "subtitle": "Amount: 30 pieces",
      "imagePath": "assets/images/Eggs.png", 
    },
    {
      "title": "Cabbage",
      "subtitle": "Amount: 1kg",
      "imagePath": "assets/images/Cabbage.png", 
    },
  ];

  // Helper method to keep our UI code clean if an image fails to load
  Widget _buildFallbackError() {
    return Container(
      color: Colors.grey[300],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, color: Colors.grey, size: 50),
          Text("Image not found"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Result",
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
          SafeArea(
            child: Column(
              children: [
                // 2. THE COMBINED SCROLLABLE AREA (Image + List)
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    // We add 2 to the length: 1 for the image, 1 for the label
                    itemCount: scannedItems.length + 2, 
                    itemBuilder: (context, index) {
                      
                      // 👇 RENDER THE IMAGE PREVIEW AT INDEX 0 👇
                      if (index == 0) {
                        return Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 400), 
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                              child: AspectRatio(
                                aspectRatio: 3 / 4, 
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.15), 
                                        spreadRadius: 1, 
                                        offset: const Offset(0, 0), 
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: kIsWeb 
                                      ? Image.network(
                                          widget.imagePath, 
                                          fit: BoxFit.contain, 
                                          errorBuilder: (context, error, stackTrace) => _buildFallbackError(),
                                        )
                                      : Image.file(
                                          File(widget.imagePath), 
                                          fit: BoxFit.contain, 
                                          errorBuilder: (context, error, stackTrace) => _buildFallbackError(),
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      // 👇 RENDER THE "ITEMS" LABEL AT INDEX 1 👇
                      if (index == 1) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: InkWell( // 1. Added InkWell for tap functionality
                                onTap: () {
                                  print('Yes did it');
                                  // Trigger your uploadImage() or other logic here
                                },
                                borderRadius: BorderRadius.circular(15.0), // Matches your container radius
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffFBF5CF),
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.15), 
                                        spreadRadius: 2, 
                                        blurRadius: 10, 
                                        offset: const Offset(0, 0), 
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    "Items",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                    }

                      // 👇 RENDER THE SCANNED ITEMS FOR THE REST OF THE LIST 👇
                      // Subtract 2 from the index to map to the correct item in the scannedItems array
                      final item = scannedItems[index - 2]; 
                      return ResultWidget(
                        title: item["title"],
                        subtitle: item["subtitle"],
                        imagePath: item["imagePath"],
                        onEditPressed: () {
                          print("Edit pressed for ${item["title"]}");
                        },
                      );
                    },
                  ),
                ),
                
                // 3. FIXED BUTTONS AT THE BOTTOM
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 130,
                        child: GlassButton(
                          text: "Retake",
                          color: Colors.white, 
                          onPressed: () {
                            Navigator.pop(context); 
                          },
                        ),
                      ),
                      SizedBox(
                        width: 130,
                        child: GlassButton(
                          text: "Confirm",
                          color: Colors.green, 
                          onPressed: () {
                            // Optional: Show a quick success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Items confirmed!")),
                            );
                            // 👇 NAVIGATE BACK TO HOMEPAGE 👇
                            // This clears the navigation stack until it reaches the first route
                            Navigator.popUntil(context, (route) => route.isFirst);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}

// --- Your existing ResultWidget ---
class ResultWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback onEditPressed;

  const ResultWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), 
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8CD), 
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15), 
            spreadRadius: 2, 
            blurRadius: 10, 
            offset: const Offset(0, 0), 
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 50,
              height: 60,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                width: 50, 
                height: 60, 
                child: Icon(Icons.broken_image, color: Colors.grey)
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black),
              onPressed: onEditPressed,
            ),
          ],
        ),
      ),
    );
  }
}