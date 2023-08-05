import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_practice/components/my_showPassword.dart';
import 'package:firebase_practice/screens/home.dart';
import 'package:firebase_practice/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_practice/components/my_button.dart';
import 'package:firebase_practice/components/my_textfield.dart';
import 'package:provider/provider.dart';

import '../bottombar.dart';
import '../provider/model.dart';
import '../services/messaging_service.dart';

class Register extends StatefulWidget {
  final Function() onTap;
  Register({super.key, required this.onTap});

  @override
  State<Register> createState() => _RegisterState();
}

String _getCurrentUserId() {
  final User currentUser = FirebaseAuth.instance.currentUser!;
  String userID = currentUser.uid;
  return userID;
}

class _RegisterState extends State<Register> {
  MessagingService messagingService = MessagingService();
  Home homePage = Home();

  //error message
  String errorMessage = '';

  //password visiblity
  bool obscureText = true;
  String? mToken = '';

  //text editing controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNoController = TextEditingController();
  final emailIDController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void initState() {
    super.initState();
    messagingService.requestPermission();
    gettoken();
    messagingService.initInfo();
  }

  //dispose controllers
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNoController.dispose();
    emailIDController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  // G E T  T O K E N
  gettoken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mToken = token;
        print('User token: $mToken');
      });
    });
  }

  registerUser(String email, String password) async {
    //try register user
    try {
      //show loading screen
      showDialog(
          context: context,
          builder: (context) {
            return Center(
                child:
                    CircularProgressIndicator(color: Colors.deepPurple[600]));
          });
      if (passwordController.text.trim() ==
          confirmPasswordController.text.trim()) {
        final response = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        print('Register user response: $response');
        final user = response.user;
        print('User = $user');
        final uID = user!.uid;

        Home(
          firstName: firstNameController.text.trim(),
        );
        //await DatabaseService(uID: uID).createUserWishlistCollection();
        // await DatabaseService(uID: uID).createUserCartCollection();
        //await DatabaseService(uID: uID).createUserAddressCollection();
        // await DatabaseService(uID: uID).createUserOrderCollection();
        await DatabaseService(uID: uID).updateUserData(
            mToken!,
            firstNameController.text,
            lastNameController.text,
            phoneNoController.text,
            emailIDController.text);
        Navigator.pop(context);
       await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyBottomBar(),
            ));

        Provider.of<Model>(context, listen: false).itemSavedHandler();
        
        print('code reached here');
      } else {
        //show error message, password do not match
        setState(() {
          errorMessage = 'Password don\'t match';
        });
      }

      //pop the loading screen
      Navigator.pop(context);
    } on FirebaseAuthException catch (error) {
      //pop the loading screen
      Navigator.pop(context);
      //get the error message
      setState(() {
        errorMessage = error.code;
      });
      print('Signing up error: $error');
    }
  }

  void toggleVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 5,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '  Create Your \n  Account',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        MyTextField(
                            controller: firstNameController,
                            hintText: 'First name',
                            obscureText: false),
                        const SizedBox(height: 20),
                        MyTextField(
                            controller: lastNameController,
                            hintText: 'Last name',
                            obscureText: false),
                        const SizedBox(height: 20),
                        MyTextField(
                            controller: phoneNoController,
                            hintText: 'Phone number',
                            obscureText: false),
                        const SizedBox(height: 20),
                        MyTextField(
                            controller: emailIDController,
                            hintText: 'Email -ID',
                            obscureText: false),

                        //authentication error code
                        if (errorMessage != 'Password don\'t match')
                          Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Text(
                                errorMessage,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 13),
                              )),
                        const SizedBox(height: 5),
                        InkWell(
                          onTap: toggleVisibility,
                          child: ShowPassword(
                            obscureText: obscureText,
                            child: MyTextField(
                                controller: passwordController,
                                hintText: 'Password',
                                obscureText: obscureText),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MyTextField(
                            controller: confirmPasswordController,
                            hintText: 'Confirm password',
                            obscureText: obscureText),
                        //password authentication error
                        if (errorMessage == 'Password don\'t match' ||
                            errorMessage == 'weak-password')
                          Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Text(
                                errorMessage,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 13),
                              )),
                        const SizedBox(height: 30),

                        MyButton(
                            text: 'Sign Up',
                            onTap: () {
                              registerUser(emailIDController.text.trim(),
                                  passwordController.text.trim());
                            }),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already a member?'),
                            GestureDetector(
                              onTap: widget.onTap,
                              child: Text('Login',
                                  style:
                                      TextStyle(color: Colors.deepPurple[600])),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//pls find a better name
