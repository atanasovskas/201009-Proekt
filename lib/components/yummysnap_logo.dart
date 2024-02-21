import 'package:flutter/material.dart';

class YummySnapLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 30),
          children: [
            TextSpan(
              text: 'Yummy',
              style: TextStyle(color: Colors.deepOrangeAccent),
            ),
            TextSpan(
              text: 'Snap',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}