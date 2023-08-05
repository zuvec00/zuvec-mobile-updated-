import 'package:firebase_practice/bottombar.dart';
import 'package:firebase_practice/pages/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  void initState() {
    super.initState();
    //whenever the initialization is complete, remove the splash screen
    Future.delayed(Duration(milliseconds: 400))
        .then((value) => {FlutterNativeSplash.remove()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                // User is signed in (including anonymous users)
                if (snapshot.data != null) {
                  return const MyBottomBar();
                }
                // User NOT signed in (anonymous users or not signed in at all)
                else {
                  return OnBoarding();
                }
              } else {
                // Handle other connection states, e.g., waiting or done.
                // For example, you can return a loading indicator.
                return CircularProgressIndicator();
              }
            }));
  }
}
