import 'package:carparkapp/pages/login_page.dart';
import 'package:flutter/material.dart';
import '../components/my_textfield.dart';
import '../components/square_tile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text editing controller
  final usernameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> signUpUser(BuildContext context) async {
    var url = Uri.parse('http://20.187.121.122/users/');

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // User was successfully signed up
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sign up successful'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          });
    } else {
      // An error occurred
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sign up unsuccessful'),
              content: Text(response.body),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    //Logo
                    Image.asset(
                      "images/2343894.png",
                      height: 120,
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "Create your account in less then a minute !",
                      style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold ),
                    ),
                    const SizedBox(height: 25),
                    //username textfield
                    MyTextfield(
                      controller: usernameController,
                      hintText: 'Username',
                      obscureText: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    //username textfield
                    MyTextfield(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    //password textfield
                    MyTextfield(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    MyTextfield(
                      controller: passwordController,
                      hintText: 'Confirm Password',
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password again';
                        } else if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    //forgot password
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [],
                      ),
                    ),
                    const SizedBox(height: 25),
                    //sign in button
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          // Form is valid, sign up user
                          signUpUser(context);
                        }
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
                            "Sign Up",
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
                              builder: (context) => LoginPage()));
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
                                "Back",
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
          ),
        ));
  }
}
