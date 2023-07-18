import 'package:flutter/material.dart';

class ProductCardRedo extends StatelessWidget {
  const ProductCardRedo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(children: [
              Container(
                  height: 130,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(7.5)),
                  child: Image.asset('lib/assets/connect_intro.png')),
            ]),
            const Text(
              'N15000',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Just Testing something with the tab ui',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            )
          ],
        ));
  }
}
