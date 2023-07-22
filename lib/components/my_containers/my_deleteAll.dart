import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/bottombar.dart';
import 'package:firebase_practice/screens/saved.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/model.dart';
import '../../routes/cart_page.dart';
import '../../services/database_service.dart';

// F O R  T H E  S A V E D  S E C T I O N
class MyRemoveAllContainer extends StatelessWidget {
  String _getCurrentUserId() {
    final currentUser = FirebaseAuth.instance.currentUser!;
    String userID = currentUser.uid;
    return userID;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final DocumentReference wishlistDocumentReference = FirebaseFirestore
        .instance
        .collection('usersWishlistProducts')
        .doc(_getCurrentUserId());
    final CollectionReference wishlistCollection =
        wishlistDocumentReference.collection('user_wishlist_item');
    final CollectionReference ready2wearCollection =
        FirebaseFirestore.instance.collection('watchesCatalaog');
    final CollectionReference ankaraMaterialCollection =
        FirebaseFirestore.instance.collection('luchiMaterialsCatalog');
    final CollectionReference watchesCollection =
        FirebaseFirestore.instance.collection('watchesCatalogFr');
    final CollectionReference footwearCollection =
        FirebaseFirestore.instance.collection('footwearCatalog');

    return GestureDetector(
        onTap: () async {
          showDialog(
              context: context,
              builder: (context) {
                return Center(
                    child: CircularProgressIndicator(
                        color: Colors.deepPurple[600]));
              });
          DatabaseService(uID: _getCurrentUserId())
              .deleteAllWishlistItems(wishlistCollection);
          Provider.of<Model>(context, listen: false).removeAllSavedItems();
          await DatabaseService(uID: _getCurrentUserId())
              .updateAllProductSavedStatusToFalse(ready2wearCollection);
          await DatabaseService(uID: _getCurrentUserId())
              .updateAllProductSavedStatusToFalse(ankaraMaterialCollection);
          await DatabaseService(uID: _getCurrentUserId())
              .updateAllProductSavedStatusToFalse(watchesCollection);
          await DatabaseService(uID: _getCurrentUserId())
              .updateAllProductSavedStatusToFalse(footwearCollection);

          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            backgroundColor: Colors.red[400]!,
            margin: const EdgeInsets.only(top: 0),
            duration: Duration(seconds: 2),
            icon: Icon(Icons.check_box_rounded, color: Colors.white),
            messageText: Text("All Items successufully deleted.",
                style: GoogleFonts.openSans(color: Colors.white)),
          )..show(context).then((value) => Navigator.pop(context)).then((_) =>
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: ((context) => MyBottomBar()))));
        },
        child: Container(
            //width: size.width * 0.35,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(7.5),
            ),
            child: Row(
              children: const [
                Icon(
                  FluentSystemIcons.ic_fluent_delete_regular,
                  size: 20,
                  color: Colors.white,
                ),
                SizedBox(width: 4),
                Text('Remove All',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))
              ],
            )));
  }
}

// F O R  T H E  C A R T  S E C T I O N
class MyRemoveAllContainer2 extends StatelessWidget {
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
    final size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          DatabaseService(uID: _getCurrentUserId())
              .deleteAllCartItems(cartSubCollection);
          Provider.of<Model>(context, listen: false).removeAllCartItems();

          //notifies user
          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            backgroundColor: Colors.red[400]!,
            margin: const EdgeInsets.only(top: 0),
            duration: Duration(seconds: 2),
            icon: Icon(Icons.check_box_rounded, color: Colors.white),
            messageText: Text("All Items successfully deleted.",
                style: GoogleFonts.openSans(color: Colors.white)),
          )..show(context).then((_) => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: ((context) => Cart()))));
        },
        child: Container(
            padding:
                const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(7.5),
            ),
            child: Row(
              children: const [
                Icon(
                  FluentSystemIcons.ic_fluent_delete_regular,
                  size: 20,
                  color: Colors.white,
                ),
                SizedBox(width: 4),
                Text('Remove All',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))
              ],
            )));
  }
}
