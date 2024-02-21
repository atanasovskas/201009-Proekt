import 'dart:convert';
import 'package:http/http.dart' as http;


class RecipeService {
  Future<List<Recipe>> fetchRecipes() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s='));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> meals = data['meals'];
      return meals.map((meal) => Recipe.fromJson(meal)).toList();
    } else {
      throw Exception('Can\'t load recipes');
    }
  }
}

class Recipe {
  final String id;
  final String name;
  final String? area;
  final String imageUrl;
  final String description;
  final List<String> ingredients;

  Recipe({
    required this.id,
    required this.name,
    this.area,
    required this.imageUrl,
    required this.description,
    required this.ingredients,
  });


  factory Recipe.fromJson(Map<String, dynamic> json) {
    String id = json['idMeal'] ?? "";
    String name = json['strMeal'] ?? "";
    String area = json['strArea'] ?? "";
    String imageUrl = json['strMealThumb'] ?? "";
    String description = json['strInstructions'] ?? "";

    List<String> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      String ingredient = json['strIngredient$i'] ?? "";
      String measure = json['strMeasure$i'] ?? "";

      if (ingredient.isNotEmpty) {
        ingredients.add('$ingredient $measure');
      }
    }

    return Recipe(
      id: id,
      name: name,
      imageUrl: imageUrl,
      description: description,
      ingredients: ingredients,
    );
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      area: map['area'],
      imageUrl: map['imageUrl'],
      description: map['description'],
      ingredients: List<String>.from(map['ingredients']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'area': area,
      'imageUrl': imageUrl,
      'description': description,
      'ingredients': ingredients,
    };
  }
}