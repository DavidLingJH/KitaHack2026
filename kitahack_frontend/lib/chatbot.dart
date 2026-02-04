import 'package:flutter/material.dart';

class Chatbot extends StatelessWidget {
  const Chatbot({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9EECA),
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
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            child: Image.asset("assets/images/Waving Robot.png")
          ),
          SizedBox(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Text("Hello!\nWhat would you\nlike to do today?")
                  )
                )
              ],
            )
          )
        ],
      ),
    );
  }
}