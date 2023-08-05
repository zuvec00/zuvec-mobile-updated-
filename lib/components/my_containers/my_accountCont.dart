import 'package:flutter/material.dart';

class MyAccountCont extends StatelessWidget {
  final int index;
  final String accountText;
  final String routeName;
  final IconData icon;

  MyAccountCont({
    super.key,
    required this.accountText,
    required this.index,
    required this.routeName,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.grey[600]),
                  const SizedBox(width: 10),
                  Text(accountText),
                ],
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, routeName);
                  },
                  icon: Icon(Icons.arrow_forward_ios_rounded,
                      size: 20, color: Colors.grey[600]))
            ],
          )),
    );
  }
}
