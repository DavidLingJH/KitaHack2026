import 'dart:ui';
import 'package:flutter/material.dart';

class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color; // New Property

  const GlassButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.white, // Default to White if not specified
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            // Use the passed 'color' variable here
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.4), // Use color here
                color.withValues(alpha: 0.1), // And here
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.5), // And here
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              splashColor: color.withValues(alpha: 0.3), // Matches splash to button color
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    // If the button is white, use black text.
                    // If the button is colored (like Green), use dark green text or white.
                    color: color == Colors.white ? Colors.black87 : Colors.white,
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