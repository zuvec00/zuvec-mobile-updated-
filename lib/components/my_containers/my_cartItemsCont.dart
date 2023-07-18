import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/model.dart';
import '../../routes/cart_page.dart';
import '../../services/database_service.dart';
import '../my_price.dart';

class MyCartItems extends StatefulWidget {
  final int index;
  final Color backgroundColor;
  final String productID;
  final String productImagePath;
  final String productName;
  final double productPrice;
  final String productSize;
  int? itemQuantity;

  MyCartItems({
    super.key,
    required this.productImagePath,
    required this.productName,
    required this.productPrice,
    this.itemQuantity,
    required this.index,
    required this.productSize,
    required this.productID, required this.backgroundColor,
  });

  @override
  State<MyCartItems> createState() => _MyCartItemsState();
}

class _MyCartItemsState extends State<MyCartItems> {
  void _add2noOfItems() {
    setState(() {
      widget.itemQuantity = widget.itemQuantity! + 1;
    });
  }

  void _removeFromnoOfItems() {
    setState(() {
      widget.itemQuantity = widget.itemQuantity! - 1;
    });
    if (widget.itemQuantity! == 0) {
      setState(() {
        widget.itemQuantity = 1;
      });
    }
  }

  String _getCurrentUserId() {
    final User currentUser = FirebaseAuth.instance.currentUser!;
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
    return Slidable(
      endActionPane: ActionPane(motion: StretchMotion(), children: [
        SlidableAction(
          onPressed: (context) {
            DatabaseService(uID: _getCurrentUserId())
                .deleteCartItem(cartSubCollection, widget.productID);
            Provider.of<Model>(context, listen: false)
                .removeCartItem(widget.index);

            //notifies user
            Flushbar(
              flushbarPosition: FlushbarPosition.TOP,
              backgroundColor: Colors.red[400]!,
              margin: const EdgeInsets.only(top: 0),
              duration: Duration(seconds: 2),
              icon: Icon(Icons.check_box_rounded, color: Colors.white),
              messageText: Text("Item successfully deleted.",
                  style: GoogleFonts.openSans(color: Colors.white)),
            )..show(context).then((_) => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: ((context) => Cart()))));
            ;
          },
          icon: Icons.delete_rounded,
          backgroundColor: Colors.deepPurple.shade600,
          borderRadius: BorderRadius.circular(15),
        )
      ]),
      child: Container(
          padding: const EdgeInsets.all(8),
          width: size.width,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: widget.backgroundColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(7.5)),
                  child: CachedNetworkImage(
                      imageUrl: widget.productImagePath,
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
                    Text('${widget.productName}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 2),
                    Price(
                      price: widget.productPrice,
                      fontSize: 13,
                    ),
                    const SizedBox(height: 2),
                    Text('variant:${widget.productSize}',
                        style:
                            TextStyle(fontSize: 13, color: Colors.grey[600])),
                    const SizedBox(height: 2),
                  ],
                ),
              ),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(children: [
                    GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.deepPurple[600]));
                              });
                          DatabaseService(uID: _getCurrentUserId())
                              .decrementProductQuantity(
                                  cartSubCollection, widget.productID);
                          Navigator.pop(context);
                          _removeFromnoOfItems();
                          Provider.of<Model>(context, listen: false)
                              .updateCartItemsQuantity(widget.index, {
                            'productImagePath': widget.productImagePath,
                            'productName': widget.productName,
                            'productPrice': widget.productPrice.toDouble(),
                            'productSize': widget.productSize,
                            'productItemQuantity': widget.itemQuantity,
                          });
                          /*Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => Cart())));*/
                        },
                        child: Text('-')),
                    Text('  ${widget.itemQuantity}  '),
                    GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.deepPurple[600]));
                              });
                          DatabaseService(uID: _getCurrentUserId())
                              .incrementProductQuantity(
                                  cartSubCollection, widget.productID);
                          Navigator.pop(context);
                          _add2noOfItems();
                          Provider.of<Model>(context, listen: false)
                              .updateCartItemsQuantity(widget.index, {
                            'productImagePath': widget.productImagePath,
                            'productName': widget.productName,
                            'productPrice': widget.productPrice.toDouble(),
                            'productSize': widget.productSize,
                            'productItemQuantity': widget.itemQuantity,
                          });
                          /*Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => Cart())));*/
                        },
                        child: Container(
                            padding: const EdgeInsets.all(4.5),
                            decoration: BoxDecoration(
                                color: Color(0xFF5E35B1),
                                shape: BoxShape.circle),
                            child: Text('+',
                                style: TextStyle(color: Colors.white))))
                  ])),
            ],
          )),
    );
  }
}
