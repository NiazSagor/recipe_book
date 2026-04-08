import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_book/model/recipe.dart';

class RecipeProvider extends ChangeNotifier {
  final String _apiKey = '06add25c93714538a539fd6244915f9b';
  List<Recipe> _popularRecipes = [];
  bool _isLoading = false;

  List<Recipe> get popularRecipes => _popularRecipes;

  bool get isLoading => _isLoading;

  Future<void> fetchPopularRecipes() async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse(
      'https://api.spoonacular.com/recipes/complexSearch?apiKey=$_apiKey&addRecipeInformation=true&number=10',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _popularRecipes = (data['results'] as List)
            .map((item) => Recipe.fromJson(item))
            .toList();
      }
    } catch (e) {
      debugPrint("Error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
