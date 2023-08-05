import 'package:firebase_practice/components/my_containers/my_productSize.dart';
import 'package:firebase_practice/components/my_textfield.dart';
import 'package:firebase_practice/services/donation_service.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../../bottombar.dart';

class SupportDeveloper extends StatefulWidget {
  SupportDeveloper({super.key});

  static const testPublicKey =
      'pk_test_3e6f22cf045cf34820d3a67c176ba93b5aa3b0a5';

  static const livePublicKey =
      'pk_live_e54327c2ae697490c9ad2f009523f33df6f251d0';

  @override
  State<SupportDeveloper> createState() => _SupportDeveloperState();
}

class _SupportDeveloperState extends State<SupportDeveloper> {
  final GlobalKey<SlideActionState> _key = GlobalKey();

  int selectedIndex = 0;
  bool isSwitched = false;
  List<dynamic> donations = [1000, 2000, 5000, 10000, 20000, 'Custom'];

  TextEditingController donatorNameController = TextEditingController();

  TextEditingController customController = TextEditingController();

  void sizeSelectionHandler(int index) {
    print(index);
    setState(() {
      selectedIndex = index;
    });

    print(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController donationAmountController =
        TextEditingController(text: '${donations[selectedIndex]}');
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey[100],
          leading: IconButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyBottomBar())),
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text(
            'D O N A T I O N',
            style: GoogleFonts.quicksand(color: Colors.grey[900]),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Image.asset('lib/assets/donate.png')),
                        Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome to the "Support Developer" page! Your donations empower me to enhance the app, upgrade hardware, and refine skills. Become a backer and shape the app\'s future with us. Thank you for your support!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Text('Choose an amount',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                SizedBox(
                                    height: 90,
                                    child: GridView.builder(
                                      itemCount: 6,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              childAspectRatio: 2.5,
                                              mainAxisSpacing: 5,
                                              crossAxisSpacing: 5,
                                              crossAxisCount: 3),
                                      itemBuilder: (context, index) {
                                        return MyProductSizeCont(
                                          size: index == 5
                                              ? '${donations[index]}'
                                              : 'N${donations[index]}',
                                          isSelected: index == selectedIndex,
                                          onSelected: () =>
                                              sizeSelectionHandler(index),
                                        );
                                      },
                                    )),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Anonymous',
                                      style: TextStyle(
                                          color: isSwitched
                                              ? Colors.deepPurple[600]
                                              : Colors.grey[600],
                                          fontSize: 14),
                                    ),
                                    Switch(
                                      value: isSwitched,
                                      onChanged: (bool newValue) {
                                        setState(() {
                                          isSwitched = newValue;
                                        });
                                      },
                                      activeColor: Colors.deepPurple[600],
                                    )
                                  ],
                                ),
                                isSwitched
                                    ? SizedBox.shrink()
                                    : MyTextField(
                                        controller: donatorNameController,
                                        hintText: 'Donator Name',
                                        obscureText: false),
                                const SizedBox(
                                  height: 20,
                                ),
                                MyTextField(
                                    controller: selectedIndex == 5
                                        ? customController
                                        : donationAmountController,
                                    hintText: 'Donation Amount',
                                    obscureText: false),
                                const SizedBox(
                                  height: 15,
                                ),
                                Expanded(
                                  child: ListView(
                                    children: [
                                      SlideAction(
                                        key: _key,
                                        onSubmit: () async {
                                          DonationPayment(context,
                                                  publicKey: SupportDeveloper
                                                      .livePublicKey,
                                                  name: donatorNameController
                                                      .text,
                                                  price: int.tryParse(
                                                          selectedIndex == 5
                                                              ? customController
                                                                  .text
                                                              : donationAmountController
                                                                  .text) ??
                                                      0,
                                                  isAnonymous: isSwitched)
                                              .chargeAndMakePayment();
                                          Future.delayed(
                                              Duration(milliseconds: 1000),
                                              () => _key.currentState!.reset());
                                        },
                                        submittedIcon: Icon(Icons.check_rounded,
                                            size: 22, color: Colors.grey[50]),
                                        text: '    S L I D E  T O  P A Y',
                                        textStyle: GoogleFonts.quicksand(
                                            fontSize: 14,
                                            color: Colors.grey[100]),
                                        height: 55,
                                        elevation: 0,
                                        borderRadius: 10,
                                        outerColor:
                                            Color.fromARGB(255, 46, 46, 46),
                                        innerColor:
                                            Color.fromARGB(255, 33, 33, 33),
                                        sliderButtonIcon: Icon(
                                            FluentSystemIcons
                                                .ic_fluent_payment_filled,
                                            size: 22,
                                            color: Colors.grey[50]),
                                        sliderButtonIconPadding: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ))
                      ]),
                ))));
  }
}
