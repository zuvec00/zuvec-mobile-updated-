import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final double? paddingHeight;
  final double? paddingWidth;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.paddingHeight,
    this.paddingWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: paddingHeight == null ? 25.0 : 10.0,
            vertical: paddingWidth == null ? 0.0 : 20), //was 25
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(width: 1.5, color: Colors.grey[900]!)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide:
                    BorderSide(width: 1.5, color: Colors.deepPurple[600]!)),
            labelText: hintText,
            labelStyle: GoogleFonts.quicksand(fontSize: 14),
            hintStyle: GoogleFonts.quicksand(fontSize: 14, color: Color(0xFF757575)),
          ),
        ));
  }
}
