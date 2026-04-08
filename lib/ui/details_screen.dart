import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/model/recipe.dart';

import 'provider/recipe_provider.dart';

class DetailsScreen extends StatefulWidget {
  final Recipe recipe;

  const DetailsScreen({super.key, required this.recipe});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.recipe.extendedIngredients.isEmpty) {
      Future.microtask(
        () =>
            context.read<RecipeProvider>().fetchRecipeDetails(widget.recipe.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();
    final currentRecipe = provider.popularRecipes.firstWhere(
      (r) => r.id == widget.recipe.id,
      orElse: () => widget.recipe,
    );
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.recipe.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleButton(Icons.arrow_back, () => Navigator.pop(context)),
                  const Text(
                    "Recipe Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Consumer<RecipeProvider>(
                    builder: (context, provider, child) {
                      final isSaved = provider.isFavorite(widget.recipe);
                      return _circleButton(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        () => provider.toggleFavorite(widget.recipe),
                        color: isSaved ? Colors.orange : Colors.white,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.recipe.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _ratingBadge(widget.recipe.aggregateLikes.toString()),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Stats (Time, Difficulty, Calories)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoIcon(
                          Icons.access_time,
                          "${widget.recipe.readyInMinutes} mins",
                        ),
                        _infoIcon(Icons.bar_chart, "Medium"),
                        _infoIcon(Icons.local_fire_department, "100 Cal"),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // Ingredients Section
                    const Text(
                      "Ingredients",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    currentRecipe.extendedIngredients.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.orange,
                            ),
                          )
                        : _ingredientsList(currentRecipe),

                    const SizedBox(height: 25),

                    // Description Section
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.recipe.summary?.replaceAll(
                            RegExp(r'<[^>]*>|&[^;]+;'),
                            '',
                          ) ??
                          "No description available.",
                      style: TextStyle(color: Colors.grey[600], height: 1.5),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Text(
                      "Read More",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Watch Videos Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Watch Videos",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI Helpers ---
  Widget _circleButton(
    IconData icon,
    VoidCallback onTap, {
    Color color = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: color, // Now dynamic!
          size: 20,
        ),
      ),
    );
  }

  Widget _ratingBadge(String rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.orange, size: 16),
          Text(" $rating", style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _infoIcon(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
      ],
    );
  }

  Widget _ingredientsList(Recipe recipe) {
    if (widget.recipe.extendedIngredients.isEmpty) {
      return const Text(
        "No ingredients listed.",
        style: TextStyle(color: Colors.grey),
      );
    }

    return SizedBox(
      height: 110, // Increased height for text
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recipe.extendedIngredients.length,
        itemBuilder: (context, index) {
          final ingredient = recipe.extendedIngredients[index];
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: ingredient.image.isNotEmpty
                      ? Image.network(ingredient.image, fit: BoxFit.contain)
                      : const Icon(Icons.restaurant, color: Colors.orange),
                ),
                const SizedBox(height: 8),
                Text(
                  ingredient.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${ingredient.amount.toStringAsFixed(1)} ${ingredient.unit}",
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
