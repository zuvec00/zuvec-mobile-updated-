import 'package:firebase_practice/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bottombar.dart';
import '../../screens/home.dart';

class MyFilterPage extends StatefulWidget {
  MyFilterPage({super.key});

  @override
  State<MyFilterPage> createState() => _MyFilterPageState();
}

class _MyFilterPageState extends State<MyFilterPage> {
  final Home home = Home();
  List<String> categories = [
    'Ready 2 Wear',
    'Ankara Materials',
    'Watches',
    'Footwear'
  ];

  String selectedCategory = 'Ready 2 Wear';

  void handleCategorySelection(String category) {
    setState(() {
      selectedCategory = category;
      print('selectd catego: $selectedCategory');
    });
  }

  void buttonHandler() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MyBottomBar(category: selectedCategory);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Scaffold(
            backgroundColor: Colors.grey[100],
            body: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          const Text('Filter by Category',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          // const SizedBox(height: 4,),
                          Text(
                              'Narrow down your search by selecting a category',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[600])),
                          const SizedBox(height: 15),
                          const Text('Search Products In?', style: TextStyle()),
                          Column(
                              children: categories.map((category) {
                            return RadioListTile(
                                activeColor: Colors.deepPurple[600],
                                title: Text(category,
                                    style: GoogleFonts.quicksand()),
                                value: category,
                                groupValue: selectedCategory,
                                onChanged: (value) {
                                  handleCategorySelection(value!);
                                  print('category selected: $value');
                                });
                          }).toList()),
                          MyButton(text: 'Submit', onTap: buttonHandler),
                          const SizedBox(height: 15),
                        ],
                      ),
                    )
                  ],
                ))));
  }
}
