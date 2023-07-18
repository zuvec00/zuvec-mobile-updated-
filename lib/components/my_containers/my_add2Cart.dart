import 'package:flutter/material.dart';

class MyAddToCartButton extends StatelessWidget {
  const MyAddToCartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding:
            const EdgeInsets.only(left: 16, right: 20, top: 12, bottom: 12),
        decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 2,
                  offset: Offset(1, 1),
                  spreadRadius: 1)
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.shopping_bag_outlined, size: 20, color: Colors.white),
            SizedBox(
              width: 8,
            ),
            Text('Add to cart',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))
          ],
        ));
  }
}

class MyAddToCartButton2 extends StatelessWidget {
  const MyAddToCartButton2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(7.5),
        ),
        child: Row(
          children: const [
            Icon(
              Icons.shopping_bag_outlined,
              size: 20,
              color: Colors.white,
            ),
            SizedBox(width: 4),
            /*Text('Add to cart',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))*/
          ],
        ));
  }
}
