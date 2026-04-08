import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/recipe_provider.dart';

class SavedRecipesScreen extends StatelessWidget {
  const SavedRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("Saved Recipes",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {}),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            // --- Custom Toggle TabBar ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[500],
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: "Untried"),
                    Tab(text: "Made it"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Tab Views (List of Recipes) ---
            Expanded(
              child: TabBarView(
                children: [
                  _buildSavedList(context),
                  const Center(child: Text("You haven't cooked anything yet!")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedList(BuildContext context) {
    final provider = Provider.of<RecipeProvider>(context);

    // In a real app, you would filter provider.popularRecipes by a list of saved IDs
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      itemCount: provider.popularRecipes.length,
      itemBuilder: (context, index) {
        final recipe = provider.popularRecipes[index];
        return _savedRecipeTile(recipe);
      },
    );
  }

  Widget _savedRecipeTile(dynamic recipe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recipe Image
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              recipe.image,
              height: 85,
              width: 85,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipe.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    const Text(" 4,5", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 2),
                Text("By: Kadin Curtis",
                    style: TextStyle(color: Colors.grey[400], fontSize: 13)),
              ],
            ),
          ),
          // Orange Bookmark
          const Icon(Icons.bookmark, color: Colors.orange),
        ],
      ),
    );
  }
}