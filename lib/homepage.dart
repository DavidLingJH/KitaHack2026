import 'dart:ui'; // Required for the glass effect
import 'package:flutter/material.dart';
import 'package:kitahack_frontend/chatbot.dart';

// Import your actual pages here
// import 'chatbot.dart'; 
// import 'camera_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Using a gradient background to make the glass effect pop
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xffF9EECA), // Your cream color
              Color(0xffFFD700), // A slightly darker gold/orange for contrast
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. The Header
                const SizedBox(height: 20),
                const Text(
                  "Hello, Chef!",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Text(
                  "What are we cooking today?",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                
                const SizedBox(height: 50),

                // 2. The Two Main Functions
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // OPTION A: AI Chatbot / Recipe Generator
                      MenuCard(
                        title: "AI Assistant",
                        subtitle: "Generate recipes from preferences",
                        icon: Icons.chat_bubble_outline_rounded,
                        color: Colors.orangeAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Chatbot(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 30),

                      // OPTION B: Camera Capture
                      MenuCard(
                        title: "Scan Ingredients",
                        subtitle: "Snap a photo and analyse it",
                        icon: Icons.camera_alt_outlined,
                        color: Colors.lightGreen,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              // REPLACE 'PlaceholderScreen' with your Camera Widget
                              builder: (context) => const PlaceholderScreen(title: "Camera"),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------
// CUSTOM WIDGET: The Glass Menu Card
// -----------------------------------------------------------
class MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 160, // Fixed height for consistency
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3), // Glassy white base
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.2), // Shadow matches the icon color
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              splashColor: color.withValues(alpha: 0.2),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  children: [
                    // The Icon Circle
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 35, color: color),
                    ),
                    
                    const SizedBox(width: 20),
                    
                    // The Text Info
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Little arrow to indicate clickable
                    Icon(
                      Icons.arrow_forward_ios_rounded, 
                      color: Colors.black.withValues(alpha: 0.3),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------
// HELPER: Placeholder Screen (Delete this when you link real pages)
// -----------------------------------------------------------
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text("$title Screen Under Construction")),
    );
  }
}