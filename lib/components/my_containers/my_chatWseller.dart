import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MyChatWithSellerButton extends StatelessWidget {
  final String productName;
  final String productID;
  final String productVariant;
  final int quantity;

  const MyChatWithSellerButton(
      {super.key,
      required this.productName,
      required this.productID,
      required this.productVariant,
      required this.quantity});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        launchUrl(Uri.parse(
            'whatsapp://send?phone=+2348160287793&text=Hello, I\'m interested in buying the product "$productName" (Product ID: $productID). I\'m looking for the "$productVariant" variant and a quantity of $quantity.'));
      },
      //radius: 25,
      splashColor: Colors.grey,
      child: Row(
        children: [
          Icon(FluentSystemIcons.ic_fluent_chat_filled,
              size: 18, color: Colors.deepPurple[600]),
          const SizedBox(
            width: 8,
          ),
          Text('Chat with seller',
              style: TextStyle(
                fontSize: 14,
                color: Colors.deepPurple[600],
                fontWeight: FontWeight.bold,
              ))
        ],
      ),
    );
  }
}
