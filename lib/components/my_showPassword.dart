import 'package:flutter/material.dart';

class ShowPassword extends StatelessWidget {
  final Widget child;
  final bool obscureText;
  const ShowPassword(
      {super.key, required this.child, required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        child,
        Positioned(
          right: 35,
          child: Icon(
              obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.deepPurple[600]),
        )
      ],
    );
  }
}
