// ignore_for_file: avoid_single_cascade_in_expression_statements, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/routes/cart_page.dart';
import 'package:firebase_practice/routes/payment_page.dart';
import 'package:firebase_practice/routes/shippingAddress/addNewAddress_page.dart';
import 'package:fluentui_icons/fluentui_icons.dart';

import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../components/my_containers/my_shippingAddressContainer.dart';
import '../../components/my_price.dart';
import '../../provider/model.dart';
import '../../services/database_service.dart';

class ShippingAddressPage extends StatefulWidget {
  const ShippingAddressPage({super.key});

  @override
  State<ShippingAddressPage> createState() => _ShippingAddressPageState();
}

class _ShippingAddressPageState extends State<ShippingAddressPage> {
  double shippingFee = 0.00;
  bool storePickUp = false;
  bool boolVerifyShippingAddress = true;

  void storePickUpHandler() {
    setState(() {
      storePickUp = !storePickUp;
    });
    if (storePickUp) {
      shippingFee = 0.0;
    } else {
      shippingFee = 2500.00;
    }
  }

  String _getCurrentUserId() {
    final User currentUser = FirebaseAuth.instance.currentUser!;
    String userID = currentUser.uid;
    return userID;
  }

  void initState() {
    super.initState();
    //refresh user address fields
    Provider.of<Model>(context, listen: false).refreshShippingAddress();
  }

  //text controllers

  @override
  Widget build(BuildContext context) {
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

    Future<void> setShippingFee() async {
      final shippingFee2 = await DatabaseService(uID: _getCurrentUserId())
          .getShippingFee(addressSubCollection);

      setState(() {
        shippingFee = shippingFee2;
      });
      print('shippingFee:$shippingFee');
    }

    Future<void> verifyShippingAddress() async {
      final verifyAddress = await DatabaseService(uID: _getCurrentUserId())
          .verifyShippingAddress(addressSubCollection);

      setState(() {
        boolVerifyShippingAddress = verifyAddress;
      });
      print('verifyShippingAddress: $boolVerifyShippingAddress');
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: ((context) => Cart()))),
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.grey[900])),
        title: Text('Shipping Address',
            style: GoogleFonts.quicksand(color: Colors.grey[900])),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Store Pickup',
                    style: TextStyle(fontSize: 14.5, color: Colors.grey[900])),
                InkWell(
                  onTap: storePickUpHandler,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        color: storePickUp ? Colors.grey[900] : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: storePickUp ? 0.0 : 1.5,
                            color: storePickUp
                                ? Colors.white
                                : Colors.grey[300]!)),
                    child: Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Divider(
              indent: 10,
              endIndent: 10,
              color: Colors.grey[600],
            ),

            //add new address button
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => AddNewAddressPage())));
              },
              child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FluentSystemIcons.ic_fluent_add_circle_filled,
                        size: 23,
                        color: Colors.grey[100],
                      ),
                      Text('  Add New Address',
                          style: TextStyle(color: Colors.grey[100]))
                    ],
                  )),
            ),
            const SizedBox(height: 15),
            Text('YOUR ADDRESSES', style: TextStyle(color: Colors.grey[600])),
            Expanded(
                flex: 5,
                child: StreamBuilder(
                    stream: addressSubCollection.snapshots(),
                    builder: (context, streamSnapshot) {
                      if (streamSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                              color: Colors.deepPurple[600]),
                        );
                      } else if (streamSnapshot.hasData) {
                        return ListView.builder(
                            itemCount: streamSnapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final currentItem =
                                  streamSnapshot.data!.docs[index];
                              return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 7.50),
                                  child: MyShippingAddressContainer(
                                    index: currentItem['key'],
                                    firstName: currentItem['firstName'],
                                    lastName: currentItem['lastName'],
                                    deliveryAddress:
                                        currentItem['deliveryAddress'],
                                    additionalInfo:
                                        currentItem['additionalInfo'],
                                    region: currentItem['region'],
                                    city: currentItem['city'],
                                    mobilePhoneNo: currentItem['mobilePhoneNo'],
                                    additionalPhoneNo:
                                        currentItem['additionalPhoneNo'],
                                    selected: currentItem['addressSelected'],
                                  ));
                            });
                      }
                      return Center(child: Text('sls:${streamSnapshot.error}'));
                    })),

            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
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
                                future:
                                    DatabaseService(uID: _getCurrentUserId())
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
                                price: shippingFee,
                                fontSize: 14,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[600])),
                              FutureBuilder<double>(
                                future:
                                    DatabaseService(uID: _getCurrentUserId())
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
                                      price: totalPrice + shippingFee,
                                      fontSize: 14,
                                    );
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ))
                  ],
                ))
          ],
        ),
      ),
      bottomNavigationBar: Consumer<Model>(
        builder: (context, value, child) => Padding(
          padding: const EdgeInsets.all(15.0),
          child: BottomAppBar(
              elevation: 0,
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () async {
                  await verifyShippingAddress();

                  if (!storePickUp && !boolVerifyShippingAddress) {
                    Flushbar(
                      flushbarPosition: FlushbarPosition.TOP,
                      backgroundColor: Colors.red[400]!,
                      margin: const EdgeInsets.only(top: 0),
                      duration: const Duration(seconds: 2),
                      icon: const Icon(Icons.error_outline_rounded,
                          color: Colors.white),
                      messageText: Text("Please select one shipping address",
                          style: GoogleFonts.quicksand(color: Colors.white)),
                    )..show(context);
                  } else if (storePickUp && boolVerifyShippingAddress) {
                    Flushbar(
                      flushbarPosition: FlushbarPosition.TOP,
                      backgroundColor: Colors.red[400]!,
                      margin: const EdgeInsets.only(top: 0),
                      duration: const Duration(seconds: 2),
                      icon: const Icon(Icons.error_outline_rounded,
                          color: Colors.white),
                      messageText: Text(
                          "You are only allowed to choose a single shipping address.",
                          style: GoogleFonts.quicksand(color: Colors.white)),
                    )..show(context);
                  } else {
                    await setShippingFee();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => PaymentPage(
                                shippingFee: storePickUp
                                    ? 0.0
                                    : shippingFee /*Provider.of<Model>(context,
                                              listen: false)
                                          .getUserPrefferedAddress(),*/
                                ))));
                  }
                },
                child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 45,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[900],
                    ),
                    child: Text(
                      'PROCEED TO PAYMENT',
                      style: TextStyle(color: Colors.grey[100]),
                    )),
              )),
        ),
      ),
    );
  }
}
