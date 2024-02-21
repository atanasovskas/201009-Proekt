import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final VoidCallback onHomePressed;
  final VoidCallback onAddRecipePressed;

  CustomBottomBar({
    required this.onHomePressed,
    required this.onAddRecipePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepOrangeAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: onHomePressed,
            color: Colors.black,
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: onAddRecipePressed,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}