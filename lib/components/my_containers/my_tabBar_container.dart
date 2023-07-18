import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTabBarContainer extends StatelessWidget {
  final String tabName;
  final IconData icon;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final bool textDecoration;
  const MyTabBarContainer(
      {super.key,
      required this.icon,
      required this.tabName,
      required this.color,
      required this.textColor,
      required this.borderColor, required this.textDecoration});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8,vertical:5.5),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(25),
            ),
        child: Row(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            /* Icon(
              icon,
              color: textColor,
              size: 22,
            ),*/
            
            Text(tabName,
                style: GoogleFonts.quicksand(
                    fontSize: 14,
                    fontWeight: textDecoration?FontWeight.bold:FontWeight.normal,
                    color: textColor)),
          ],
        ));
  }
}
