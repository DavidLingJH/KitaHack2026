import 'package:flutter/material.dart';
import 'package:kitahack_frontend/GlassButton.dart';
import 'package:kitahack_frontend/GlassDropdownField.dart';
import 'package:kitahack_frontend/InputTextField.dart';

class MealPlanGenerator extends StatefulWidget {
  const MealPlanGenerator({super.key});

  @override
  State<MealPlanGenerator> createState() => _MealPlanGeneratorState();
}

class _MealPlanGeneratorState extends State<MealPlanGenerator> {
  // --- 1. CORE TEXT INPUTS ---
  final TextEditingController ingredients = TextEditingController();
  final TextEditingController budget = TextEditingController();
  final TextEditingController cookTime = TextEditingController(text: "45"); // Default 45 mins
  
  // --- 2. ADVANCED TEXT INPUTS ---
  final TextEditingController style = TextEditingController(); 
  final TextEditingController appliances = TextEditingController(); 
  final TextEditingController exclusions = TextEditingController(); 
  final TextEditingController healthCon = TextEditingController(); 

  // --- 3. DROPDOWN STATES (With Defaults) ---
  int selectedDuration = 7; // Default to 1 week
  int selectedPeople = 1;   // Default to 1 person
  String selectedDietary = "None";
  String selectedPurpose = "General Health";
  String selectedSkill = "Beginner";
  String selectedMealType = "All Meals"; 

  // --- 4. TOGGLES ---
  bool isHalal = false;
  bool preferVariety = true; // Defaulted to true for meal plans

  // --- 5. UI STATE ---
  bool _showAdvanced = false;

  @override
  void dispose() {
    ingredients.dispose();
    budget.dispose();
    cookTime.dispose();
    style.dispose();
    appliances.dispose();
    exclusions.dispose();
    healthCon.dispose();
    super.dispose();
  }

  void _generateRecipe() {
    print("--- NEW MEAL PLAN REQUEST ---");
    print("Ingredients: ${ingredients.text}");
    print("Duration: $selectedDuration days");
    print("People: $selectedPeople");
    print("Dietary: $selectedDietary");
    print("Goal: $selectedPurpose");
    print("Budget: ${budget.text}");
    print("Halal: $isHalal");
    print("Variety: $preferVariety");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Generating your meal plan...")),
    );
  }

  void _clearForm() {
    // Reset TextFields
    ingredients.clear();
    budget.clear();
    cookTime.text = "45";
    style.clear();
    appliances.clear();
    exclusions.clear();
    healthCon.clear();

    // Reset Dropdowns & UI
    setState(() {
      selectedDuration = 7;
      selectedPeople = 1;
      selectedDietary = "None";
      selectedPurpose = "General Health";
      selectedSkill = "Beginner";
      selectedMealType = "All Meals";
      isHalal = false;
      preferVariety = true;
      _showAdvanced = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // A standard label width keeps all the input boxes perfectly aligned vertically
    const double standardLabelWidth = 110.0;

    return Scaffold(
      backgroundColor: const Color(0xffF9EECA),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Meal Plan Generator",
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
          text: "Generate Plan",
          onPressed: _generateRecipe,
          color: Colors.lightGreen,
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
                label: "Ingredients", 
                labelWidth: standardLabelWidth,
                controller: ingredients,
                hint: "Chicken, Rice, Broccoli...",
              ),
              const SizedBox(height: 10),
              
              GlassDropdownField<int>(
                label: "Duration (Days)",
                labelWidth: standardLabelWidth, 
                value: selectedDuration,
                items: const [1, 2, 3, 5, 7, 14, 30],
                onChanged: (int? val) => setState(() => selectedDuration = val!),
              ),
              const SizedBox(height: 10),
              
              GlassDropdownField<int>(
                label: "People",
                labelWidth: standardLabelWidth,
                value: selectedPeople,
                items: const [1, 2, 3, 4, 5, 6, 8, 10],
                onChanged: (int? val) => setState(() => selectedPeople = val!),
              ),
              const SizedBox(height: 10),

              GlassTextField(
                label: "Budget",
                labelWidth: standardLabelWidth,
                controller: budget,
                hint: "e.g. 50",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              
              GlassTextField(
                label: "Max Time (Min)",
                labelWidth: standardLabelWidth,
                controller: cookTime,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),

              GlassDropdownField<String>(
                label: "Diet",
                labelWidth: standardLabelWidth,
                value: selectedDietary,
                items: const ["None", "Vegetarian", "Vegan", "Keto", "Paleo", "Gluten-Free"],
                onChanged: (String? val) => setState(() => selectedDietary = val!),
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
              // ADVANCED SETTINGS CONTENT
              // ==========================================
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: !_showAdvanced 
                  ? const SizedBox.shrink() 
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        GlassDropdownField<String>(
                          label: "Goal",
                          labelWidth: standardLabelWidth,
                          value: selectedPurpose,
                          items: const ["General Health", "Weight Loss", "Muscle Gain", "Maintenance"],
                          onChanged: (String? val) => setState(() => selectedPurpose = val!),
                        ),
                        const SizedBox(height: 10),
                        
                        GlassDropdownField<String>(
                          label: "Skill Level",
                          labelWidth: standardLabelWidth,
                          value: selectedSkill,
                          items: const ["Beginner", "Intermediate", "Advanced"],
                          onChanged: (String? val) => setState(() => selectedSkill = val!),
                        ),
                        const SizedBox(height: 10),

                        GlassDropdownField<String>(
                          label: "Meals Included",
                          labelWidth: standardLabelWidth,
                          value: selectedMealType,
                          items: const ["All Meals", "Lunch & Dinner", "Dinner Only", "Breakfast Only", "Lunch Only"],
                          onChanged: (String? val) => setState(() => selectedMealType = val!),
                        ),
                        const SizedBox(height: 10),
                        
                        GlassTextField(
                          label: "Cuisine Style",
                          labelWidth: standardLabelWidth,
                          controller: style,
                          hint: "e.g. Asian",
                        ),
                        const SizedBox(height: 10),

                        GlassTextField(
                          label: "Appliances",
                          labelWidth: standardLabelWidth,
                          controller: appliances,
                          hint: "Oven, Air Fryer...",
                        ),
                        const SizedBox(height: 10),
                        
                        GlassTextField(
                          label: "Exclusions",
                          labelWidth: standardLabelWidth,
                          controller: exclusions,
                          hint: "No Peanuts, No Seafood...",
                        ),
                        const SizedBox(height: 10),

                        GlassTextField(
                          label: "Health Info",
                          labelWidth: standardLabelWidth,
                          controller: healthCon,
                          hint: "e.g. Diabetes, Hypertension...",
                        ),
                        const SizedBox(height: 15),

                        // TOGGLES
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
                            "Prioritize Variety",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: const Text(
                            "Don't repeat meals often",
                            style: TextStyle(fontSize: 12),
                          ),
                          value: preferVariety,
                          activeTrackColor: Colors.lightGreen,
                          activeThumbColor: Colors.white,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (bool value) => setState(() => preferVariety = value),
                        ),
                      ],
                    ),
              ),

              const SizedBox(height: 20),

              // ==========================================
              // CLEAR BUTTON
              // ==========================================
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