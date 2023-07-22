import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/components/my_containers/my_accountCont.dart';
import 'package:firebase_practice/pages/onboarding_page.dart';
import 'package:fluentui_icons/fluentui_icons.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Account extends StatelessWidget {
  Account({super.key});
  final List<dynamic> accountFieldDetails = [
    ['Preferences', '/preferences', Icons.menu],
    ['Contact Support', '/contactSupport', Icons.support_agent_outlined],
    ['Rate App', '/appRating', Icons.star_half_outlined],
    [
      'Support Developer',
      '/supportDeveloper',
      FluentSystemIcons.ic_fluent_gift_regular
    ],
  ];

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.grey[100],
            automaticallyImplyLeading: false,
            title: Text(
              'A C C O U N T',
              style: GoogleFonts.quicksand(color: Colors.grey[900]),
            ),
            centerTitle: true,
            actions: [
              IconButton(onPressed: signOut, icon: Icon(Icons.logout)),
              const SizedBox(width: 10),
            ]),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                itemCount: accountFieldDetails.length,
                itemBuilder: ((context, index) {
                  return MyAccountCont(
                      index: index,
                      accountText: accountFieldDetails[index][0],
                      routeName: accountFieldDetails[index][1],
                      icon: accountFieldDetails[index][2]);
                }),
              )),
              Text('Stay connected with Luchi on Instagram!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13.5)),
              InkWell(
                  onTap: () {
                    launchUrl(Uri.parse(
                        'https://instagram.com/luchi_elegantstitches?igshid=ZDdkNTZiNTM='));
                  },
                  child: Text('Tap here to follow us now',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[600],
                          fontSize: 13.5))),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ));
  }
}
