import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_practice/routes/order_confirmed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:provider/provider.dart';

import '../provider/model.dart';
import 'database_service.dart';

class PaystackPayment {
  final BuildContext context;
  final CollectionReference orderSubCollection;
  final CollectionReference addressSubCollection;
  final CollectionReference cartSubCollection;
  final String publicKey;
  final String? userEmail;
  final int price;

  PaystackPayment(this.context,
      {required this.orderSubCollection,
      required this.addressSubCollection,
      required this.cartSubCollection,
      required this.publicKey, this.userEmail, required this.price});

  // get refernce to collection
  final CollectionReference userOrderDetails =
      FirebaseFirestore.instance.collection('userOrderDetails');

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
  sendMail() async {
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
  }

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

        // return to the payment outro screen
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderConfirmed(),
            ));

        DatabaseService(uID: _getCurrentUserId()).addOrderDetails(
            orderSubCollection, addressSubCollection, cartSubCollection);
        //DatabaseService(uID: _getCurrentUserId()).deleteAllCartItems(cartSubCollection);

        //add the order details to the hive local db
        Provider.of<Model>(context, listen: false).addOrderDetails();

        // add the order details to the firebase firestore
        await Provider.of<Model>(context, listen: false)
            .updateUserOrderDetails(userOrderDetails, _getCurrentUserId());

        //clear the hive local db
        Provider.of<Model>(context, listen: false)
            .clearAllOrderDetailsFromList();
      } else {
        print('Transaction failed:${response.message}');
      }
    });
  }
}
