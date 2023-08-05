import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/routes/donation_confirmed.dart';

import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
//import 'package:mailer/mailer.dart';
//import 'package:mailer/smtp_server/gmail.dart';

import 'database_service.dart';

class DonationPayment {
  final BuildContext context;

  final String publicKey;
  final String name;
  final String? userEmail;
  final int price;
  final bool isAnonymous;

  DonationPayment(this.context,
      {required this.name,
      required this.isAnonymous,
      required this.publicKey,
      this.userEmail,
      required this.price});

  //get current user ID
  String _getCurrentUserId() {
    final currentUser = FirebaseAuth.instance.currentUser!;
    String userID = currentUser.uid;
    return userID;
  }

  PaystackPlugin plugin = PaystackPlugin();

  //method to initialize plguin
  Future initializePlguin() async {
    await plugin.initialize(publicKey: publicKey);
  }

  //user email
  String _getUserEmail() {
    final user = FirebaseAuth.instance.currentUser!;
    return user.email!;
  }

  //sendMail
 /* sendMail() async {
    String username = 'princeibekwe48@gmail.com';
    String password = 'Hearty.20102004';

    final setpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username)
      ..recipients.add('princeibekwe48@gmail.com')
      ..subject = 'blah hblas';

    try {
      final sendReport = await send(message, setpServer);
      print('messageSent');
    } on MailerException catch (error) {
      print('message not sent: ${error.toString()}');
    }
  }*/

  //refernce
  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = "iOS";
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  //getUI
  PaymentCard _getCardUI() {
    return PaymentCard(number: '', cvc: '', expiryMonth: 0, expiryYear: 0);
  }

  //charge and make payment
  chargeAndMakePayment() async {
    initializePlguin().then((_) async {
      print('charge card');
      Charge charge = Charge()
        ..amount = price * 100
        ..email = _getUserEmail()
        ..reference = _getReference()
        ..card = _getCardUI();

      CheckoutResponse response = await plugin.checkout(context,
          charge: charge,
          method: CheckoutMethod.card,
          fullscreen: true,
          logo: Image.asset(
            'lib/assets/paystack_logo.png',
            width: 30,
          ));

      print('Response $response');

      if (response.status == true) {
        print('Transaction successful');

        DatabaseService(uID: _getCurrentUserId())
            .addDonationDetails(_getCurrentUserId(), name, price, isAnonymous);

        // return to the payment outro screen
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DonationConfirmed(),
            ));
      } else {
        print('Transaction failed:${response.message}');
      }
    });
  }
}
