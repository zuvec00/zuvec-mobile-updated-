// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_practice/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/routes/shippingAddress/shippingAddress_page.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../components/my_price.dart';
import '../provider/model.dart';
import '../services/database_service.dart';
import '../services/payment_service.dart';

class PaymentPage extends StatefulWidget {
  final double shippingFee;
  PaymentPage({super.key, required this.shippingFee});

  static const testPublicKey =
      'pk_test_3e6f22cf045cf34820d3a67c176ba93b5aa3b0a5';
      
  static const livePublicKey =
      'pk_live_e54327c2ae697490c9ad2f009523f33df6f251d0';

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late String discount;
  String couponError = '';

  final List<Map<String, dynamic>> couponDiscount = [];

  //text controllers
  final TextEditingController couponController = TextEditingController();

  //slide_to_act state key
  final GlobalKey<SlideActionState> _key = GlobalKey();

  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('feed');

  Stream<List<DocumentSnapshot>> streamData() {
    return collectionRef.snapshots().map((snapshot) => snapshot.docs);
  }

  void verfiyCouponCode() {
    final item = couponDiscount.firstWhere(
        (element) => element[couponController.text.trim()] != null,
        orElse: () => {});
    if (item != null) {
      print(item);
      setState(() {
        discount = item[couponController.text.trim()];
      });
    } else if (item == {} || item.isEmpty) {
      print('Nothing dey!!!!!!!!!!!!!');
    }
    print('disocunt:$discount');
  }

  void initState() {
    super.initState();
    streamData().listen((data) {
      // do something with the data
      for (int i = 0; i < data.length; i++) {
        couponDiscount.add(data[i]['discount']);
      }
      print(couponDiscount);
    });

    discount = '0.0';
  }

  String _getCurrentUserId() {
    final currentUser = FirebaseAuth.instance.currentUser!;
    String userID = currentUser.uid;
    return userID;
  }

  @override
  Widget build(BuildContext context) {
    final DocumentReference orderDocumentRef = FirebaseFirestore.instance
        .collection('usersOrders')
        .doc(_getCurrentUserId());
    final CollectionReference orderSubCollection =
        orderDocumentRef.collection('user_orders');

    final DocumentReference parentDocRef = FirebaseFirestore.instance
        .collection('usersAddresses')
        .doc(_getCurrentUserId());

    final CollectionReference addressSubCollection =
        parentDocRef.collection('user_address');

    final DocumentReference cartDocumentRef = FirebaseFirestore.instance
        .collection('usersCartProducts')
        .doc(_getCurrentUserId());
    final CollectionReference cartSubCollection =
        cartDocumentRef.collection('user_cart_item');

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => ShippingAddressPage()))),
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.grey[900])),
        title: Text('Payment',
            style: GoogleFonts.quicksand(color: Colors.grey[900])),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Image.asset('lib/assets/paystack.png'),
            const SizedBox(
              height: 10,
            ),
            Text('Pay with credit/debit cards',
                style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 20),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '   USE A COUPON',
                    style:
                        TextStyle(fontSize: 13, color: Colors.deepPurple[600]),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: LayoutBuilder(builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return SizedBox(
                              width: constraints.maxWidth * 0.65,
                              child: MyTextField(
                                controller: couponController,
                                hintText: 'Enter Coupon Code',
                                obscureText: false,
                                paddingHeight: 0,
                                paddingWidth: 0,
                              ));
                        }),
                      ),
                      GestureDetector(
                        onTap: verfiyCouponCode,
                        child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            height: 62,
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text('Apply',
                                style: TextStyle(color: Colors.grey[100]))),
                      )
                    ],
                  ),
                  if (couponError != '')
                    Text(couponError,
                        style: TextStyle(fontSize: 13, color: Colors.red))
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Divider(
                    thickness: 1,
                  ),
                  Expanded(
                      child: Consumer<Model>(
                    builder: (context, value, child) => ListView(
                      children: [
                        const Text('Order Info',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[600])),
                            FutureBuilder<double>(
                              future: DatabaseService(uID: _getCurrentUserId())
                                  .getTotalPrice(cartSubCollection),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text('Loading...',
                                      style: TextStyle(fontSize: 14));
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  double totalPrice = snapshot.data ?? 0.0;
                                  return Price(
                                    price: totalPrice,
                                    fontSize: 14,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Shipping Cost',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[600])),
                            Price(
                              price: widget.shippingFee,
                              fontSize: 14,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Discount',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[600])),
                            Row(
                              children: [
                                Text(
                                  '-',
                                  style: TextStyle(color: Colors.green),
                                ),
                                Price(
                                  color: Colors.green,
                                  //dont think about it too mcuh
                                  price: double.parse(discount) == 0.0
                                      ? 0
                                      : double.parse(discount),
                                  fontSize: 14,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[600])),
                            FutureBuilder<double>(
                              future: DatabaseService(uID: _getCurrentUserId())
                                  .getTotalPrice(cartSubCollection),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text('Loading...',
                                      style: TextStyle(fontSize: 14));
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  double totalPrice = snapshot.data ?? 0.0;
                                  return Price(
                                      price: double.parse(discount) == 0
                                          ? (totalPrice + widget.shippingFee)
                                          : (totalPrice + widget.shippingFee) -
                                              double.parse(discount));
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SlideAction(
                          key: _key,
                          onSubmit: () async {
                            double totalPrice =
                                await DatabaseService(uID: _getCurrentUserId())
                                    .getTotalPrice(cartSubCollection);
                            PaystackPayment(context,
                                    publicKey: PaymentPage.livePublicKey,
                                    price: (totalPrice + widget.shippingFee)
                                        .toInt(),
                                    addressSubCollection: addressSubCollection,
                                    orderSubCollection: orderSubCollection,
                                    cartSubCollection: cartSubCollection)
                                .chargeAndMakePayment();
                            Future.delayed(Duration(milliseconds: 1000),
                                () => _key.currentState!.reset());
                          },
                          submittedIcon: Icon(Icons.check_rounded,
                              size: 22, color: Colors.grey[50]),
                          text: '    S L I D E  T O  P A Y',
                          textStyle: GoogleFonts.quicksand(
                              fontSize: 14, color: Colors.grey[100]),
                          height: 55,
                          elevation: 0,
                          borderRadius: 10,
                          outerColor: Color.fromARGB(255, 46, 46, 46),
                          innerColor: Color.fromARGB(255, 33, 33, 33),
                          sliderButtonIcon: Icon(
                              FluentSystemIcons.ic_fluent_payment_filled,
                              size: 22,
                              color: Colors.grey[50]),
                          sliderButtonIconPadding: 12,
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
      /*bottomNavigationBar: Consumer<Model>(
        builder: (context, value, child) => Padding(
          padding: const EdgeInsets.all(15.0),
          child: BottomAppBar(
              elevation: 0,
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {
                  PaystackPayment(context,
                          publicKey: publicKey,
                          userEmail: 'princeibekwe48@gmail.com',
                          price: value.getTotalPrice().toInt())
                      .chargeAndMakePayment();
                },
                child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 45,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.deepPurple[600],
                    ),
                    child: Text(
                      'CONFIRM PAYMENT',
                      style: TextStyle(color: Colors.grey[100]),
                    )),
              )),
        ),
      ),*/
    );
  }
}
