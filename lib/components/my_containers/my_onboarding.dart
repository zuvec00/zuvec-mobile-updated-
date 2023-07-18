import 'package:flutter/material.dart';

class OnBoardingContainer extends StatelessWidget {
  final String onBoardingImage;
  final String onBoardingTitle;
  final String onBoardingContent;
  const OnBoardingContainer(
      {super.key,
      required this.onBoardingImage,
      required this.onBoardingTitle,
      required this.onBoardingContent});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Expanded(
          flex: 2,
          child: Image.asset(onBoardingImage),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Text(
          onBoardingTitle,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(onBoardingContent,textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 13.5, color: Colors.grey[600])),
        const SizedBox(height: 35,)
          ],
        )
      ],
    ));
  }
}
