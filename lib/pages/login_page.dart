// ignore_for_file: body_might_complete_normally_catch_error

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_practice/components/my_button.dart';
import 'package:firebase_practice/components/my_textfield.dart';

import '../bottombar.dart';
import '../components/my_showPassword.dart';
import '../routes/forgotPassword.dart';

class LoginPage extends StatefulWidget {
  final Function() onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text editing controllers
  final emailIDController = TextEditingController();
  final passwordController = TextEditingController();

  String errorMessage = '';

  //toggle visiblity
  bool obscureText = true;

  //dispose controllers
  void dispose() {
    super.dispose();
    emailIDController.dispose();
    passwordController.dispose();
  }

  void signInUser(String email, String password) async {
    //show loading screen
    showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: CircularProgressIndicator(color: Colors.deepPurple[600]));
        });
    //try sign in
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((error) {
      setState(() {
        errorMessage = error.code;
      });
      Navigator.pop(context);
      //for debugging
      print('User Login error: ${error.code}');
    });
    Navigator.pop(context);
    Navigator.push(context,MaterialPageRoute(builder: (context) => MyBottomBar(),));
  }

  void toggleVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child:
                      Container(child: Image.asset('lib/assets/register.png'))),
              Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 25),
                          MyTextField(
                              controller: emailIDController,
                              hintText: 'Email -ID',
                              obscureText: false),

                          if (errorMessage != 'wrong-password')
                            //authentication error code
                            Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: Text(
                                  errorMessage,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 13),
                                )),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: toggleVisibility,
                            child: ShowPassword(
                              child: MyTextField(
                                  controller: passwordController,
                                  hintText: 'Password',
                                  obscureText: obscureText),
                              obscureText: obscureText,
                            ),
                          ),

                          // password authentication error code
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: errorMessage == 'wrong-password'
                                ? Text(
                                    errorMessage,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 13),
                                  )
                                : Text(''),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  ForgotPasswordPage())));
                                    },
                                    child: Text('Forgot password?',
                                        style: TextStyle(
                                            color: Colors.deepPurple[600],
                                            fontWeight: FontWeight.bold))),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          MyButton(
                              text: 'Sign In',
                              onTap: () {
                                signInUser(emailIDController.text.trim(),
                                    passwordController.text.trim());
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Not a member?'),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: Text('Register',
                                style: TextStyle(color: Color(0xFF5E35B1))),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

//pls find a better name
class CustomTextField extends StatelessWidget {
  final IconData icon;
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const CustomTextField({
    super.key,
    required this.icon,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return MyTextField(
        controller: controller, hintText: hintText, obscureText: false);
  }
}
