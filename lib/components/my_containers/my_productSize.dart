import 'package:flutter/material.dart';

class MyProductSizeCont extends StatelessWidget {
  final String size;
  final bool isSelected;
  final VoidCallback onSelected;
  const MyProductSizeCont(
      {super.key,
      required this.size,
      required this.isSelected,
      required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelected,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal:25,vertical:2.5),
          
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey[900] : Colors.grey[100],
            borderRadius: BorderRadius.circular(30),
            /*border: Border.all(
                color: isSelected ? Colors.grey[100]! : Colors.grey[600]!,
                width: isSelected ? 0 : 1.5),*/
            
          ),
          child: Center(
              child: Text(size,
                  style: TextStyle(
                      color: isSelected ? Colors.grey[100] : Colors.grey[900],
                      fontSize: 14)))),
    );
  }
}
