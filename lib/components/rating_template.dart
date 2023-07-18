import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';

class RatingTemplate extends StatelessWidget {
  final double rating;
  final String totalRaters;
  const RatingTemplate(
      {super.key, required this.rating, required this.totalRaters});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Icon(FluentSystemIcons.ic_fluent_star_half_filled,
          color: Colors.amber, size: 20),
      const SizedBox(
        width: 10,
      ),
       Text(
        '$rating',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        width: 10,
      ),
      Text(totalRaters,
          style: TextStyle(fontSize: 14, color: Colors.grey[600])),
    ]);
  }
}
