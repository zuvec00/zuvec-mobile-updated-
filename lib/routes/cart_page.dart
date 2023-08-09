import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/bottombar.dart';
import 'package:firebase_practice/components/my_customWidgets/cart_empty.dart';
import 'package:firebase_practice/routes/shippingAddress/shippingAddress_page.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/my_containers/my_cartItemsCont.dart';
import '../components/my_containers/my_deleteAll.dart';
import '../components/my_price.dart';
import '../pages/login_or_register.dart';
import '../provider/model.dart';
import '../services/database_service.dart';

class Cart extends StatefulWidget {
  Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();

    //refresh items saved in cart
    Provider.of<Model>(context, listen: false).refreshCartItems();
    //refresh the total number of items in cart
    Provider.of<Model>(context, listen: false).updateCartItemsLength();
  }

  Future<void> _handleRefresh() async {
    return await Future.delayed(Duration(seconds: 2));
  }

  String _getCurrentUserId() {
    final User currentUser = FirebaseAuth.instance.currentUser!;
    String userID = currentUser.uid;
    return userID;
  }

  bool isUserAnonymous() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null && user.isAnonymous;
  }

  void showSignUpPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sign Up Required', style: GoogleFonts.quicksand()),
          content: Text('Please sign up to complete the action.',
              style: GoogleFonts.quicksand()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog.
                Navigator.pop(context);
              },
              child: Text('Cancel', style: GoogleFonts.quicksand()),
            ),
            TextButton(
              onPressed: () {
                // Navigate to the sign-up page.
                // Implement your navigation logic here.
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginOrRegisterPage())).then((_) => Navigator.pop(context),);
              },
              child: Text('Sign Up', style: GoogleFonts.quicksand()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final DocumentReference cartDocumentRef = FirebaseFirestore.instance
        .collection('usersCartProducts')
        .doc(_getCurrentUserId());
    final CollectionReference cartSubCollection =
        cartDocumentRef.collection('user_cart_item');

    Color getRandomColor() {
      final Random random = Random();
      final List<Color> colors = [
        Color(0xFFC8E6C9), // light green
        Color(0xFFFFF9C4), // pale yellow
        Color(0xFFFFE0B2), //light peach
        Color(0xFFFFCDD2), //soft pink
        Color(0xFFE1BEE7), // lilac
        Color(0xFFB2EBF2), //light aqua
      ];
      return colors[random.nextInt(colors.length)];
    }

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: ((context) => MyBottomBar()))),
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.grey[900])),
        title: Text('Cart Details',
            style: GoogleFonts.quicksand(color: Colors.grey[900])),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.5),
          child: Consumer<Model>(
              builder: (context, value, child) => value.userCartItems.length ==
                      0
                  ? CartEmpty()
                  : Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('CART SUMMARY',
                              style: TextStyle(
                                  color: Colors.grey[
                                      600] /*fontSize: 18, fontWeight: FontWeight.bold*/)),
                          MyRemoveAllContainer2(),
                        ],
                      ),
                      Expanded(
                          flex: 5,
                          child: StreamBuilder(
                              stream: cartSubCollection.snapshots(),
                              builder: (context, streamSnapshot) {
                                if (streamSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.deepPurple[600]),
                                  );
                                } else if (streamSnapshot.hasData) {
                                  return SizedBox.expand(
                                    child: ListView.builder(
                                        itemCount:
                                            streamSnapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          final DocumentSnapshot
                                              documentSnapshot =
                                              streamSnapshot.data!.docs[index];

                                          return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 7.50),
                                              child: MyCartItems(
                                                backgroundColor:
                                                    getRandomColor(),
                                                productImagePath:
                                                    documentSnapshot[
                                                        'Product image'],
                                                productName: documentSnapshot[
                                                    'Product name'],
                                                productPrice: documentSnapshot[
                                                    'Product price'],
                                                itemQuantity: documentSnapshot[
                                                    'Product quantity'],
                                                productSize: documentSnapshot[
                                                    'Product variant'],
                                                productID: documentSnapshot[
                                                    'Product ID'],
                                                index: index,
                                              ));
                                        }),
                                  );
                                }
                                return Center(child: Text('An error occured'));
                              })),
                      Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Subtotal',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[600])),
                                        FutureBuilder<double>(
                                          future: DatabaseService(
                                                  uID: _getCurrentUserId())
                                              .getTotalPrice(cartSubCollection),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Text('Loading...',
                                                  style: TextStyle(
                                                      fontSize: 13.5));
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else {
                                              double totalPrice =
                                                  snapshot.data ?? 0.0;
                                              return Price(
                                                price: totalPrice,
                                                fontSize: 14,
                                              );
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Shipping Cost',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[600])),
                                        Text('Not included yet.',
                                            style: TextStyle(fontSize: 14))
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Total',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[600])),
                                        FutureBuilder<double>(
                                          future: DatabaseService(
                                                  uID: _getCurrentUserId())
                                              .getTotalPrice(cartSubCollection),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Text('Loading...',
                                                  style: TextStyle(
                                                      fontSize: 13.5));
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else {
                                              double totalPrice =
                                                  snapshot.data ?? 0.0;
                                              return Price(
                                                price: totalPrice,
                                                fontSize: 14,
                                              );
                                            }
                                          },
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ))
                            ],
                          ))
                    ]))),
      bottomNavigationBar: Consumer<Model>(
        builder: (context, value, child) => value.userCartItems.length == 0
            ? Text('')
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: BottomAppBar(
                    elevation: 0,
                    color: Colors.transparent,
                    child: Row(children: [
                      InkWell(
                        radius: 25,
                        splashColor: Colors.grey,
                        onTap: () {
                          launchUrl(Uri.parse('tel://09125613618'));
                        },
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.grey[900]!,
                                )),
                            child: Icon(
                                FluentSystemIcons.ic_fluent_phone_filled,
                                color: Colors.grey[900])),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (isUserAnonymous()) {
                              showSignUpPrompt(context);
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          ShippingAddressPage())));
                            }
                          },
                          child: Container(
                              alignment: Alignment.center,
                              //width: MediaQuery.of(context).size.width,
                              height: 45,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey[900],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('CHECKOUT ',
                                      style:
                                          TextStyle(color: Colors.grey[100])),
                                  Text('(',
                                      style:
                                          TextStyle(color: Colors.grey[100])),
                                  FutureBuilder<double>(
                                    future: DatabaseService(
                                            uID: _getCurrentUserId())
                                        .getTotalPrice(cartSubCollection),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Text('Loading...',
                                            style: TextStyle(fontSize: 13.5));
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        double totalPrice =
                                            snapshot.data ?? 0.0;
                                        return Price(
                                            price: totalPrice,
                                            fontSize: 14,
                                            color: Colors.grey[100]);
                                      }
                                    },
                                  ),
                                  Text(')',
                                      style: TextStyle(color: Colors.grey[100]))
                                ],
                              )),
                        ),
                      ),
                    ])),
              ),
      ),
    );
  }
}
