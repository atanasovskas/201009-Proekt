import '../screens/home_page.dart';
import '../screens/login_page.dart';
import '../authentication/auth.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot)
      {
        if(snapshot.hasData)
        {
          return HomePage();
        }
        else
        {
          return LoginPage();
        }
      },
    );
  }
}