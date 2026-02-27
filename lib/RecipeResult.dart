import 'package:flutter/material.dart';
import 'package:kitahack_frontend/GlassButton.dart';

class RecipeResult extends StatelessWidget {
  const RecipeResult({super.key});

  // 1. THE DRAFT ARRAY (Dummy Data)
  // Later, you can pass this in through the constructor from your backend!
  final List<Map<String, dynamic>> draftRecipes = const [
    {
      "title": "Creamy Garlic Butter Chicken",
      "description": "A rich and savory chicken dish perfect for a quick dinner.",
      "time": "30 mins",
      "difficulty": "Beginner",
      "calories": "450 kcal",
      "ingredients": [
        "2 Chicken breasts",
        "4 cloves Garlic, minced",
        "1/2 cup Heavy cream",
        "2 tbsp Butter",
        "1 tsp Italian seasoning",
      ],
      "instructions": [
        "Season the chicken breasts with salt, pepper, and Italian seasoning.",
        "Melt butter in a skillet over medium-high heat and cook chicken until golden brown.",
        "Remove chicken, lower heat, and sauté minced garlic until fragrant.",
        "Stir in the heavy cream and let it simmer until slightly thickened.",
        "Return the chicken to the skillet, coat with sauce, and serve hot."
      ],
    },
    {
      "title": "Spicy Basil Fried Rice",
      "description": "A quick, spicy, and aromatic fried rice using leftover ingredients.",
      "time": "15 mins",
      "difficulty": "Beginner",
      "calories": "380 kcal",
      "ingredients": [
        "2 cups Cooked rice (day-old is best)",
        "1 cup Mixed vegetables",
        "2 tbsp Soy sauce",
        "1 tbsp Chili paste",
        "Handful of fresh basil",
      ],
      "instructions": [
        "Heat oil in a wok or large pan over high heat.",
        "Add mixed vegetables and stir-fry for 2 minutes.",
        "Add the cooked rice, breaking up any clumps.",
        "Pour in soy sauce and chili paste, tossing everything together evenly.",
        "Toss in fresh basil right before turning off the heat. Serve immediately."
      ],
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9EECA),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Your Recipes",
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
          text: "Save Recipes",
          onPressed: () {
            // TODO: Handle saving recipes to user's profile
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Recipes saved to your profile!")),
            );
          },
          color: Colors.orangeAccent, 
        ),
      ),
      // 2. THE LIST OF RECIPES
      body: SafeArea(
        child: ListView.builder(
          // Padding at the bottom so the last item doesn't hide behind the FloatingActionButton
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
          itemCount: draftRecipes.length,
          itemBuilder: (context, index) {
            final recipe = draftRecipes[index];
            return RecipeMiniCard(
              recipe: recipe,
              onTap: () {
                // Navigate to the detail screen when tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailScreen(recipe: recipe),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// ==========================================
// THE SMALL WIDGET (Mini Card)
// ==========================================
class RecipeMiniCard extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final VoidCallback onTap;

  const RecipeMiniCard({
    super.key,
    required this.recipe,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6), // Glassy white feel
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
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
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe["title"],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  recipe["description"],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(recipe["time"], style: const TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(width: 16),
                    const Icon(Icons.restaurant_menu, size: 16, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(recipe["difficulty"], style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// THE FULL DETAILS PAGE
// ==========================================
class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final List<String> ingredients = recipe["ingredients"];
    final List<String> instructions = recipe["instructions"];

    return Scaffold(
      backgroundColor: const Color(0xffF9EECA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Quick Stats
            Text(
              recipe["title"],
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatBadge(icon: Icons.timer, text: recipe["time"], color: Colors.orange),
                _StatBadge(icon: Icons.local_fire_department, text: recipe["calories"], color: Colors.redAccent),
                _StatBadge(icon: Icons.speed, text: recipe["difficulty"], color: Colors.green),
              ],
            ),
            const SizedBox(height: 30),

            // Ingredients Section
            const Text(
              "Ingredients",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ingredients.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("• ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Expanded(child: Text(item, style: const TextStyle(fontSize: 16))),
                    ],
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 30),

            // Instructions Section
            const Text(
              "Instructions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...List.generate(instructions.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.orangeAccent,
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        instructions[index],
                        style: const TextStyle(fontSize: 16, height: 1.4),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 40), // Padding at the bottom
          ],
        ),
      ),
    );
  }
}

// Small helper widget for the icons at the top of the detail screen
class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _StatBadge({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}