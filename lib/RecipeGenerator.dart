import 'package:flutter/material.dart';
import 'package:kitahack_frontend/GlassButton.dart';
import 'package:kitahack_frontend/GlassDropdownField.dart';
import 'package:kitahack_frontend/InputTextField.dart';
// Make sure to import your new dropdown widget!
import 'package:kitahack_frontend/GlassDropdownField.dart'; 

class RecipeGenerator extends StatefulWidget {
  const RecipeGenerator({super.key});

  @override
  State<RecipeGenerator> createState() => _RecipeGeneratorState();
}

class _RecipeGeneratorState extends State<RecipeGenerator> {
  // --- 1. CORE INPUTS (Text Fields) ---
  final TextEditingController ingredients = TextEditingController();
  final TextEditingController prepTime = TextEditingController(text: "30"); 
  final TextEditingController exclusions = TextEditingController();
  final TextEditingController cuisine = TextEditingController(); 
  final TextEditingController appliances = TextEditingController(); 

  // --- 2. DROPDOWN STATES (Replaced Controllers) ---
  String selectedMealType = "Dinner";
  int selectedServings = 2;
  String selectedDietary = "None";

  // --- 3. TOGGLES ---
  bool isHalal = false;
  bool isHealthy = true; // Defaulted to true for a health-first approach

  // --- 4. UI STATE ---
  bool _showAdvanced = false; // Controls the visibility of the advanced section

  @override
  void dispose() {
    ingredients.dispose();
    exclusions.dispose();
    cuisine.dispose();
    prepTime.dispose();
    appliances.dispose();
    super.dispose();
  }

  void _generateRecipe() {
    print("--- NEW SINGLE RECIPE REQUEST ---");
    print("Ingredients: ${ingredients.text}");
    print("Type: $selectedMealType");
    print("Servings: $selectedServings");
    print("Time: ${prepTime.text}");
    print("Appliance: ${appliances.text}");
    print("Dietary: $selectedDietary");
    print("Halal: $isHalal");
    print("Healthy: $isHealthy");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Creating a recipe for you...")),
    );
  }

  void _clearForm() {
    // Reset TextFields
    ingredients.clear();
    prepTime.text = "30";
    exclusions.clear();
    cuisine.clear();
    appliances.clear();
    
    // Reset Dropdowns & Toggles
    setState(() {
      selectedMealType = "Dinner";
      selectedServings = 2;
      selectedDietary = "None";
      isHalal = false;
      isHealthy = true; 
      _showAdvanced = false; 
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
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Container(
        width: 160,
        margin: const EdgeInsets.only(bottom: 10, left: 10),
        child: GlassButton(
          text: "Cook Now",
          onPressed: _generateRecipe,
          color: Colors.orangeAccent, 
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // ==========================================
              // THE BASICS (Always Visible)
              // ==========================================
              const Text(
                "The Basics",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 15),
              
              GlassTextField(
                label: "Ingredients You Have",
                controller: ingredients,
                hint: "Chicken, Rice, Egg...",
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GlassDropdownField<String>(
                      label: "Meal Type",
                      labelWidth: 95, // Increased from 90 to prevent wrapping
                      value: selectedMealType,
                      items: const ["Breakfast", "Lunch", "Dinner", "Snack", "Dessert"],
                      onChanged: (String? val) {
                        setState(() => selectedMealType = val!);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GlassDropdownField<int>(
                      label: "Servings",
                      labelWidth: 95, // Increased from 80 to prevent the 's' from wrapping
                      value: selectedServings,
                      items: const [1, 2, 3, 4, 5, 6, 7, 8],
                      onChanged: (int? val) {
                        setState(() => selectedServings = val!);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GlassTextField(
                label: "Max Prep Time (mins)",
                controller: prepTime,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 25),

              // ==========================================
              // ADVANCED SETTINGS TOGGLE
              // ==========================================
              InkWell(
                onTap: () {
                  setState(() {
                    _showAdvanced = !_showAdvanced;
                  });
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        _showAdvanced ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.black87,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Advanced Settings",
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 10),

              // ==========================================
              // ADVANCED SETTINGS CONTENT (Hidden by default)
              // ==========================================
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: !_showAdvanced 
                  ? const SizedBox.shrink() 
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GlassTextField(
                          label: "Exclusions",
                          controller: exclusions,
                          hint: "No Cilantro, No Peanuts...",
                        ),
                        const SizedBox(height: 10),
                        GlassTextField(
                          label: "Cuisine Vibe",
                          controller: cuisine,
                          hint: "Spicy, Italian...",
                        ),
                        const SizedBox(height: 10),
                        GlassTextField(
                          label: "Appliances Available",
                          controller: appliances,
                          hint: "Stove, Air Fryer...",
                        ),
                        const SizedBox(height: 10),
                        
                        // Replaced Textfield with Dropdown for Dietary Needs
                        GlassDropdownField<String>(
                          label: "Dietary Needs",
                          value: selectedDietary,
                          items: const ["None", "Vegetarian", "Vegan", "Keto", "Gluten-Free", "Paleo"],
                          onChanged: (String? val) {
                            setState(() => selectedDietary = val!);
                          },
                        ),
                        
                        const SizedBox(height: 15),

                        SwitchListTile(
                          title: const Text(
                            "Halal Only",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          value: isHalal,
                          activeTrackColor: Colors.lightGreen,
                          activeThumbColor: Colors.white,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (bool value) => setState(() => isHalal = value),
                        ),
                        SwitchListTile(
                          title: const Text(
                            "Prioritize Healthy Options",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          value: isHealthy,
                          activeTrackColor: Colors.lightGreen,
                          activeThumbColor: Colors.white,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (bool value) => setState(() => isHealthy = value),
                        ),
                      ],
                    ),
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _clearForm,
                  child: const Text(
                    "Reset Form",
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