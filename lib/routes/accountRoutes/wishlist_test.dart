import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/components/my_containers/my_savedItemsContainers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../components/my_containers/my_deleteAll.dart';
import '../../components/my_customWidgets/saved_empty.dart';
import '../../provider/model.dart';
import '../cart_page.dart';

class WishlistTest extends StatelessWidget {
  const WishlistTest({super.key});

  String _getCurrentUserId() {
    final User currentUser = FirebaseAuth.instance.currentUser!;
    String userID = currentUser.uid;
    return userID;
  }

  @override
  Widget build(BuildContext context) {
    final DocumentReference wishlistDocumentReference = FirebaseFirestore
        .instance
        .collection('usersWishlistProducts')
        .doc(_getCurrentUserId());
    final CollectionReference wishlistCollection =
        wishlistDocumentReference.collection('user_wishlist_item');

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
                          child: Text(
                            '${value.cartLength}',
                            style: TextStyle(color: Colors.grey[100]),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ]),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal:15.0),
          child: Column(
            children: [
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
                    int documentLength = streamSnapshot.data!.docs.length;
                    if(documentLength==0){
                      return SavedEmpty();
                    }
                    return SizedBox.expand(
                      child: ListView.builder(
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                                streamSnapshot.data!.docs[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom:15.0),
                              child: MySavedItems(
                                backgroundColor: Colors.grey[200]!,
                                  productID: documentSnapshot['Product ID'],
                                  productImagePath:
                                      documentSnapshot['Product image'],
                                  productName: documentSnapshot['Product name'],
                                  productPrice:
                                      documentSnapshot['Product price'].toDouble(),
                                  productSize: documentSnapshot['Product variant']),
                            );
                          }),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
