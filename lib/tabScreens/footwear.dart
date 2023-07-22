import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_practice/routes/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../components/my_containers/my_productCard.dart';
import '../provider/model.dart';
import '../util/productCardredo.dart';

class Sneakers extends StatelessWidget {
  Sneakers({super.key});

  @override
  Widget build(BuildContext context) {
    //get collection reference of the watches catalog
    final CollectionReference footwearCatalog =
        FirebaseFirestore.instance.collection('footwearCatalog');

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

    return Column(
      children: [
        Expanded(
            child: StreamBuilder(
                stream: footwearCatalog.snapshots(),
                builder: ((context, streamSnapshot) {
                  if (streamSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                          color: Colors.deepPurple[600]),
                    );
                  } else if (streamSnapshot.hasData) {
                    return SizedBox.expand(
                      child: MasonryGridView.builder(
                          itemCount: streamSnapshot.data!.docs.length,
                          gridDelegate:
                              const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          itemBuilder: ((context, index) {
                            final CollectionReference ratingCollection =
                                footwearCatalog
                                    .doc('${index + 1}')
                                    .collection('ratings_and_reviews');
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => ProductDetail(
                                              pID: 'footwear',
                                              index: index,
                                              backgroundColor: getRandomColor(),
                                              
                                              productListImages: streamSnapshot
                                                      .data!.docs[index]
                                                  ['productListImages'],
                                              productSizes: streamSnapshot.data!
                                                  .docs[index]['Product sizes'],
                                              productImage: streamSnapshot.data!
                                                  .docs[index]['Product image'],
                                              productDescription: streamSnapshot
                                                      .data!.docs[index]
                                                  ['Product description'],
                                              productName: streamSnapshot.data!
                                                  .docs[index]['Product name'],
                                              productPrice: streamSnapshot.data!
                                                  .docs[index]['Product price'],
                                              ratingCollection:
                                                  ratingCollection,
                                              productCollectionReference: footwearCatalog,
                                            ))));
                              },
                              child: MyProductCard(
                                pID: 'footwear',
                                index: index,
                                productCollectionReference: footwearCatalog,
                                ratingCollection: ratingCollection,
                                backgroundColor: getRandomColor(),
                                productName: streamSnapshot.data!.docs[index]
                                    ['Product name'],
                                productDescription: streamSnapshot
                                    .data!.docs[index]['Product description'],
                                productImage: streamSnapshot.data!.docs[index]
                                    ['Product image'],
                                productSizes: streamSnapshot.data!.docs[index]
                                    ['Product sizes'],
                                productPrice: streamSnapshot.data!.docs[index]
                                    ['Product price'],
                                productSaved: streamSnapshot.data!.docs[index]
                                    ['Product saved'],
                                productListImages: streamSnapshot
                                    .data!.docs[index]['productListImages'],
                              ),
                            );
                          })),
                    );
                  }
                  return Center(
                    child: Text('An error Occured'),
                  );
                })))
      ],
    );
  }
}
