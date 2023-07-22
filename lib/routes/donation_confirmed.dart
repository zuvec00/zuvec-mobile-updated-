import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../bottombar.dart';

class DonationConfirmed extends StatefulWidget {
  const DonationConfirmed({super.key});

  @override
  State<DonationConfirmed> createState() => _DonationConfirmedState();
}

class _DonationConfirmedState extends State<DonationConfirmed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Lottie.asset(
                  'lib/assets/order.json',
                ),
              ),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                    Column(
                      children: [
                        const Text('Donation Success🎉',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(
                            "Thank you for your donation! Your support drives our progress. Stay tuned for updates on our app's enhancements!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            )),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => MyBottomBar())));
                      },
                      child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'CONTINUE SHOPPING',
                            style: TextStyle(color: Colors.grey[100]),
                          )),
                    ),
                    const SizedBox(height: 15),
                  ])),
            ],
          ),
        ));
  }
}
