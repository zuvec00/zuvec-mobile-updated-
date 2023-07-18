import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RatingsAndReviews extends StatelessWidget{
   Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.grey[100],
      appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.grey[100],
            automaticallyImplyLeading: false,
            title: Text(
              'R A T I N G S',
              style: GoogleFonts.quicksand(color: Colors.grey[900]),
            ),
            centerTitle: true,
    ),
    body: Column(children: [],)
    );
   }
}

