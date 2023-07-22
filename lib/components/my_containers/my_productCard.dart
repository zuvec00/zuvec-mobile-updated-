import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/routes/product_details.dart';
import 'package:firebase_practice/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/model.dart';

class MyProductCard extends StatefulWidget {
  final String pID;
  final int index;
  final CollectionReference productCollectionReference;
  final CollectionReference ratingCollection;
  final String productName;
  final String? productDescription;
  final String productImage;
  final List productSizes;
  final List productListImages;
  final productPrice;
  final Map<String, dynamic>? productVariants;
  final bool productSaved;
  final Color backgroundColor;

  MyProductCard({
    super.key,
    this.productDescription,
    required this.index,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.productSaved,
    required this.productListImages,
    required this.productSizes,
    required this.backgroundColor,
    this.productVariants,
    required this.ratingCollection,
    required this.pID,
    required this.productCollectionReference,
  });

  @override
  State<MyProductCard> createState() => _MyProductCardState();
}

class _MyProductCardState extends State<MyProductCard>
    with SingleTickerProviderStateMixin {
  late String productDescription;
  late AnimationController animationController;
  late Animation<double> opacityAnimation;
  late Animation<double> iconAnimation;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animationController)
          ..addListener(() {
            setState(() {});
          });
    iconAnimation =
        Tween<double>(begin: 30, end: 40).animate(animationController)
          ..addListener(() {
            setState(() {});
          });
    productDescription = widget.productDescription ??
        'Lorem ipsum dolor sit amet. Sed unde aspernatur sit corrupti libero est magnam obcaecati nam';
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  String _getCurrentUserId() {
    final User currentUser = FirebaseAuth.instance.currentUser!;
    String userID = currentUser.uid;
    return userID;
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool saved = itemSaved[widget.index];
    final DocumentReference wishlistDocRef = FirebaseFirestore.instance
        .collection('usersWishlistProducts')
        .doc(_getCurrentUserId());
    final CollectionReference wishlistSubColleciton =
        wishlistDocRef.collection('user_wishlist_item');
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                          height: 130,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              // color: Colors.grey[200],
                              color: widget.backgroundColor.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(7.5)),
                          child: Hero(
                              tag: 'Tag: ${widget.index}',
                              child: CachedNetworkImage(
                                  imageUrl: widget.productImage,
                                  placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(
                                            color: Colors.deepPurple[600]),
                                      ),
                                  errorWidget: (context, url, error) => Icon(
                                      Icons.error_outline_rounded,
                                      color: Colors.red)))),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: ((context) {
                            return ProductDetail(
                                pID: widget.pID,
                                backgroundColor: widget.backgroundColor,
                                productCollectionReference:
                                    widget.productCollectionReference,
                                ratingCollection: widget.ratingCollection,
                                productVariants: widget.productVariants,
                                productListImages: widget.productListImages,
                                productImage: widget.productImage,
                                productName: widget.productName,
                                productDescription: widget.productDescription,
                                productSizes: widget.productSizes,
                                productPrice: widget.productPrice,
                                index: widget.index);
                          })));
                        },
                        //animation
                        onDoubleTap: () {
                          setState(() {
                            if (saved == false) {
                              print('savedIndex: ${widget.index}');
                              // calls function to add items to the saved page
                              Provider.of<Model>(context, listen: false)
                                  .addSavedItem({
                                'productImagePath': widget.productImage,
                                'productName': widget.productName,
                                'productSize': widget.productSizes[0],
                                'productPrice': widget.productPrice.toDouble(),
                              });

                              DatabaseService(uID: _getCurrentUserId())
                                  .addWishlistItem(
                                      '${widget.pID}${widget.index}',
                                      widget.productImage,
                                      widget.productName,
                                      widget.productPrice.toDouble(),
                                      widget.productSizes[0],
                                      wishlistSubColleciton);

                              // calls function to switch the saved true or false
                              Provider.of<Model>(context, listen: false)
                                  .saveStateHandler(widget.index);
                              //animation
                              animationController.forward().then((_) {
                                Future.delayed(Duration(seconds: 1), () {
                                  animationController.reverse();
                                });
                              });
                            }
                          });
                        },
                        child: AnimatedOpacity(
                          opacity: opacityAnimation.value,
                          duration: Duration(milliseconds: 700),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              saved
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: iconAnimation.value, // saved ? 26 : 22,
                              color: Colors.deepPurple[600],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text('${widget.productName}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[900])),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Text('N',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration:
                                            TextDecoration.lineThrough)),
                                Text('${widget.productPrice}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ],
                            ),
                          ]),
                        ),
                        InkWell(
                          radius: 25,
                          splashColor: Colors.deepPurple,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => ProductDetail(
                                        pID: widget.pID,
                                        ratingCollection:
                                            widget.ratingCollection,
                                        productCollectionReference:
                                            widget.productCollectionReference,
                                        productListImages:
                                            widget.productListImages,
                                        productVariants: widget.productVariants,
                                        backgroundColor: widget.backgroundColor,
                                        productImage: widget.productImage,
                                        productDescription:
                                            widget.productDescription,
                                        productName: widget.productName,
                                        productSizes: widget.productSizes,
                                        productPrice: widget.productPrice,
                                        index: widget.index))));
                            /* 
                     //calls the function to add items to cart
                      Provider.of<Model>(context, listen: false).addCartItem({
                        'productImagePath': widget.productImage,
                        'productName': widget.productName,
                        'productPrice': widget.productPrice.toDouble(),
                        'productSize': '16',
                        'productItemQuantity': 1,
                      });
                      //calls the function to update the length of cart
                      Provider.of<Model>(context, listen: false)
                          .updateCartItemsLength();

                      //notifies the end user item has been added to cart
                      Flushbar(
                        flushbarPosition: FlushbarPosition.TOP,
                        backgroundColor: Colors.green[400]!,
                        margin: const EdgeInsets.only(top: 0),
                        duration: Duration(seconds: 3),
                        icon:
                            Icon(Icons.check_box_rounded, color: Colors.white),
                        messageText: Text("Cart successfully updated",
                            style: GoogleFonts.openSans(color: Colors.white)),
                      )..show(context);*/
                          },
                          child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade600,
                                shape: BoxShape.circle,
                                // borderRadius: BorderRadius.circular(10)
                              ),
                              child: Icon(Icons.arrow_forward_ios_rounded,
                                  size: 18, color: Colors.grey[100])),
                        )
                      ]),
                ],
              ),
            ]));
  }
}
