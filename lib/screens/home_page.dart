import 'package:flutter/material.dart';
import 'package:yummysnap_proekt/services/recipe_service.dart';
import 'package:yummysnap_proekt/components/yummysnap_logo.dart';
import 'recipe_details_page.dart';
import 'add_recipe_page.dart';
import 'package:yummysnap_proekt/components/navigation_bar.dart';
import 'package:yummysnap_proekt/authentication/auth.dart';


class HomePage extends StatefulWidget {
  final Recipe? newRecipe;

  HomePage({this.newRecipe});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();
    Recipe? newRecipe = widget.newRecipe;
    if (newRecipe != null) {
      setState(() {
        recipes.add(newRecipe);
      });
    }
    _fetchRecipes();
  }

  Auth auth = Auth();

  Widget _userId() {
    return Text(
      "Welcome ${auth.currentUser?.email ?? 'User email'}",
      style: TextStyle(fontSize: 10.0),);

  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: () async {
        await auth.signOut();
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.deepOrangeAccent,
        fixedSize: Size(100, 30),
      ),
      child: Text(
        'Sign out',
        style: TextStyle(fontSize: 10, color: Colors.black),
      ),
    );
  }

  Future<void> _fetchRecipes() async {
    final recipeService = RecipeService();
    final fetchedRecipes = await recipeService.fetchRecipes();
    setState(() {
      recipes = fetchedRecipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    Recipe? newRecipe = ModalRoute.of(context)?.settings.arguments as Recipe?;

    if (newRecipe != null) {
      setState(() {
        recipes.add(newRecipe);
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          YummySnapLogo(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _userId(),
              _signOutButton(),
            ],
          ),
        ],
      ),
    ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _calculateCrossAxisCount(context),
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return RecipeCard(recipe: recipes[index]);
        },
      ),
      bottomNavigationBar: CustomBottomBar(
        onHomePressed: () {
        },
        onAddRecipePressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRecipeScreen(
                onSaveRecipe: (newRecipe) {
                  setState(() {
                    recipes.add(newRecipe);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }


  int _calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (screenWidth / 200).floor();
    return crossAxisCount > 0 ? crossAxisCount : 1;
  }
}


class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(recipe: recipe)),
        );
      },
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.network(recipe.imageUrl, height: 150,
                width: double.infinity,
                fit: BoxFit.cover),
            ListTile(
              title: Text(recipe.name),
            ),
          ],
        ),
      ),
    );
  }
}