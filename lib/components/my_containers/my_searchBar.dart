import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_icons/fluentui_icons.dart';

class SearchBar extends StatelessWidget {
  final String text;
  SearchBar({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      backgroundColor: Colors.grey[200],
      borderRadius: BorderRadius.circular(15),
      prefixIcon: Icon(FluentSystemIcons.ic_fluent_search_regular,
          size: 26, color: Colors.grey[900]),
      suffixIcon: Icon(FluentSystemIcons.ic_fluent_dismiss_circle_regular),
      placeholder: text,
      placeholderStyle:
          GoogleFonts.quicksand(fontSize: 14, color: Colors.grey[600]),
    );
  }
}
