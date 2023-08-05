import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/components/my_button.dart';
import 'package:firebase_practice/pages/login_or_register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GuestPage extends StatefulWidget {
  const GuestPage({super.key});

  @override
  State<GuestPage> createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {
  Future<void> signInAnonymously(BuildContext context) async {
    try {
      // Show loading screen
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(color: Colors.deepPurple[600]),
          );
        },
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      // Access the anonymous user's ID using userCredential.user.uid
      print('Anonymous user ID: ${userCredential.user?.uid}');

      // Close the loading dialog after successful sign-in
      Navigator.pop(context);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Show error dialog if sign-in fails
      print("Failed to sign in anonymously: $e");
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Guest sign in failed',
              style: GoogleFonts.quicksand(
                color: Colors.deepPurple[200],
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              '${e.message}',
              style: GoogleFonts.quicksand(color: Colors.grey[300]),
            ),
            backgroundColor: Colors.deepPurple[600],
            elevation: 5,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the error dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(children: [
        Expanded(flex: 3, child: Image.asset('lib/assets/guest.png')),
        Expanded(
            flex: 2,
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Text('View As Guest',
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                    'Explore as Guest: Enjoy our app without signing in. No accounts needed, just hassle-free browsing!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              ),
              const SizedBox(height: 25),
              MyButton2(
                  text: 'Continue As Guest',
                  onTap: () {
                    signInAnonymously(context);
                  }),
              const SizedBox(height: 15),
              MyButton(
                  text: 'Login/Register',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) =>
                                const LoginOrRegisterPage())));
                  }),
            ]))
      ]),
    );
  }
}
