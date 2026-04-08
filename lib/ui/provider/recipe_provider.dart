import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_book/model/recipe.dart';

class RecipeProvider extends ChangeNotifier {
  final String _apiKey = '06add25c93714538a539fd6244915f9b';
  List<Recipe> _popularRecipes = [];
  final List<Recipe> _savedRecipes = [];

  List<Recipe> get savedRecipes => _savedRecipes;
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

  Future<void> fetchRecipeDetails(int id) async {
    final url = Uri.parse(
      'https://api.spoonacular.com/recipes/$id/information?apiKey=$_apiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final fullRecipe = Recipe.fromJson(data);
        int index = _popularRecipes.indexWhere((r) => r.id == id);
        if (index != -1) {
          _popularRecipes[index] = fullRecipe;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint("Detail Fetch Error: $e");
    }
  }

  void toggleFavorite(Recipe recipe) {
    final isExist = _savedRecipes.contains(recipe);
    if (isExist) {
      _savedRecipes.remove(recipe);
    } else {
      _savedRecipes.add(recipe);
    }
    notifyListeners();
  }

  bool isFavorite(Recipe recipe) {
    return _savedRecipes.contains(recipe);
  }
}
