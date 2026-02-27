import 'package:flutter/material.dart';
import 'package:kitahack_frontend/GlassButton.dart';
import 'package:kitahack_frontend/globals.dart'; // IMPORT THE GLOBALS HERE

class ShoppingListScreen extends StatefulWidget {
  // We removed the required recipes constructor!
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  @override
  Widget build(BuildContext context) {
    // Calculate progress directly from the global list
    int checkedCount = globalShoppingList.where((item) => item["isChecked"] == true).length;
    double progress = globalShoppingList.isEmpty ? 0 : checkedCount / globalShoppingList.length;

    return Scaffold(
      backgroundColor: const Color(0xffF9EECA),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Shopping List",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: 200,
        margin: const EdgeInsets.only(bottom: 10),
        child: GlassButton(
          text: "Clear Completed", // Changed button functionality for better UX
          color: Colors.lightGreen,
          onPressed: () {
            setState(() {
              // Removes all items that are checked off
              globalShoppingList.removeWhere((item) => item["isChecked"] == true);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Cleared completed items!")),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // --- Progress Bar Section ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Text(
                    "$checkedCount / ${globalShoppingList.length} items",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: Colors.white.withValues(alpha: 0.5),
                        color: Colors.lightGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- The Checklist ---
            Expanded(
              child: globalShoppingList.isEmpty 
                ? const Center(
                    child: Text(
                      "Your list is empty.\nSave some recipes first!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                    itemCount: globalShoppingList.length,
                    itemBuilder: (context, index) {
                      final item = globalShoppingList[index];
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: CheckboxListTile(
                          title: Text(
                            item["name"],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              decoration: item["isChecked"] 
                                  ? TextDecoration.lineThrough 
                                  : TextDecoration.none,
                              color: item["isChecked"] 
                                  ? Colors.grey 
                                  : Colors.black87,
                            ),
                          ),
                          value: item["isChecked"],
                          activeColor: Colors.lightGreen,
                          checkColor: Colors.white,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          onChanged: (bool? newValue) {
                            setState(() {
                              // Updates the global list directly
                              item["isChecked"] = newValue ?? false;
                            });
                          },
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}