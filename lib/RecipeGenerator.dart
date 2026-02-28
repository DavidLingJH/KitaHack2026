import 'package:flutter/material.dart';
import 'package:kitahack_frontend/GlassButton.dart';
import 'package:kitahack_frontend/GlassDropdownField.dart';
import 'package:kitahack_frontend/InputTextField.dart';
import 'package:kitahack_frontend/RecipeResult.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Make sure to import your new dropdown widget!

class RecipeGenerator extends StatefulWidget {
  const RecipeGenerator({super.key});

  @override
  State<RecipeGenerator> createState() => _RecipeGeneratorState();
}

class _RecipeGeneratorState extends State<RecipeGenerator> {
  // --- 1. CORE INPUTS (Text Fields) ---
  final TextEditingController ingredients = TextEditingController();
  final TextEditingController prepTime = TextEditingController(text: "30"); 
  final TextEditingController budget = TextEditingController(text: "10"); 
  final TextEditingController exclusions = TextEditingController();
  final TextEditingController cuisine = TextEditingController(); 
  final TextEditingController appliances = TextEditingController(); 
  // final TextEditingController foodstyle = TextEditingController();

  // --- 2. DROPDOWN STATES (Replaced Controllers) ---
  String selectedMealType = "Dinner";
  String selectedSkillType = "Beginner";
  int selectedServings = 2;
  String selectedDietary = "None";

  // --- 3. TOGGLES ---
  bool isHalal = false;
  bool isHealthy = true; // Defaulted to true for a health-first approach

  // --- 4. UI STATE ---
  bool _showAdvanced = false; // Controls the visibility of the advanced section
  bool _isLoading = false;

  @override
  void dispose() {
    ingredients.dispose();
    // foodstyle.dispose();
    exclusions.dispose();
    cuisine.dispose();
    prepTime.dispose();
    budget.dispose();
    appliances.dispose();
    super.dispose();
  }

  void _generateRecipe() {
    // 1. You can keep your print statements for debugging if you want
    // print("--- NEW SINGLE RECIPE REQUEST ---");
    // print("Ingredients: ${ingredients.text}");
    // print("Type: $selectedMealType");
    // print("Servings: $selectedServings");
    // print("Time: ${prepTime.text}");
    // print("Appliance: ${appliances.text}");
    // print("Dietary: $selectedDietary");
    // print("Halal: $isHalal");
    // print("Healthy: $isHealthy");




    // 2. Navigate to the RecipeResult screen
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const RecipeResult(recipe:),
    //   ),
    // );
  }

  void _clearForm() {
    // Reset TextFields
    ingredients.clear();
    // foodstyle.clear();
    prepTime.text = "30";
    budget.text = "10";
    exclusions.clear();
    cuisine.clear();
    appliances.clear();
    
    // Reset Dropdowns & Toggles
    setState(() {
      selectedMealType = "Dinner";
      selectedSkillType = "Beginner";
      selectedServings = 2;
      selectedDietary = "None";
      isHalal = false;
      isHealthy = true; 
      _showAdvanced = false; 
    });
  }

  @override
  Widget build(BuildContext context) {
    // A slightly wider standard label width to accommodate longer labels 
    // like "Appliances Available" and "Max Prep Time (mins)"
    const double standardLabelWidth = 150.0;

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
          isLoading: _isLoading,
          onPressed: generateRecipe,
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
                label: "Preferred Ingredients",
                labelWidth: standardLabelWidth,
                controller: ingredients,
                hint: "Chicken, Rice, Egg...",
              ),
              const SizedBox(height: 10),
              
              GlassDropdownField<String>(
                label: "Meal Type",
                labelWidth: standardLabelWidth, 
                value: selectedMealType,
                items: const ["Breakfast", "Lunch", "Dinner", "Snack", "Dessert"],
                onChanged: (String? val) {
                  setState(() => selectedMealType = val!);
                },
              ),
              const SizedBox(height: 10),

              // GlassTextField(
              //   label: "Style",
              //   labelWidth: standardLabelWidth,
              //   controller: foodstyle,
              //   hint: "Malay, Indian, Thai,...",
              // ),
              // const SizedBox(height: 10),
              
              GlassDropdownField<int>(
                label: "Servings",
                labelWidth: standardLabelWidth, 
                value: selectedServings,
                items: const [1, 2, 3, 4, 5, 6, 7, 8],
                onChanged: (int? val) {
                  setState(() => selectedServings = val!);
                },
              ),
              const SizedBox(height: 10),
    
              GlassTextField(
                label: "Max Prep Time (mins)",
                labelWidth: standardLabelWidth,
                controller: prepTime,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 25),

              GlassTextField(
                label: "Budget (MYR) - Per Meal",
                labelWidth: standardLabelWidth,
                controller: budget,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 25),

               GlassDropdownField<String>(
                label: "Skill Type",
                labelWidth: standardLabelWidth, 
                value: selectedSkillType,
                items: const ["Beginner", "Intermediate", "Advanced"],
                onChanged: (String? val) {
                  setState(() => selectedSkillType = val!);
                },
              ),
              const SizedBox(height: 10),

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
                          labelWidth: standardLabelWidth,
                          controller: exclusions,
                          hint: "No Cilantro, No Peanuts...",
                        ),
                        const SizedBox(height: 10),
                        
                        GlassTextField(
                          label: "Cuisine Vibe",
                          labelWidth: standardLabelWidth,
                          controller: cuisine,
                          hint: "Spicy, Italian...",
                        ),
                        const SizedBox(height: 10),
                        
                        GlassTextField(
                          label: "Appliances Available",
                          labelWidth: standardLabelWidth,
                          controller: appliances,
                          hint: "Stove, Air Fryer...",
                        ),
                        const SizedBox(height: 10),
                        
                        GlassDropdownField<String>(
                          label: "Dietary Needs",
                          labelWidth: standardLabelWidth,
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

  

   Future<void> generateRecipe() async {

    setState(() => _isLoading = true);

    try{
              if(cuisine.text==''){
          cuisine.text = 'Any';
        }

        if(exclusions.text == ''){
          exclusions.text = 'None';
        }

        if(appliances.text == ''){
          appliances.text = 'No appliances specify. Suggest based on the common norm';
        }

        

        final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/generate'),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "meal_type": selectedMealType,
            "diet_res":selectedDietary,
            "halal":isHalal,
            "duration":1,
            "duration_unit":'day',
            "meal_purpose":'None. Just for common eating',
            "num_people":selectedServings, 
            "budget":double.tryParse(budget.text) ?? 0.0,
            "currency":"MYR",
            "skill_level":selectedSkillType,
            "cook_time":double.tryParse(prepTime.text) ?? 0.0,
            "cook_time_unit":'minute',
            'style':cuisine.text,
            'variety':true, 
            'health_con':selectedDietary,
            'ingredients':ingredients.text,
            'appliances':appliances.text,
          }),
        );


        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          print(data);
          
          if (!mounted) return;
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeResult(recipe: data),
          ),
      );
        } else {
          // print('Failed to send data');
        }
    }catch (e){
      print('Failed to send data');
    } finally{
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
    
  }
}