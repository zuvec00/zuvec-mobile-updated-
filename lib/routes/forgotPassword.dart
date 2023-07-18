// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/my_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String resetPasswordError = '';
  final TextEditingController emailIDController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailIDController.dispose();
  }

  Future _passwordReset() async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return Center(
                child:
                    CircularProgressIndicator(color: Colors.deepPurple[600]));
          });
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailIDController.text.trim());
      Navigator.pop(context);
      setState(
        () {
          resetPasswordError = '';
        },
      );
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Success!🎉',
                style: GoogleFonts.openSans(
                    color: Colors.deepPurple[200], fontWeight: FontWeight.bold),
              ),
              content: Text('Password reset link sent! Check your email.',
                  style: GoogleFonts.openSans(color: Colors.grey[300])),
              backgroundColor: Colors.deepPurple[600],
              elevation: 5,
            );
          });
    } on FirebaseAuthException catch (error) {
      Navigator.pop(context);
      print('Reset error:$error');
      setState(() {
        resetPasswordError = error.code;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.topLeft,
                    children: [
                      Padding(padding:const EdgeInsets.symmetric(vertical:30), child:Image.asset('lib/assets/forgot_password.png')),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:15.0,vertical:7.5),
                        child: Icon(Icons.arrow_back_ios_rounded,color:Colors.grey[900],size:28),
                      )
                    ],
                  )),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          'Forgot\nPassword?',
                          style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                            'Don\'t worry it happens. Please enter the address associated with your account.',
                            style: TextStyle(color: Colors.grey[600])),
                      ),
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.50),
                        child: MyTextField(
                          controller: emailIDController,
                          hintText: 'Email-ID',
                          obscureText: false,
                          paddingHeight: 0,
                        ),
                      ),
                      if (resetPasswordError != '')
                        //authentication error code
                        Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              resetPasswordError,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 13),
                            )),
                      const SizedBox(height: 30),
                      MyButton(
                          text: 'Submit',
                          paddingWidth: 15,
                          onTap: _passwordReset),
                    ],
                  ))
                ],
              ),
            ),
          ),
        ));
  }
}
