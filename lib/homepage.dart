import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kitahack_frontend/ShoppingList.dart';
import 'package:kitahack_frontend/camera.dart';
import 'package:kitahack_frontend/chatbot.dart';
import 'package:kitahack_frontend/ShoppingList.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xffF9EECA),
              Color(0xffFFD700),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

                Expanded(
                  child: ListView( 
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
                              builder: (context) => const CameraCaptureScreen(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 30),

                      // OPTION C: Shopping List (Replaced Camera Test)
                      MenuCard(
                        title: "Shopping List",
                        subtitle: "Check off your ingredients",
                        icon: Icons.shopping_basket_outlined, // A nice grocery icon
                        color: Colors.redAccent, // Red to contrast with orange and green
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              // Routes to the new screen you just created!
                              builder: (context) => const ShoppingListScreen(), 
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

// ==========================================
// MENU CARD COMPONENT
// ==========================================
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
          height: 160, 
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3), 
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.2), 
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