import 'package:flutter/material.dart';

class Price extends StatelessWidget {
  final double price;
  final double? fontSize;
  final Color? color;
  const Price({super.key, required this.price, this.fontSize, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('N',
            style: TextStyle(
                color: color == null ? Colors.grey[900] : color,
                fontWeight:
                    fontSize == null ? FontWeight.bold : FontWeight.normal,
                decoration: TextDecoration.lineThrough)),
        Text('$price',
            style: TextStyle(
              color: color == null ? Colors.grey[900] : color,
              fontSize: fontSize == null ? 18 : fontSize,
              fontWeight:
                  fontSize == null ? FontWeight.bold : FontWeight.normal,
            ))
      ],
    );
  }
}
