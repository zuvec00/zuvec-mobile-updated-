import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/components/my_customWidgets/saved_empty.dart';
import 'package:firebase_practice/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

import '../components/my_containers/my_deleteAll.dart';
import '../components/my_containers/my_savedItemsContainers.dart';
import '../provider/model.dart';
import '../routes/cart_page.dart';

class Saved extends StatefulWidget {
  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  void initState() {
    super.initState();
    Provider.of<Model>(context, listen: false).refreshSavedItems();
  }

  Future<void> _handleRefresh() async {
    return await Future.delayed(Duration(seconds: 2));
  }

  String _getCurrentUserId() {
    final currentUser = FirebaseAuth.instance.currentUser!;
    String userID = currentUser.uid;
    return userID;
  }

  @override
  Widget build(BuildContext context) {
    final DocumentReference cartDocumentRef = FirebaseFirestore.instance
        .collection('usersCartProducts')
        .doc(_getCurrentUserId());
    final CollectionReference cartSubCollection =
        cartDocumentRef.collection('user_cart_item');

    final DocumentReference wishlistDocumentReference = FirebaseFirestore
        .instance
        .collection('usersWishlistProducts')
        .doc(_getCurrentUserId());
    final CollectionReference wishlistCollection =
        wishlistDocumentReference.collection('user_wishlist_item');

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

    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey[100],
          leading: Text(''),
          title: Text(
            'W I S H L I S T',
            style: GoogleFonts.quicksand(color: Colors.grey[900]),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Consumer<Model>(
                builder: (context, value, child) => Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => Cart())));
                        },
                        icon: Icon(Icons.shopping_bag_outlined,
                            color: Colors.grey[900])),
                    Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[600],
                          shape: BoxShape.circle,
                        ),
                        child: FutureBuilder<int>(
                          future: DatabaseService(uID: _getCurrentUserId())
                              .getTotalNoOfCartItems(cartSubCollection),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text('...',
                                  style: TextStyle(
                                      color: Colors.grey[100], fontSize: 13.5));
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Text(
                                '${snapshot.data}',
                                style: TextStyle(color: Colors.grey[100]),
                              );
                            }
                          },
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
          ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Consumer<Model>(
          builder: (context, value, child) => value.userSavedItems.length == 0
              // if saved section is empty =>
              ? SavedEmpty()
              //else =>
              : Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MyRemoveAllContainer(),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: StreamBuilder(
                      stream: wishlistCollection.snapshots(),
                      builder: (context, streamSnapshot) {
                        if (streamSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                                color: Colors.deepPurple[600]),
                          );
                        } else if (streamSnapshot.hasData) {
                          int documentLength =
                              streamSnapshot.data!.docs.length;
                          if (documentLength == 0) {
                            return SavedEmpty();
                          }
                          return SizedBox.expand(
                            child: ListView.builder(
                                itemCount: streamSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot documentSnapshot =
                                      streamSnapshot.data!.docs[index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
                                    child: MySavedItems(
                                      backgroundColor: getRandomColor(),
                                        productID:
                                            documentSnapshot['Product ID'],
                                        productImagePath:
                                            documentSnapshot['Product image'],
                                        productName:
                                            documentSnapshot['Product name'],
                                        productPrice:
                                            documentSnapshot['Product price']
                                                .toDouble(),
                                        productSize: documentSnapshot[
                                            'Product variant']),
                                  );
                                }),
                          );
                        }
                        return Center(child: Text('An error occured'));
                      },
                    ),
                  )
                ]),
        ),
      ),
    );
  }
}
