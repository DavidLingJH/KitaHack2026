import 'package:flutter/material.dart';
import 'package:kitahack_frontend/GlassButton.dart';
import 'package:kitahack_frontend/InputTextField.dart';

class RecipeGenerator extends StatefulWidget {
  const RecipeGenerator({super.key});

  @override
  State<RecipeGenerator> createState() => _RecipeGeneratorState();
}

class _RecipeGeneratorState extends State<RecipeGenerator> {
  // --- 1. CORE INPUTS ---
  final TextEditingController ingredients = TextEditingController();
  final TextEditingController exclusions = TextEditingController();

  // --- 2. RECIPE SPECIFICS ---
  final TextEditingController mealType =
      TextEditingController(); // e.g. Breakfast, Snack
  final TextEditingController cuisine =
      TextEditingController(); // e.g. Italian, Spicy
  final TextEditingController servingSize =
      TextEditingController(); // e.g. 2 People
  final TextEditingController prepTime =
      TextEditingController(); // e.g. 15 Mins
  final TextEditingController appliances =
      TextEditingController(); // e.g. Air Fryer, Microwave
  final TextEditingController dietary =
      TextEditingController(); // e.g. Keto, Low Carb

  // --- 3. TOGGLES ---
  bool isHalal = false;
  bool isHealthy = false; // Quick toggle for "Healthy version"

  @override
  void dispose() {
    ingredients.dispose();
    exclusions.dispose();
    mealType.dispose();
    cuisine.dispose();
    servingSize.dispose();
    prepTime.dispose();
    appliances.dispose();
    dietary.dispose();
    super.dispose();
  }

  void _generateRecipe() {
    print("--- NEW SINGLE RECIPE REQUEST ---");
    print("Ingredients: ${ingredients.text}");
    print("Type: ${mealType.text}");
    print("Time: ${prepTime.text}");
    print("Appliance: ${appliances.text}");
    print("Halal: $isHalal");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Creating a ${cuisine.text} recipe for you...")),
    );
  }

  void _clearForm() {
    ingredients.clear();
    exclusions.clear();
    mealType.clear();
    cuisine.clear();
    servingSize.clear();
    prepTime.clear();
    appliances.clear();
    dietary.clear();
    setState(() {
      isHalal = false;
      isHealthy = false;
    });
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
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
      ),
      // FAB aligned to the left as per your previous snippet
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Container(
        width: 160,
        margin: const EdgeInsets.only(bottom: 10, left: 10),
        child: GlassButton(
          text: "Cook Now",
          onPressed: _generateRecipe,
          color: Colors.orangeAccent, // Changed to Orange for "Cooking" vibe
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Extra bottom padding to ensure the FAB doesn't cover the last text button
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SECTION 1: THE BASICS (What do you have?) ---
              const Text(
                "The Basics",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 15),
              GlassTextField(
                label: "Ingredients",
                controller: ingredients,
                hint: "Chicken, Rice, Egg...",
              ),
              const SizedBox(height: 10),
              GlassTextField(
                label: "Exclusions",
                controller: exclusions,
                hint: "No Cilantro, No Peanuts...",
              ),

              const SizedBox(height: 25),

              // --- SECTION 2: THE VIBE (What do you want?) ---
              const Text(
                "The Vibe",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: GlassTextField(
                      label: "Meal Type",
                      controller: mealType,
                      hint: "Dinner",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GlassTextField(
                      label: "Cuisine",
                      controller: cuisine,
                      hint: "Spicy",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Appliances are critical for single recipes (e.g. "I only have an air fryer")
              GlassTextField(
                label: "Appliances",
                controller: appliances,
                hint: "Stove, Air Fryer...",
              ),

              const SizedBox(height: 25),

              // --- SECTION 3: LOGISTICS (How much/How long?) ---
              const Text(
                "Logistics",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: GlassTextField(
                      label: "Servings",
                      controller: servingSize,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GlassTextField(
                      label: "Time (mins)",
                      controller: prepTime,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // --- SECTION 4: DIETARY TOGGLES ---
              GlassTextField(
                label: "Dietary Needs",
                controller: dietary,
                hint: "Vegan, Gluten Free...",
              ),
              const SizedBox(height: 10),

              SwitchListTile(
                title: const Text(
                  "Halal Only",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                value: isHalal,
                // Use activeTrackColor for the "fill" color when ON
                activeTrackColor: Colors.lightGreen,
                // Optionally set the thumb (circle) color to white for better contrast
                activeThumbColor: Colors.white,
                contentPadding: EdgeInsets.zero, // Aligns with text fields
                onChanged: (bool value) => setState(() => isHalal = value),
              ),
              SwitchListTile(
                title: const Text(
                  "Prioritize Healthy Options",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                value: isHealthy,
                // Use activeTrackColor for the "fill" color when ON
                activeTrackColor: Colors.lightGreen,
                // Optionally set the thumb (circle) color to white for better contrast
                activeThumbColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                onChanged: (bool value) => setState(() => isHealthy = value),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _clearForm,
                  child: const Text(
                    "Clear Form",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
