import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/bottombar.dart';
import 'package:firebase_practice/screens/account.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/database_service.dart';

class Preferences extends StatefulWidget {
  Preferences({super.key});

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  bool isSwitched = true;

  void initState() {
    super.initState();
    DatabaseService(uID: _getCurrentUserId())
        .updateUserEmailPreference(_getUserEmail(), isSwitched);
  }

  //get current user ID
  String _getCurrentUserId() {
    final currentUser = FirebaseAuth.instance.currentUser!;
    String userID = currentUser.uid;
    return userID;
  }

  //user email
  String _getUserEmail() {
    final user = FirebaseAuth.instance.currentUser!;
    return user.email!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey[100],
          leading: IconButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyBottomBar())),
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text(
            'P R E F E R E N C E S',
            style: GoogleFonts.quicksand(color: Colors.grey[900]),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'E-mail notifications',
                        style: TextStyle(fontSize: 14.5),
                      ),
                      Switch(
                        value: isSwitched,
                        onChanged: (bool newValue) {
                          setState(() {
                            isSwitched = newValue;
                          });
                          DatabaseService(uID: _getCurrentUserId())
                              .updateUserEmailPreference(
                                  _getUserEmail(), isSwitched);
                          print('email Subscribed: $isSwitched');
                        },
                        activeColor: Colors.deepPurple[600],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
