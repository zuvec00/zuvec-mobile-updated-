// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:fluentui_icons/fluentui_icons.dart';

import '../components/my_containers/my_add2Cart.dart';
import '../components/my_containers/my_chatWseller.dart';
import '../components/my_containers/my_productSize.dart';
import '../components/my_price.dart';
import '../components/rating_template.dart';
import '../pages/login_or_register.dart';
import '../provider/model.dart';
import '../services/database_service.dart';
import 'cart_page.dart';

class ProductDetail extends StatefulWidget {
  final String pID;
  final int index;
  final String productName;
  final String? productDescription;
  final int productPrice;
  final List? productSizes;
  final List productListImages;
  final Map? productVariants;
  final String productImage;
  final CollectionReference productCollectionReference;
  final CollectionReference ratingCollection;
  final Color backgroundColor;

  ProductDetail(
      {super.key,
      required this.productListImages,
      required this.productImage,
      required this.productName,
      required this.productPrice,
      required this.index,
      this.productDescription,
      this.productSizes,
      required this.backgroundColor,
      this.productVariants,
      required this.ratingCollection,
      required this.pID,
      required this.productCollectionReference});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  // final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
  //  GlobalKey<LiquidPullToRefreshState>();
  late String productDescription;
  late List productImages;
  late List productSizes;
  late Map<String, dynamic> productVariants;
  double averageRating = 0;
  double totalRating = 0;
  int totalRaters = 0;
  int selectedIndex = 0;
  int noOfItems = 1;
  bool productSavedState = false;
  PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
    setProductSavedState();
    print(selectedIndex);
    //store the list of images
    productImages = widget.productListImages;
    print('Lets see if it works: $productImages');

