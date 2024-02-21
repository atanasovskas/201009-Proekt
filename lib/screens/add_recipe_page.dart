import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yummysnap_proekt/components/yummysnap_logo.dart';
import 'package:yummysnap_proekt/components/navigation_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:yummysnap_proekt/authentication/auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yummysnap_proekt/services/recipe_service.dart';
import 'home_page.dart';

class AddRecipeScreen extends StatefulWidget {
  final Function(Recipe) onSaveRecipe;

  AddRecipeScreen({required this.onSaveRecipe});

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController preparationController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController nutritionController = TextEditingController();

  File? _image;
  Auth auth = Auth();


  Future<void> _getImageFromCamera() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      await Permission.camera.request();
    }

    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _getImageFromGallery() async {
    if (kIsWeb) {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      setState(() {
        _image = pickedFile != null ? File(pickedFile.path) : null;
      });
    } else {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      setState(() {
        _image = pickedFile != null ? File(pickedFile.path) : null;
      });
    }
  }

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

  void _saveRecipe() {
    Recipe newRecipe = Recipe(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text,
      imageUrl: _image != null ? _image!.path : "",
      description: preparationController.text,
      ingredients: ingredientsController.text.split('\n').where((ingredient) => ingredient.isNotEmpty).toList(),
    );

    widget.onSaveRecipe(newRecipe);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add Recipe',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrangeAccent,
                ),
              ),
              SizedBox(height: 20),

              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Recipe Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              _image == null
                  ? Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Icon(Icons.image, size: 50, color: Colors.grey),
              )
                  : kIsWeb
                  ? Image.network(_image!.path, height: 100, width: 100)
                  : Image.file(_image!, height: 100, width: 100),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _getImageFromCamera,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepOrangeAccent,
                    ),
                    child: Text('Use your camera', style: TextStyle(color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: _getImageFromGallery,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepOrangeAccent,
                    ),
                    child: Text('Upload image', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
              SizedBox(height: 10),

              TextField(
                controller: preparationController,
                decoration: InputDecoration(
                  labelText: 'Preparation',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 10),
              TextField(
                controller: ingredientsController,
                decoration: InputDecoration(
                  labelText: 'Ingredients',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 10),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _saveRecipe();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepOrangeAccent,
                    ),
                    child: Text('Save', style: TextStyle(color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepOrangeAccent,
                    ),
                    child: Text('Cancel', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        onHomePressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        },
        onAddRecipePressed: () {},
      ),
    );
  }
}