import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_practice/routes/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../provider/model.dart';
import '../../routes/watches_productDetails.dart';

class MyWatchesProductCard extends StatefulWidget {
  final int index;
  final String productName;
  final String? productDescription;
  final String productImage;
  final List productBoxes;
  final List productListImages;
  final productPrice;
  final bool productSaved;

  MyWatchesProductCard({
    super.key,
    this.productDescription,
    required this.index,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.productSaved,
    required this.productListImages,
    required this.productBoxes,
  });

  @override
  State<MyWatchesProductCard> createState() => _MyWatchesProductCardState();
}

class _MyWatchesProductCardState extends State<MyWatchesProductCard>
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

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool saved = itemSaved[widget.index];
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                            height: 130,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
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
                              return WatchesProductDetail(
                                  productListImages: widget.productListImages,
                                  productImage: widget.productImage,
                                  productName: widget.productName,
                                  productDescription: widget.productDescription,
                                  productBoxes: widget.productBoxes,
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
                                  'productSize':widget.productBoxes[0].toString(),
                                  'productPrice':
                                      widget.productPrice.toDouble()+widget.productBoxes[2].toDouble(),
                                });
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
                    Text('${widget.productName}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 3),
                    Flexible(
                        child: Text(productDescription,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]))),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('N',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.lineThrough)),
                      Text('${widget.productPrice}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  InkWell(
                    radius: 25,
                    splashColor: Colors.deepPurple,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => WatchesProductDetail(
                                  productListImages: widget.productListImages,
                                  productImage: widget.productImage,
                                  productDescription: widget.productDescription,
                                  productName: widget.productName,
                                  productBoxes: widget.productBoxes,
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
                ],
              )
            ]));
  }
}
