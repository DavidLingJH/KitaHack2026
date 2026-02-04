import 'dart:ui';
import 'package:flutter/material.dart'; // REQUIRED: Import this for the ImageFilter class

class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GlassButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // 1. ClipRRect constrains the blur to just the button shape
    return ClipRRect(
      borderRadius: BorderRadius.circular(25), // Rounded corners
      child: BackdropFilter(
        // 2. The Blur Effect
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), 
        child: Container(
          height: 55,             // Fixed height for consistency
          decoration: BoxDecoration(
            // 3. The "Liquid" Gradient (Shiny look)
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.4), // Lighter at top-left
                Colors.white.withValues(alpha: 0.1), // Darker at bottom-right
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            // 4. The Frosty Border
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.5), 
              width: 1.5,
            ),
            // Optional: Subtle shadow for depth
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          // 5. Material & InkWell give the "Splash" tap effect
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.black87, // Dark text for contrast
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}