    productSizes = widget.productSizes ?? ['12', '14', '16', '18'];
    productDescription = widget.productDescription!;
  }

  Future<void> setProductSavedState() async {
    final tempSavedState = await DatabaseService(uID: _getCurrentUserId())
        .getSavedState(widget.productCollectionReference, widget.productImage);
    setState(() {
      productSavedState = tempSavedState;
    });
  }

  void _add2noOfItems() {
    setState(() {
      noOfItems++;
    });
  }

  void _removeFromnoOfItems() {
    setState(() {
      noOfItems--;
    });
    if (noOfItems == 0) {
      setState(() {
        noOfItems = 1;
      });
    }
  }

  void sizeSelectionHandler(int index) {
    print(index);
    setState(() {
      selectedIndex = index;
    });

    print(selectedIndex);
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
                        builder: (context) => const LoginOrRegisterPage()));
              },
              child: Text('Sign Up', style: GoogleFonts.quicksand()),
            ),
          ],
        );
      },
    );
  }

  String _getCurrentUserId() {
    final User currentUser = FirebaseAuth.instance.currentUser!;
    String userID = currentUser.uid;
    return userID;
  }

  @override
  Widget build(BuildContext context) {
    final DocumentReference wishlistDocRef = FirebaseFirestore.instance
        .collection('usersWishlistProducts')
        .doc(_getCurrentUserId());
    final DocumentReference cartDocRef = FirebaseFirestore.instance
        .collection('usersCartProducts')
        .doc(_getCurrentUserId());
    final CollectionReference wishlistSubColleciton =
        wishlistDocRef.collection('user_wishlist_item');
    final CollectionReference cartSubCollection =
        cartDocRef.collection('user_cart_item');

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
          backgroundColor: Colors.grey[100],
          elevation: 0,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.grey[900])),
          title: Text(
            'Details',
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
      body: Column(children: [
        //const SizedBox(height: 15),
        AspectRatio(
          aspectRatio: 1.25,
          child: Stack(alignment: Alignment.bottomRight, children: [
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                // color: Colors.grey[200],
                decoration: BoxDecoration(
                  color: widget.backgroundColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Hero(
                    tag: 'Tag: ${widget.index}',
                    child: PageView.builder(
                        controller: _controller,
                        scrollDirection: Axis.horizontal,
                        itemCount: productImages.length,
                        itemBuilder: ((context, index) => CachedNetworkImage(
                            imageUrl: productImages[index],
                            placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.deepPurple[600]),
                                ),
                            errorWidget: (context, url, error) => Icon(
                                Icons.error_outline_rounded,
                                color: Colors.red)))))),
            Container(
                alignment: const Alignment(0.0, 0.75),
                child: SmoothPageIndicator(
                    controller: _controller,
                    count: productImages.length,
                    effect: ExpandingDotsEffect(
                        expansionFactor: 4,
                        dotWidth: 8,
                        dotHeight: 8,
                        activeDotColor: Colors.deepPurple[600]!,
                        dotColor: Colors.white))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: IconButton(
                onPressed: () {
                  if (isUserAnonymous()) {
                    showSignUpPrompt(context);
                  } else {
                    setState(() async {
                      if (!productSavedState) {
                        //print('${widget.pID}${widget.index}');
                        // calls function to switch the saved true or false
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.deepPurple[600]));
                            });
                        await DatabaseService(uID: _getCurrentUserId())
                            .savedStateHandler(
                                widget.productCollectionReference,
                                widget.productImage,
                                true)
                            .then((value) => setProductSavedState());

                        Provider.of<Model>(context, listen: false)
                            .saveStateHandler(widget.index);
                        DatabaseService(uID: _getCurrentUserId())
                            .addWishlistItem(
                                '${widget.pID}${widget.index}',
                                widget.productImage,
                                widget.productName,
                                widget.productVariants == null
                                    ? widget.productPrice.toDouble()
                                    : (widget.productPrice +
                                            widget.productVariants![
                                                '$selectedIndex'][1])
                                        .toDouble(),
                                widget.productVariants == null
                                    ? widget.productSizes![selectedIndex]
                                    : widget.productVariants!['$selectedIndex']
                                        [0],
                                wishlistSubColleciton)
                            .then((value) => Navigator.pop(context));
                        // calls function to add items to the saved page
                        Provider.of<Model>(context, listen: false)
                            .addSavedItem({
                          'productImagePath': widget.productImage,
                          'productName': widget.productName,
                          'productPrice': widget.productPrice.toDouble(),
                          'productSize': widget.productVariants == null
                              ? widget.productSizes![selectedIndex]
                              : widget.productVariants!['$selectedIndex'][0],
                        });
                      } else if (productSavedState) {
                        // calls function to switch the saved true or false
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.deepPurple[600]));
                            });
                        await DatabaseService(uID: _getCurrentUserId())
                            .savedStateHandler(
                                widget.productCollectionReference,
                                widget.productImage,
                                false)
                            .then((value) => setProductSavedState());

                        Provider.of<Model>(context, listen: false)
                            .saveStateHandler(widget.index);
                        //calls function to remove item from the saved page
                        DatabaseService(uID: _getCurrentUserId())
                            .deleteWishlistItem(wishlistSubColleciton,
                                '${widget.pID}${widget.index}')
                            .then((value) => Navigator.pop(context));
                        Provider.of<Model>(context, listen: false)
                            .removeSavedItem(widget.index);
                      }
                    });
                    print('Heart icon tapped; route:product details');
                  }
                },
                icon: Icon(
                    productSavedState
                        ? FluentSystemIcons.ic_fluent_heart_filled
                        : FluentSystemIcons.ic_fluent_heart_regular,
                    size: productSavedState ? 34 : 30,
                    color: Colors.grey[900]),
              ),
            )
          ]),
        ),

        //product details
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(widget.productName,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(children: [
                              InkWell(
                                  onTap: () {
                                    _removeFromnoOfItems();
                                  },
                                  child: Text('- ',
                                      style: TextStyle(fontSize: 15))),
                              Text('  $noOfItems  '),
                              GestureDetector(
                                  onTap: () {
                                    _add2noOfItems();
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(4.5),
                                      decoration: BoxDecoration(
                                          color: Colors.deepPurple[600],
                                          shape: BoxShape.circle),
                                      child: Text('+',
                                          style:
                                              TextStyle(color: Colors.white))))
                            ])),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                        height: 20,
                        child: StreamBuilder(
                          stream: widget.ratingCollection.snapshots(),
                          builder: (context, streamSnapshot) {
                            if (streamSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                    color: Colors.deepPurple[600]),
                              );
                            } else if (streamSnapshot.hasData) {
                              totalRaters = streamSnapshot.data!.docs.length;
                              totalRating = 0.0;
                              for (int i = 0;
                                  i < streamSnapshot.data!.docs.length;
                                  i++) {
                                final documentSnapshot =
                                    streamSnapshot.data!.docs[i];

                                totalRating += documentSnapshot['Rating'];
                              }
                              averageRating = double.parse(
                                  (totalRating / totalRaters)
                                      .toStringAsFixed(1));
                              return RatingTemplate(
                                rating: averageRating,
                                totalRaters: '$totalRaters reviews',
                              );
                            }
                            return const Text('Error fetching rating data',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ));
                          },
                        )),
                    /*const SizedBox(height: 10),
                        Row(
                          children: const [
                            MyRatingBar(),
                            Text(' (270 Reviews)')
                          ],
                        ),*/
                    const SizedBox(height: 10),
                    Text(
                        widget.productVariants == null
                            ? 'Size'
                            : 'Available Boxes',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        height: 35,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.productVariants == null
                                ? productSizes.length
                                : widget.productVariants!.length,
                            itemBuilder: (context, index) {
                              if (widget.productVariants != null) {
                                return MyProductSizeCont(
                                  size: widget.productVariants!['$index'][0],
                                  isSelected: index == selectedIndex,
                                  onSelected: () => sizeSelectionHandler(index),
                                );
                              }
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: MyProductSizeCont(
                                  size: productSizes[index],
                                  isSelected: index == selectedIndex,
                                  onSelected: () => sizeSelectionHandler(index),
                                ),
                              );
                            })),
                    const SizedBox(height: 15),
                    const Text('Description',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Flexible(
                        child: Text(productDescription,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]))),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Price',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey)),
                            Row(
                              children: [
                                Price(price: widget.productPrice.toDouble()),
                                Transform.translate(
                                  offset: const Offset(
                                      0, -8), // Adjust the vertical position
                                  child: widget.productVariants == null
                                      ? Text(
                                          '+ 0',
                                          style: TextStyle(
                                            fontSize: 13,
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.grey[600],
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                          ),
                                        )
                                      : Text(
                                          '+ ${widget.productVariants!['$selectedIndex'][1]} ',
                                          style: TextStyle(
                                            fontSize: 13,
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.grey[600],
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        MyChatWithSellerButton()
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                  onTap: () {
                    if (isUserAnonymous()) {
                      showSignUpPrompt(context);
                    } else {
                      DatabaseService(uID: _getCurrentUserId()).addCartItem(
                          '${widget.pID}${widget.index}',
                          widget.productImage,
                          widget.productName,
                          widget.productVariants == null
                              ? widget.productPrice.toDouble()
                              : (widget.productPrice +
                                      widget.productVariants!['$selectedIndex']
                                          [1])
                                  .toDouble(),
                          widget.productVariants == null
                              ? widget.productSizes![selectedIndex]
                              : widget.productVariants!['$selectedIndex'][0],
                          noOfItems,
                          cartSubCollection);
                      //calls the function to add items to cart
                      Provider.of<Model>(context, listen: false).addCartItem({
                        'productImagePath': widget.productImage,
                        'productName': widget.productName,
                        'productPrice': widget.productVariants == null
                            ? widget.productPrice.toDouble()
                            : (widget.productPrice +
                                    widget.productVariants!['$selectedIndex']
                                        [1])
                                .toDouble(),
                        'productSize': widget.productVariants == null
                            ? widget.productSizes![selectedIndex]
                            : widget.productVariants!['$selectedIndex'][0],
                        'productItemQuantity': noOfItems,
                      });

                      //calls the function to update the length of cart
                      Provider.of<Model>(context, listen: false)
                          .updateCartItemsLength();

                      //notifies the user that the cart has been update
                      // ignore: avoid_single_cascade_in_expression_statements
                      Flushbar(
                        flushbarPosition: FlushbarPosition.TOP,
                        backgroundColor: Colors.green[400]!,
                        margin: const EdgeInsets.only(top: 0),
                        duration: Duration(seconds: 1),
                        icon:
                            Icon(Icons.check_box_rounded, color: Colors.white),
                        messageText: Text("Cart successfully updated",
                            style: GoogleFonts.quicksand(color: Colors.white)),
                      )..show(context) /*.then((_) => 
                   Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => ProductDetail(
                                  pID: widget.pID,
                                  index: widget.index,
                                  ratingCollection: widget.ratingCollection,
                                  backgroundColor: widget.backgroundColor,
                                  productVariants:
                                      widget.productVariants == null
                                          ? null
                                          : widget.productVariants,
                                  productListImages: widget.productListImages,
                                  productSizes: widget.productSizes,
                                  productImage: widget.productImage,
                                  productDescription: widget.productDescription,
                                  productName: widget.productName,
                                  productPrice: widget.productPrice,
                                )))))*/
                          ;
                    }
                  },
                  child: MyAddToCartButton()),
              const SizedBox(height: 10),
            ],
          ),
        ))
      ]),
    );
  }
}
