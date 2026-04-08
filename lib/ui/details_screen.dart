import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/model/recipe.dart';

import 'provider/recipe_provider.dart';

class DetailsScreen extends StatelessWidget {
  final Recipe recipe;
  const DetailsScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Image
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(recipe.image),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Custom App Bar (Back and Bookmark)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleButton(Icons.arrow_back, () => Navigator.pop(context)),
                  const Text("Recipe Details",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  Consumer<RecipeProvider>(
                    builder: (context, provider, child) {
                      final isSaved = provider.isFavorite(recipe);
                      return _circleButton(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                            () => provider.toggleFavorite(recipe),
                        color: isSaved ? Colors.orange : Colors.white,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // 3. The Content Card
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
                          child: Text(recipe.title,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        ),
                        _ratingBadge(recipe.aggregateLikes.toString()),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Stats (Time, Difficulty, Calories)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoIcon(Icons.access_time, "${recipe.readyInMinutes} mins"),
                        _infoIcon(Icons.bar_chart, "Medium"),
                        _infoIcon(Icons.local_fire_department, "100 Cal"),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // Ingredients Section
                    const Text("Ingredients",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    _ingredientsList(),

                    const SizedBox(height: 25),

                    // Description Section
                    const Text("Description",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(
                      recipe.summary?.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '') ?? "No description available.",
                      style: TextStyle(color: Colors.grey[600], height: 1.5),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Text("Read More", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),

                    const SizedBox(height: 30),

                    // Watch Videos Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.play_circle_fill, color: Colors.white),
                        label: const Text("Watch Videos", style: TextStyle(fontSize: 16, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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

  Widget _circleButton(IconData icon, VoidCallback onTap, {Color color = Colors.white}) {
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
      decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
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

  Widget _ingredientsList() {
    // Horizontal list of ingredient icons as seen in screenshot
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recipe.ingredients?.length ?? 0,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[100],
                  child: const Icon(Icons.restaurant, color: Colors.orange), // In real app, use ingredient icons
                ),
                const SizedBox(height: 5),
                Text(recipe.ingredients![index].split(' ').last, style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}
