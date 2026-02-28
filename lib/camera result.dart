import 'package:flutter/material.dart';
import 'package:kitahack_frontend/GlassButton.dart';

class Result extends StatefulWidget {
  // 1. Create the variable here
  final String imagePath; 

  // 2. Require it in the constructor
  const Result({super.key, required this.imagePath}); 

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
      "imagePath": "assets/images/Chicken.png", // Replace with an actual asset if you have one
    },
    {
      "title": "Eggs",
      "subtitle": "Amount: 30 pieces",
      "imagePath": "assets/images/Eggs.png", // Replace with an actual asset if you have one
    },
    {
      "title": "Cabbage",
      "subtitle": "Amount: 1kg",
      "imagePath": "assets/images/Cabbage.png", // Replace with an actual asset if you have one
    },
  ];

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
                // 2. Use Expanded and ListView.builder to make the list scrollable
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    itemCount: scannedItems.length,
                    itemBuilder: (context, index) {
                      final item = scannedItems[index];
                      return ResultWidget(
                        title: item["title"],
                        subtitle: item["subtitle"],
                        imagePath: item["imagePath"],
                        onEditPressed: () {
                          // TODO: Handle edit for this specific item
                          print("Edit pressed for ${item["title"]}");
                        },
                      );
                    },
                  ),
                ),
                
                // 3. Add the Retake and Confirm buttons at the bottom
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 130,
                        child: GlassButton(
                          text: "Retake",
                          color: Colors.white, // White glass look
                          onPressed: () {
                            Navigator.pop(context); // Goes back to the camera screen
                          },
                        ),
                      ),
                      SizedBox(
                        width: 130,
                        child: GlassButton(
                          text: "Confirm",
                          color: Colors.green, // A nice green tint for confirming
                          onPressed: () {
                            // TODO: Handle confirmation
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
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Tweaked margin slightly for a better list look
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
            // Added errorBuilder just in case the dummy assets don't exist yet so your app doesn't crash visually
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