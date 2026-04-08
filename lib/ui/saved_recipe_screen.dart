import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/model/recipe.dart';
import 'package:recipe_book/ui/details_screen.dart';

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
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Saved Recipes",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {},
            ),
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
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[500],
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
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
    // Use watch to rebuild the list when a recipe is "unsaved"
    final savedList = context.watch<RecipeProvider>().savedRecipes;

    if (savedList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 10),
            const Text(
              "No saved recipes yet!",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      itemCount: savedList.length,
      itemBuilder: (context, index) {
        final recipe = savedList[index];
        return _savedRecipeTile(context, recipe);
      },
    );
  }

  Widget _savedRecipeTile(BuildContext context, Recipe recipe) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(recipe: recipe),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            // Info Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    recipe.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      Text(
                        " ${recipe.aggregateLikes?.toStringAsFixed(1) ?? '4.5'}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "By: Spoonacular Chef",
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.bookmark, color: Colors.orange),
              onPressed: () {
                context.read<RecipeProvider>().toggleFavorite(recipe);
              },
            ),
          ],
        ),
      ),
    );
  }
}
