import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MyRatingBar extends StatelessWidget {
  const MyRatingBar({super.key});

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      
      initialRating: 4.5,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemSize: 17,
      itemPadding: const EdgeInsets.symmetric(horizontal: 2),
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {print(rating);},
    );
  }
}
