import 'package:carparkapp/pages/User.dart';
import 'package:flutter/material.dart';
import './home_page.dart';
import './map_page.dart';
import '../components/my_textfield.dart';
import '../components/square_tile.dart';
import 'register_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  //text editing controller
  final storage = FlutterSecureStorage();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn(BuildContext context) async {
    final url = Uri.parse('http://20.187.121.122/users?email=${usernameController.text}&password=${passwordController.text}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) => HomePage(email: usernameController.text),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login Failed"),
            content: Text("Invalid username or password"),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        },
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  //Logo
                  Image.asset(
                    "images/2343894.png",
                    height: 120,
                  ),
                  const SizedBox(height: 50),
                  //Welcome back
                  Text(
                    "Welcome back you\'ve been missed!",
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold ),
                  ),
                  const SizedBox(height: 25),
                  //username textfield
                  MyTextfield(
                    controller: usernameController,
                    hintText: 'Username',
                    obscureText: false,
                  ),
                  const SizedBox(height: 25),
                  //password textfield
                  MyTextfield(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  //forgot password
                  const SizedBox(height: 25),
                  //sign in button
                  GestureDetector(
                    onTap: () {
                     signUserIn(context);
                    },
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Color(0xff737373),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                            child: Text(
                          "Sign In",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ))),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                      onTap: () {
                        int index;
                        String name;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                      },
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Color(0xff737373),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                            child: Text(
                              "Register",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ))),
                  ),
                  //or continue with
                ],
              ),
            ),
          ),
        ));
  }
}
