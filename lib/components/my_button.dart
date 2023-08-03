
import 'package:flutter/material.dart';

//SIGN IN/ SIGN UP

class MyButton extends StatelessWidget {
  String text;
  double? paddingWidth;
  final Function()? onTap;

  MyButton(
      {super.key, required this.text, this.paddingWidth, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(
            horizontal: paddingWidth == null ? 25 : paddingWidth!),
        decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 2,
                offset: Offset(1, 1),
                spreadRadius: 1,
              )
            ]),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
