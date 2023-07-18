import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//pls find a better name
class SavedEmpty extends StatelessWidget {
  const SavedEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 4, child: Image.asset('lib/assets/wishlist_empty.png')),
        Expanded(
          child: Column(
            children: [
              Text('Discover your perfect picks',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 8,
              ),
              /*Text(
                'Find your perfect picks and give them some 💜. Simply double-tap on a product card to save it to your wishlist and keep track of it in style.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.5, color: Colors.grey[600]),
              )*/
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: GoogleFonts.openSans(fontSize: 14, color: Colors.grey[600]),
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              'Find your perfect picks and give them some 💜! Simply '),
                      TextSpan(
                          text: 'double-tap',
                          style: TextStyle(color:Colors.deepPurple[600],fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                              ' on a product card\'s image to save it to your wishlist and keep track of it in style.'),
                    ]),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
