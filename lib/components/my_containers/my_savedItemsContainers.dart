import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/provider/model.dart';
import 'package:firebase_practice/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../my_price.dart';
import 'my_add2Cart.dart';

class MySavedItems extends StatelessWidget {
  final String? productID;
  final String productImagePath;
  final String productName;
  final double productPrice;
  final String productSize;
  final int? index;
  final Color backgroundColor;
  const MySavedItems({
    super.key,
    required this.productImagePath,
    required this.productName,
    required this.productPrice,
    required this.productSize,
    required this.backgroundColor,
    this.index,
    this.productID,
  });

  String _getCurrentUserId() {
    final User currentUser = FirebaseAuth.instance.currentUser!;
    String userID = currentUser.uid;
    return userID;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final DocumentReference wishlistDocRef = FirebaseFirestore.instance
        .collection('usersWishlistProducts')
        .doc(_getCurrentUserId());
    final CollectionReference wishlistCollection =
        wishlistDocRef.collection('user_wishlist_item');

    final DocumentReference cartDocRef = FirebaseFirestore.instance
        .collection('usersCartProducts')
        .doc(_getCurrentUserId());

    final CollectionReference cartSubCollection =
        cartDocRef.collection('user_cart_item');

    return Slidable(
      endActionPane: ActionPane(motion: StretchMotion(), children: [
        SlidableAction(
          onPressed: (context) {
            DatabaseService(uID: _getCurrentUserId())
                .deleteWishlistItem(wishlistCollection, productID!);
            //deletes item
            Provider.of<Model>(context, listen: false).removeSavedItem(index!);

            //notifies user
            Flushbar(
              flushbarPosition: FlushbarPosition.TOP,
              backgroundColor: Colors.red[400]!,
              margin: const EdgeInsets.only(top: 0),
              duration: Duration(seconds: 2),
              icon: Icon(Icons.check_box_rounded, color: Colors.white),
              messageText: Text("Item successfully deleted.",
                  style: GoogleFonts.quicksand(color: Colors.white)),
            )..show(context);
          },
          icon: Icons.delete_rounded,
          backgroundColor: Colors.deepPurple.shade600,
          borderRadius: BorderRadius.circular(15),
        )
      ]),
      child: Container(
          padding: const EdgeInsets.all(8),
          // width: size.width,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: backgroundColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(7.5)),
                  child: CachedNetworkImage(
                      imageUrl: productImagePath,
                      placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                                color: Colors.deepPurple[600]),
                          ),
                      errorWidget: (context, url, error) => Icon(
                          Icons.error_outline_rounded,
                          color: Colors.red))),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$productName',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 2),
                    Price(
                      price: productPrice,
                      fontSize: 13,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            children: [
                              Text('variant:${productSize}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey[600])),
                            ],
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              //calls the function to add items to cart

                              DatabaseService(uID: _getCurrentUserId())
                                  .addCartItem(
                                      '${productID}',
                                      productImagePath,
                                      productName,
                                      productPrice.toDouble(),
                                      productSize,
                                      1,
                                      cartSubCollection);

                              Provider.of<Model>(context, listen: false)
                                  .addCartItem({
                                'productImagePath': productImagePath,
                                'productName': productName,
                                'productPrice': productPrice.toDouble(),
                                'productSize': productSize,
                                'productItemQuantity': 1,
                              });

                              //calls the function to update the length of cart
                              Provider.of<Model>(context, listen: false)
                                  .updateCartItemsLength();

                              //notifies user
                              Flushbar(
                                flushbarPosition: FlushbarPosition.TOP,
                                backgroundColor: Colors.green[400]!,
                                margin: const EdgeInsets.only(top: 0),
                                duration: Duration(seconds: 2),
                                icon: Icon(Icons.check_box_rounded,
                                    color: Colors.white),
                                messageText: Text("Cart successfully updated.",
                                    style: GoogleFonts.openSans(
                                        color: Colors.white)),
                              )..show(context);
                            },
                            child: MyAddToCartButton2()),
                      ],
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
