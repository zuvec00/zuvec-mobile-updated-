import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../components/my_containers/my_add2Cart.dart';
import '../components/my_containers/my_chatWseller.dart';
import '../components/my_containers/my_productSize.dart';
import '../components/my_price.dart';
import '../components/my_ratingBar.dart';
import '../provider/model.dart';
import 'cart_page.dart';

class WatchesProductDetail extends StatefulWidget {
  final int index;
  final String productImage;
  final String productName;
  final String? productDescription;
  final int productPrice;
  final List? productBoxes;
  final List productListImages;

  WatchesProductDetail(
      {super.key,
      required this.productListImages,
      required this.productImage,
      required this.productName,
      required this.productPrice,
      required this.index,
      this.productDescription,
      this.productBoxes});

  @override
  State<WatchesProductDetail> createState() => _WatchesProductDetailState();
}

class _WatchesProductDetailState extends State<WatchesProductDetail> {
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  late String productDescription;
  late List productImages;
  late List productBoxes;
  int selectedIndex = 0;
  int noOfItems = 1;
  PageController _controller = PageController();

  void initState() {
    super.initState();
    print(selectedIndex);
    //store the list of images
    productImages = widget.productListImages;
    print('Lets see if it works: $productImages');

    productBoxes = widget.productBoxes ?? [900, 1500, 3000, 4000, 8500];
    productDescription = widget.productDescription ??
        'Lorem ipsum dolor sit amet. Sed unde aspernatur sit corrupti libero est magnam obcaecati nam';
  }

  Future<void> _handleRefresh() async {
    return await Future.delayed(Duration(seconds: 2));
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

  @override
  Widget build(BuildContext context) {
    bool saved = itemSaved[widget.index];
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.grey[100],
            elevation: 0,
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.grey[900])),
            title: Text(
              'Product details',
              style: GoogleFonts.workSans(color: Colors.grey[900]),
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
        body: LiquidPullToRefresh(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          color: Colors.grey[100],
          height: 150,
          animSpeedFactor: 2,
          backgroundColor: Colors.deepPurple[600],
          child: Column(children: [
            //const SizedBox(height: 15),
            AspectRatio(
              aspectRatio: 1.25,
              child: Stack(alignment: Alignment.bottomRight, children: [
                Container(
                    color: Colors.grey[200],
                    child: Hero(
                        tag: 'Tag: ${widget.index}',
                        child: PageView.builder(
                            controller: _controller,
                            scrollDirection: Axis.horizontal,
                            itemCount: productImages.length,
                            itemBuilder: ((context, index) =>
                                CachedNetworkImage(
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
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        if (saved == false) {
                          // calls function to add items to the saved page
                          Provider.of<Model>(context, listen: false)
                              .addSavedItem({
                            'productImagePath': widget.productImage,
                            'productName': widget.productName,
                            'productPrice': widget.productPrice.toDouble() +
                                productBoxes[selectedIndex].toDouble(),
                            'productSize':
                                productBoxes[selectedIndex].toString(),
                          });
                          // calls function to switch the saved true or false
                          Provider.of<Model>(context, listen: false)
                              .saveStateHandler(widget.index);
                        } else if (saved == true) {
                          // calls function to switch the saved true or false
                          Provider.of<Model>(context, listen: false)
                              .saveStateHandler(widget.index);
                          //calls function to remove item from the saved page
                          Provider.of<Model>(context, listen: false)
                              .removeSavedItem(widget.index);
                        }
                      });
                      print('Heart icon tapped; route:product details');
                    },
                    icon: Icon(
                        saved
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: saved ? 34 : 30,
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
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold)),
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
                                              style: TextStyle(
                                                  color: Colors.white))))
                                ])),
                          ],
                        ),
                        /*const SizedBox(height: 10),
                        Row(
                          children: const [
                            MyRatingBar(),
                            Text(' (270 Reviews)')
                          ],
                        ),*/
                        const SizedBox(height: 10),
                        const Text('Available Boxes',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 35,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: productBoxes.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: MyProductSizeCont(
                                    size: productBoxes[index].toString(),
                                    isSelected: index == selectedIndex,
                                    onSelected: () =>
                                        sizeSelectionHandler(index),
                                  ),
                                );
                              }),
                        ),
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
                                Price(
                                    price: widget.productPrice.toDouble() +
                                        productBoxes[selectedIndex].toDouble()),
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
                        //calls the function to add items to cart
                        Provider.of<Model>(context, listen: false).addCartItem({
                          'productImagePath': widget.productImage,
                          'productName': widget.productName,
                          'productPrice': widget.productPrice.toDouble() +
                              productBoxes[selectedIndex].toDouble(),
                          'productSize': productBoxes[selectedIndex].toString(),
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
                          icon: const Icon(Icons.check_box_rounded,
                              color: Colors.white),
                          messageText: Text("Cart successfully updated",
                              style: GoogleFonts.openSans(color: Colors.white)),
                        )..show(context).then((_) => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => WatchesProductDetail(
                                      index: widget.index,
                                      productListImages:
                                          widget.productListImages,
                                      productBoxes: widget.productBoxes,
                                      productImage: widget.productImage,
                                      productDescription:
                                          widget.productDescription,
                                      productName: widget.productName,
                                      productPrice: widget.productPrice,
                                    )))));
                      },
                      child: MyAddToCartButton()),
                  const SizedBox(height: 10),
                ],
              ),
            ))
          ]),
        ));
  }
}
