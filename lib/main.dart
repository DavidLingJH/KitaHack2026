import 'package:flutter/material.dart';
import 'package:kitahack_frontend/chatbot.dart';

// 1. You must have a main function to start the app
void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. You must return MaterialApp here
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chatbot App',
      home: const Chatbot(),
    );
  }
}