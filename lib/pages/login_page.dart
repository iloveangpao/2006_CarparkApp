
import 'package:flutter/material.dart';
import './home_page.dart';
import './map_page.dart';
import '../components/my_textfield.dart';
import '../components/square_tile.dart';
import 'register_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class User {
  final int id;
  final String email;
  final String password;

  User({required this.id, required this.email, required this.password});
}

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  //text editing controller
  final storage = FlutterSecureStorage();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();


 void login(BuildContext context, String email, String password) async{
    final url = Uri.parse('http://20.187.121.122/token');
    final response = await http.post(
        url,
        body:{
          'username' : email,
          'password' : password
        }
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
     print("Data: $data");
      await storage.write(key: "access_token", value: data['access_token']);

      getUserDetails(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(email: email),
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
  void getUserDetails(BuildContext context) async {
    final token = await storage.read(key: "access_token");
    print("token Read: $token");
    final url = Uri.parse('http://20.187.121.122/users/me/');
    final response = await http.get(
      url,
      headers: {
        'accept' : 'application/json',
        'Authorization': 'Bearer $token',
      },

    );
    final newresponse = response.body;
    print(newresponse);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      final id = data['id'];
      final email = data['email'];
      final username = data['username'];

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("User Details"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ID: $id"),
                SizedBox(height: 8),
                Text("Email: $email"),
                SizedBox(height: 8),
                Text("Username: $username"),
              ],
            ),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(email: email),
                    ),
                  );
                },
              )
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(response.statusCode.toString()),
            content: Text("error"),
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


/*
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
*/
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  //password textfield
                  MyTextfield(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  //forgot password
                  const SizedBox(height: 25),
                  //sign in button
                  GestureDetector(
                    onTap: () {
                     login(context,usernameController.text, passwordController.text);
                      //signUserIn(context);
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
