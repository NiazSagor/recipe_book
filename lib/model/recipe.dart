class Recipe {
  final int id;
  final String title;
  final String image;
  final int? readyInMinutes;
  final double? aggregateLikes;
  final String? summary;
  final List<String>? ingredients;

  Recipe({
    required this.id,
    required this.title,
    required this.image,
    this.readyInMinutes,
    this.aggregateLikes,
    this.summary,
    this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      readyInMinutes: json['readyInMinutes'],
      aggregateLikes: (json['spoonacularScore'] ?? 0.0).toDouble(),
      summary: json['summary'],
      ingredients: json['extendedIngredients'] != null
          ? (json['extendedIngredients'] as List)
                .map((i) => i['original'] as String)
                .toList()
          : [],
    );
  }
}
