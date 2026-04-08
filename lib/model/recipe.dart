class Recipe {
  final int id;
  final String title;
  final String image;
  final int readyInMinutes;
  final double aggregateLikes;
  final String summary;
  final List<Ingredient> extendedIngredients;

  Recipe({
    required this.id,
    required this.title,
    required this.image,
    required this.readyInMinutes,
    required this.aggregateLikes,
    required this.summary,
    required this.extendedIngredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      readyInMinutes: json['readyInMinutes'] ?? 0,
      aggregateLikes: (json['aggregateLikes'] ?? 0.0).toDouble(),
      summary: json['summary'] ?? '',
      extendedIngredients: json['extendedIngredients'] != null
          ? (json['extendedIngredients'] as List)
                .map((i) => Ingredient.fromJson(i))
                .toList()
          : [],
    );
  }
}

class Ingredient {
  final int id;
  final String name;
  final String image;
  final double amount;
  final String unit;

  Ingredient({
    required this.id,
    required this.name,
    required this.image,
    required this.amount,
    required this.unit,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] != null
          ? "https://spoonacular.com/cdn/ingredients_100x100/${json['image']}"
          : "",
      amount: (json['amount'] ?? 0.0).toDouble(),
      unit: json['unit'] ?? '',
    );
  }
}
