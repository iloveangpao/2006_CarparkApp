import 'package:flutter/material.dart';
import 'package:sc_2006/components/my_textfield.dart';
import 'package:sc_2006/components/square_tile.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  //text editing controller
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body:SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  //Logo
                  Image.asset("images/2343894.png",
                    height:50,),
                  const SizedBox(height:25),
                  //Welcome back
                  Text("Create your account in less then a minute !",
                    style: TextStyle(
                        color:Colors.grey[700],
                        fontSize: 16),

                  ),
                  const SizedBox(height:25),
                  //username textfield
                  MyTextfield(
                    controller: usernameController,
                    hintText: 'Username',
                    obscureText: false,
                  ),
                  const SizedBox(height:10),
                  //password textfield
                  MyTextfield(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  MyTextfield(
                    controller: passwordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  //forgot password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  //sign in button
                  GestureDetector(
                    child: Container(
                        padding: const EdgeInsets.all(25),
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(color: Colors.black,
                          borderRadius: BorderRadius.circular(8),),
                        child: Center(child: Text(
                          "Sign in",
                          style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),))
                    ),
                  ),
                  const SizedBox(height:50),
                  //or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400]
                        ),

                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text("Or Continue With",
                              style: TextStyle(color: Colors.grey[700])),
                        ),
                        Expanded(child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400]
                        ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  // google +apple sign in button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Google
                      SquareTile(imagePath: 'images/google-logo-9808.png'),

                      const SizedBox(width:10),
                      //Apple
                      SquareTile(imagePath: 'images/png-apple-logo-9711.png'),
                    ],
                  ),
                  const SizedBox(height:50),
                  //not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account ?"),
                      const SizedBox(width:4),
                      const Text("Log in now",
                        style:  TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),)
                    ],
                  )
                ],),
            ),
          ),
        )
    );
  }
}
