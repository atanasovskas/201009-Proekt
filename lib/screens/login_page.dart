import 'package:flutter/material.dart';
import '../authentication/auth.dart';
import '../components/yummysnap_logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart' as location;
import 'package:permission_handler/permission_handler.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginPage> {
  String? errorMess = "";
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  location.Location loc = location.Location();
  PermissionStatus? _locationPermissionStatus;

  Future<void> _checkLocationPermission() async {
    _locationPermissionStatus = await Permission.location.status;
    setState(() {});
  }

  Future<void> _requestLocationPermission() async {
    if (_locationPermissionStatus != PermissionStatus.granted) {
      await Permission.location.request();
      _checkLocationPermission();
    }
  }

    Future<void> signInWithEmailAndPassword() async {
      if (_controllerEmail.text.isEmpty || _controllerPassword.text.isEmpty) {
        setState(() => errorMess = 'Please fill all input fields!');
        return;
      }
      try {
        await Auth().singInWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
        );
      }  on FirebaseAuthException catch (err) {
        setState(() {
          if (err.code == 'wrong-password') {
            errorMess = 'The email and password don\'t match!';
          } else {
            errorMess = 'The email and password don\'t match. If you don\'t have an account, please register.';
          }
        });
      }
    }

    Future<void> createUserWithEmailAndPassword() async {
      if (_controllerEmail.text.isEmpty || _controllerPassword.text.isEmpty) {
        setState(() => errorMess = 'Please fill all input fields!');
        return;
      }
      try {
        await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
        );
      } on FirebaseAuthException catch (err) {
        setState(() {
          errorMess = err.message;
        });
      }
    }


    Widget _title() {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          isLogin ? 'Login' : 'Register',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      );
    }
    Widget _entryField(String title, TextEditingController controller) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: title,
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepOrange), // Set the desired border color
            ),
          ),
        ),
      );
    }

    Widget _errorMessage() {
      return Text(
        errorMess == '' ? '' : '$errorMess',
        style: TextStyle(color: Colors.red),
      );
    }

    Widget _submitButton() {
      return ElevatedButton(
        onPressed: isLogin
            ? signInWithEmailAndPassword
            : createUserWithEmailAndPassword,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
        ),
        child: Text(
          isLogin ? 'Login' : 'Register',
          style: TextStyle(color: Colors.black),
        ),
      );
    }

    Widget _loginOrRegisterButton() {
      return TextButton(
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(
          isLogin
              ? "Don't have an account? Register here"
              : 'Already have an account? Login here',
          style: TextStyle(color: Colors.black),
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              YummySnapLogo(), // Replace with your MyLogo widget
              _title(),
              _entryField('Email', _controllerEmail),
              _entryField('Password', _controllerPassword),
              _errorMessage(),
              _submitButton(),
              _loginOrRegisterButton(),
              ElevatedButton(
                onPressed: _requestLocationPermission,
                child: Text('Allow location',style: TextStyle(fontSize: 10, color: Colors.black)),
              ),
            ],
          ),
        ),
      );
    }
  }