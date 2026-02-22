import 'dart:ui';
import 'package:flutter/material.dart';

// Using a generic type <T> so you can pass Strings, Ints, or even custom Objects
class GlassDropdownField<T> extends StatelessWidget {
  final String label;
  final String? hint;
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final double labelWidth;

  const GlassDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint,
    this.labelWidth = 120.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          // Ensure minimum height matches your button/textfield design
          constraints: const BoxConstraints(minHeight: 55),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.4),
                Colors.white.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: const Color.fromARGB(255, 227, 227, 227).withValues(alpha: 0.5),
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
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- LABEL SECTION ---
                Container(
                  width: labelWidth,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                // --- DIVIDER ---
                Container(
                  width: 1.5,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                
                // --- DROPDOWN SECTION ---
                Expanded(
                  child: DropdownButtonFormField<T>(
                    value: value,
                    isExpanded: true, // Prevents overflow if text is long
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded, 
                      color: Colors.black.withValues(alpha: 0.5)
                    ),
                    // Dropdown menu background color
                    dropdownColor: Colors.white.withValues(alpha: 0.95), 
                    borderRadius: BorderRadius.circular(15),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: TextStyle(
                        color: Colors.black.withValues(alpha: 0.4),
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      // Matches the padding of your GlassTextField exactly
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                    ),
                    items: items.map((T item) {
                      return DropdownMenuItem<T>(
                        value: item,
                        child: Text(item.toString()),
                      );
                    }).toList(),
                    onChanged: onChanged,
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