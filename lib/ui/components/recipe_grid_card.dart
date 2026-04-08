// The Square Cards at the top
import 'package:flutter/material.dart';

class RecipeGridCard extends StatelessWidget {
  final dynamic recipe;
  const RecipeGridCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: NetworkImage(recipe.image), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          // Rating Badge
          Positioned(top: 10, left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(10)),
              child: const Row(children: [Icon(Icons.star, size: 12, color: Colors.orange), Text(" 5.0", style: TextStyle(color: Colors.white, fontSize: 10))]),
            ),
          ),
          // Bookmark
          Positioned(top: 10, right: 10, child: Icon(Icons.bookmark, color: Colors.white.withOpacity(0.8))),
          // Title/Subtitle
          Positioned(bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)), color: Colors.black.withOpacity(0.3)),
              child: Text(recipe.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1),
            ),
          )
        ],
      ),
    );
  }
}

// The Vertical Tiles at the bottom
class RecipeListTile extends StatelessWidget {
  final dynamic recipe;
  const RecipeListTile({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(recipe.image, height: 70, width: 70, fit: BoxFit.cover),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipe.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Row(children: [Icon(Icons.star, size: 14, color: Colors.orange), Text(" 4.5  •  By Kadin Curtis", style: TextStyle(color: Colors.grey, fontSize: 12))]),
              ],
            ),
          ),
          const Icon(Icons.bookmark_border, color: Colors.grey),
        ],
      ),
    );
  }
}
