import 'package:firebase_practice/bottombar.dart';
import 'package:flutter/material.dart';

//pls find a better name
class CartEmpty extends StatelessWidget {
  const CartEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Image.asset('lib/assets/emptyCart.png')),
        Text('Your cart is empty!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(
          height: 8,
        ),
        Text(
            'Your cart is looking a little empty, let\'s go shopping and fill it up with some great items!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => MyBottomBar())));
          },
          child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'START SHOPPING',
                style: TextStyle(color: Colors.grey[100]),
              )),
        ),
      ],
    );
  }
}
