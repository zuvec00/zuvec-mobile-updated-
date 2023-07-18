import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/components/my_ratingBar.dart';
import 'package:firebase_practice/services/database_service.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bottombar.dart';

class AppRating extends StatefulWidget {
  const AppRating({super.key});

  @override
  State<AppRating> createState() => _AppRatingState();
}

class _AppRatingState extends State<AppRating> {
  double _rating = 1;
  TextEditingController _controller = TextEditingController();
  //get current user ID
  String _getCurrentUserId() {
    final currentUser = FirebaseAuth.instance.currentUser!;
    String userID = currentUser.uid;
    return userID;
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
            'R A T I N G',
            style: GoogleFonts.quicksand(color: Colors.grey[900]),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Image.asset('lib/assets/feedback.png')),
                  Expanded(
                    child: Column(
                      children: [
                        Center(
                          child: RatingBar.builder(
                            initialRating: 4.5,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 30,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            itemBuilder: (context, index) => Icon(
                              FluentSystemIcons.ic_fluent_star_filled,
                              color: Colors.grey[900],
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                _rating = rating;
                                print(rating);
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 150,
                          child: TextField(
                            controller: _controller,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        width: 1.5, color: Colors.grey[600]!)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        width: 1.5,
                                        color: Colors.deepPurple[600]!)),
                                labelText: 'Give Feedback',
                                labelStyle: GoogleFonts.quicksand(
                                    color: Colors.grey[900]),
                                border: OutlineInputBorder()),
                          ),
                        ),
                        
                        
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            DatabaseService(uID: _getCurrentUserId())
                                .updateRating(_controller.text, _rating)
                                .whenComplete(() {
                              return showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Success!🎉',
                                        style: GoogleFonts.openSans(
                                            color: Colors.deepPurple[200],
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: Text(
                                          'Thanks for your review! Let us know if you have more feedback.',
                                          style: GoogleFonts.openSans(
                                              color: Colors.grey[300])),
                                      backgroundColor: Colors.deepPurple[600],
                                      elevation: 5,
                                    );
                                  }).then((_) =>_controller.clear());
                            });
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text('Sumbit Feedback',
                                  style: TextStyle(color: Colors.grey[100]))),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
