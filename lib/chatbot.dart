import 'package:flutter/material.dart';
import 'package:kitahack_frontend/GlassButton.dart';

class Chatbot extends StatelessWidget {
  const Chatbot({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffF9EECA),
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Chatbot",
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
          Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              height: screenHeight * 0.6,
              width: screenWidth,
              child: Image.asset(
                "assets/images/robot.png",
                fit: BoxFit.contain,
                alignment: Alignment.bottomLeft,
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                height: screenHeight * 0.5,
                padding: const EdgeInsets.only(right: 30, top: 20),
                child: IntrinsicWidth(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Vertically center the group
                    crossAxisAlignment: CrossAxisAlignment.end,  // Align everything to the right
                    children: [
                      const Text(
                        "Hello!\nWhat would you\nlike to do today?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      
                      const SizedBox(height: 20), // Spacing between text and buttons
                      GlassButton(
                        text: "Generate a Recipe",
                        onPressed: () {},
                      ),
                      const SizedBox(height: 10), 
                      GlassButton(
                        text: "Generate Meal Plan",
                        onPressed: () {},
                      ),
                      const SizedBox(height: 10), 
                      GlassButton(
                        text: "Generate a Recipe",
                        onPressed: () {},
                      ),
                      const SizedBox(height: 10), 
                    ],
                  ),
                )
              ),
            ),
          )
        ],
      ),
    );
  }
}