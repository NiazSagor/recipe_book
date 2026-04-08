// The Square Cards at the top
import 'package:flutter/material.dart';
import 'package:recipe_book/model/recipe.dart';
import 'package:recipe_book/ui/details_screen.dart';

// 1. The Square Cards (Popular Recipes section)
class RecipeGridCard extends StatelessWidget {
  final Recipe recipe; // Use the actual Recipe model
  const RecipeGridCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(recipe: recipe),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(recipe.image),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Rating Badge
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, size: 12, color: Colors.orange),
                    Text(
                      " ${recipe.aggregateLikes?.toStringAsFixed(1) ?? '5.0'}",
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
            // Title
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
                child: Text(
                  recipe.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. The Vertical Tiles (Recipes of The Week section)
class RecipeListTile extends StatelessWidget {
  final Recipe recipe;

  const RecipeListTile({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // InkWell gives a nice ripple effect on list items
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(recipe: recipe),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                recipe.image,
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.orange),
                      Text(
                        " ${recipe.aggregateLikes?.toStringAsFixed(1) ?? '4.0'}  •  By Kadin Curtis",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.bookmark_border, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
