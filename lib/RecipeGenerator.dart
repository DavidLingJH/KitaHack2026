import 'package:flutter/material.dart';
import 'package:kitahack_frontend/GlassButton.dart';
import 'package:kitahack_frontend/InputTextField.dart';

class RecipeGenerator extends StatefulWidget {
  const RecipeGenerator({super.key});

  @override
  State<RecipeGenerator> createState() => _RecipeGeneratorState();
}

class _RecipeGeneratorState extends State<RecipeGenerator> {

  final TextEditingController ingredients = TextEditingController();
  final TextEditingController exclusions = TextEditingController();
  final TextEditingController style = TextEditingController();

  @override
  void dispose() {
    // dispose controllers when the screen is destroyed to free up memory
    ingredients.dispose();
    exclusions.dispose();
    style.dispose();
    super.dispose();
  }

  void _generateRecipe() {
    String ingredient = ingredients.text;
    String exclusion = exclusions.text;
    String cuisine = style.text;

    // For now, we just print them to the debug console
    print("--- NEW RECIPE REQUEST ---");
    print("Ingredients: $ingredient");
    print("Exclude: $exclusion");
    print("Style: $cuisine");

    // Optional: Show a snackbar to confirm
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Generating recipe for $ingredient...")),
    );
  }

  void _clearForm() {
    ingredients.clear();
    exclusions.clear();
    style.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9EECA),
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Recipe Generator",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Container(
        width: 160, 
        margin: const EdgeInsets.only(bottom: 10, left: 10), 
        child: GlassButton(
          text: "Generate",
          onPressed: _generateRecipe,
          color: Colors.lightGreen,
        ),
      ),
      body: 
      SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlassTextField(
                label: "Ingredients", 
                controller: ingredients
              ),
              SizedBox(height: 10),
              GlassTextField(
                label: "Exclusions", 
                controller: exclusions
              ),
              SizedBox(height: 10),
              GlassTextField(
                label: "Style", 
                controller: style
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _clearForm,
                  child: const Text(
                    "Clear Form", 
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

