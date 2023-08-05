import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_practice/routes/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../components/my_containers/my_productCard.dart';
import '../provider/model.dart';

class Watches extends StatelessWidget {
  Watches({super.key});

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

  @override
  Widget build(BuildContext context) {
    //get collection reference of the watches catalog
    final CollectionReference watchesCatalog =
        FirebaseFirestore.instance.collection('watchesCatalogFr');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: StreamBuilder(
              stream: watchesCatalog.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                        color: Colors.deepPurple[600]),
                  );
                } else if (streamSnapshot.hasData) {
                  int documentLength = streamSnapshot.data!.docs.length;
                  Provider.of<Model>(context, listen: false).itemSavedHandler();
                  if (documentLength == 0) {
                    return const Center(
                      child: Text(
                        'N O  P R O D U C T S  A V A I L A B L E 💔 ',
                        style: TextStyle(fontSize: 13.5),
                      ),
                    );
                  }
                  return SizedBox.expand(
                    child: MasonryGridView.builder(
                        gridDelegate:
                            const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final CollectionReference ratingCollection =
                              watchesCatalog
                                  .doc('${index + 1}')
                                  .collection('ratings_and_reviews');
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => ProductDetail(
                                          pID: 'watches',
                                          index: index,
                                          productCollectionReference: watchesCatalog,
                                          ratingCollection: ratingCollection,
                                          productVariants: streamSnapshot.data!
                                              .docs[index]['Product variation'],
                                          productListImages: streamSnapshot
                                              .data!
                                              .docs[index]['productListImages'],
                                          productDescription:
                                              streamSnapshot.data!.docs[index]
                                                  ['Product description'],
                                          //productBoxes: streamSnapshot.data!
                                          // .docs[index]['Product boxes'],
                                          productImage: streamSnapshot.data!
                                              .docs[index]['Product image'],
                                          productName: streamSnapshot.data!
                                              .docs[index]['Product name'],
                                          productPrice: streamSnapshot.data!
                                              .docs[index]['Product price'],
                                          backgroundColor: getRandomColor()))));
                            },
                            child: MyProductCard(
                              pID: 'watches',
                              index: index,
                              productCollectionReference: watchesCatalog,
                              ratingCollection: ratingCollection,
                              productName: streamSnapshot.data!.docs[index]
                                  ['Product name'],
                              productImage: streamSnapshot.data!.docs[index]
                                  ['Product image'],
                              productDescription: streamSnapshot
                                  .data!.docs[index]['Product description'],
                              productVariants: streamSnapshot.data!.docs[index]
                                  ['Product variation'],
                              productPrice: streamSnapshot.data!.docs[index]
                                  ['Product price'],
                              productSaved: streamSnapshot.data!.docs[index]
                                  ['Product saved'],
                              productListImages: streamSnapshot
                                  .data!.docs[index]['productListImages'],
                              backgroundColor: getRandomColor(),
                              productSizes: [],
                            ),
                          );
                        }),
                  );
                }

                return Image.asset('lib/assets/register.png');
              }),
        ),
      ],
    );
  }
}
