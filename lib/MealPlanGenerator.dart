import 'package:flutter/material.dart';
import 'package:kitahack_frontend/GlassButton.dart';
import 'package:kitahack_frontend/InputTextField.dart';

class MealPlanGenerator extends StatefulWidget {
  const MealPlanGenerator({super.key});

  @override
  State<MealPlanGenerator> createState() => _MealPlanGeneratorState();
}

class _MealPlanGeneratorState extends State<MealPlanGenerator> {

  // --- 1. EXISTING CONTROLLERS ---
  final TextEditingController ingredients = TextEditingController();
  final TextEditingController exclusions = TextEditingController();
  final TextEditingController style = TextEditingController();

  // --- 2. NEW CONTROLLERS (Based on your JSON Schema) ---
  final TextEditingController mealType = TextEditingController();      // e.g. Lunch, Dinner
  final TextEditingController dietRes = TextEditingController();       // e.g. Vegan, Keto
  final TextEditingController duration = TextEditingController();      // e.g. 3 (Days)
  final TextEditingController mealPurpose = TextEditingController();   // e.g. Weight Loss
  final TextEditingController numPeople = TextEditingController();     // e.g. 2
  final TextEditingController budget = TextEditingController();        // e.g. 50
  final TextEditingController skillLevel = TextEditingController();    // e.g. Beginner
  final TextEditingController cookTime = TextEditingController();      // e.g. 30 (Mins)
  final TextEditingController healthCon = TextEditingController();     // e.g. Diabetes
  final TextEditingController appliances = TextEditingController();    // e.g. Oven, Air Fryer

  // --- 3. BOOLEAN TOGGLES ---
  bool isHalal = false;
  bool preferVariety = true;

  @override
  void dispose() {
    // Dispose ALL controllers to free up memory
    ingredients.dispose();
    exclusions.dispose();
    style.dispose();
    mealType.dispose();
    dietRes.dispose();
    duration.dispose();
    mealPurpose.dispose();
    numPeople.dispose();
    budget.dispose();
    skillLevel.dispose();
    cookTime.dispose();
    healthCon.dispose();
    appliances.dispose();
    super.dispose();
  }

  void _generateRecipe() {
    // Collect all data into a map or object here
    // For now, we print the key fields to console
    print("--- NEW MEAL PLAN REQUEST ---");
    print("Ingredients: ${ingredients.text}");
    print("Dietary Restrictions: ${dietRes.text}");
    print("Halal: $isHalal");
    print("People: ${numPeople.text}");
    print("Budget: ${budget.text}");
    print("Variety: $preferVariety");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Generating plan for ${ingredients.text}...")),
    );
  }

  void _clearForm() {
    ingredients.clear();
    exclusions.clear();
    style.clear();
    mealType.clear();
    dietRes.clear();
    duration.clear();
    mealPurpose.clear();
    numPeople.clear();
    budget.clear();
    skillLevel.clear();
    cookTime.clear();
    healthCon.clear();
    appliances.clear();
    
    setState(() {
      isHalal = false;
      preferVariety = true;
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
          "Meal Plan Generator",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
      ),
      // Move FAB to avoid blocking bottom fields
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, 
      floatingActionButton: Container(
        width: 140, 
        margin: const EdgeInsets.only(bottom: 20, right: 10), 
        child: GlassButton(
          text: "Generate",
          onPressed: _generateRecipe,
          color: Colors.lightGreen,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100), // Extra bottom padding for FAB
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SECTION: FOOD & INGREDIENTS ---
              const Text("Food & Ingredients", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 15),
              GlassTextField(label: "Ingredients", controller: ingredients),
              const SizedBox(height: 10),
              GlassTextField(label: "Appliances Available", controller: appliances),
              const SizedBox(height: 10),
              GlassTextField(label: "Exclusions", controller: exclusions),
              
              const SizedBox(height: 25),

              // --- SECTION: DIET & HEALTH ---
              const Text("Diet & Health", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 15),
              GlassTextField(label: "Dietary Restrictions", controller: dietRes),
              const SizedBox(height: 10),
              GlassTextField(label: "Health Conditions", controller: healthCon),
              const SizedBox(height: 10),
              // Halal Toggle
              SwitchListTile(
                title: const Text("Halal Only", style: TextStyle(fontWeight: FontWeight.w600)),
                value: isHalal,
                activeTrackColor: Colors.lightGreen, 
                // Optionally set the thumb (circle) color to white for better contrast
                activeColor: Colors.white,
                onChanged: (bool value) {
                  setState(() {
                    isHalal = value;
                  });
                },
              ),

              const SizedBox(height: 25),

              // --- SECTION: LOGISTICS (Numbers) ---
              const Text("Logistics", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: GlassTextField(label: "People", controller: numPeople, keyboardType: TextInputType.number)),
                  const SizedBox(width: 10),
                  Expanded(child: GlassTextField(label: "Budget", controller: budget, keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: GlassTextField(label: "Cook Time (mins)", controller: cookTime, keyboardType: TextInputType.number)),
                  const SizedBox(width: 10),
                  Expanded(child: GlassTextField(label: "Duration (days)", controller: duration, keyboardType: TextInputType.number)),
                ],
              ),

              const SizedBox(height: 25),

              // --- SECTION: PREFERENCES ---
              const Text("Preferences", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 15),
              GlassTextField(label: "Cuisine Style", controller: style), // e.g. Italian
              const SizedBox(height: 10),
              GlassTextField(label: "Meal Type", controller: mealType), // e.g. Lunch
              const SizedBox(height: 10),
              GlassTextField(label: "Meal Purpose", controller: mealPurpose), // e.g. Muscle Gain
              const SizedBox(height: 10),
              GlassTextField(label: "Skill Level", controller: skillLevel),
              
              // Variety Toggle
              SwitchListTile(
                title: const Text("Prioritize Variety", style: TextStyle(fontWeight: FontWeight.w600)),
                value: preferVariety,
                // Use activeTrackColor for the "fill" color when ON
                activeTrackColor: Colors.lightGreen, 
                // Optionally set the thumb (circle) color to white for better contrast
                activeColor: Colors.white,
                onChanged: (bool value) {
                  setState(() {
                    preferVariety = value;
                  });
                },
              ),

              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _clearForm,
                  child: const Text(
                    "Clear Form", 
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
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