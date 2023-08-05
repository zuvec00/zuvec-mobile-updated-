import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../components/my_containers/my_productCard.dart';
import '../product_details.dart';

class MySearchPage extends StatelessWidget {
  final String productID;
  final String collectionName;
  final String searchQuery;
  const MySearchPage(
      {super.key,
      required this.collectionName,
      required this.searchQuery,
      required this.productID});

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
    final CollectionReference collection =
        FirebaseFirestore.instance.collection(collectionName);
    final collectionQuery =
        collection.where('Product name', isGreaterThanOrEqualTo: searchQuery, isLessThan: searchQuery + '\uf8ff');
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 45),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Scaffold(
            backgroundColor: Colors.grey[100],
            /*appBar: AppBar(
              backgroundColor: Colors.grey[100],
              title: Text('Search Result',style: GoogleFonts.quicksand(),),
              centerTitle: true,
              elevation: 0,
            ),*/
            body: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    const Text('S E A R C H  R E S U L T',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Expanded(
                        child: StreamBuilder(
                      stream: collectionQuery.snapshots(),
                      builder: (context, streamSnapshot) {
                        if (streamSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                                color: Colors.deepPurple[600]),
                          );
                        } else if (streamSnapshot.hasData) {
                          print('Search query length:${streamSnapshot.data!.docs.length},');
                          return SizedBox.expand(
                              child: MasonryGridView.builder(
                                  itemCount: streamSnapshot.data!.docs.length,
                                  gridDelegate:
                                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2),
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  itemBuilder: (context, index) {
                                    int documentLength =
                                        streamSnapshot.data!.docs.length;
                                    if (documentLength == 0) {
                                      return const Center(
                                          child: Text(
                                              'N O  P R O D U C T S  A V A I L A B L E'));
                                    } else {
                                      final CollectionReference
                                          ratingCollection = collection
                                              .doc('${index + 1}')
                                              .collection(
                                                  'ratings_and_reviews');
                                      print(
                                          'treamSnapshot.data!.docs.length == 0: ${streamSnapshot.data!.docs.length}');
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) => ProductDetail(
                                                      pID: productID,
                                                      index: index,
                                                      productCollectionReference: collection,
                                                      ratingCollection:
                                                          ratingCollection,
                                                      backgroundColor:
                                                          getRandomColor(),
                                                      productListImages: streamSnapshot.data!.docs[index]
                                                          ['productListImages'],
                                                      productVariants: streamSnapshot
                                                              .data!.docs[index]
                                                          ['Product variation'],
                                                      productSizes: collectionName ==
                                                              'watchesCatalogFr'
                                                          ? streamSnapshot.data!.docs[index]
                                                              ['Product boxes']
                                                          : streamSnapshot.data!.docs[index]
                                                              ['Product sizes'],
                                                      productImage: streamSnapshot
                                                              .data!.docs[index]
                                                          ['Product image'],
                                                      productDescription:
                                                          streamSnapshot.data!.docs[index]
                                                              ['Product description'],
                                                      productName: streamSnapshot.data!.docs[index]['Product name'],
                                                      productPrice: streamSnapshot.data!.docs[index]['Product price']))));
                                        },
                                        child: MyProductCard(
                                          pID: productID,
                                          index: index,
                                          ratingCollection: ratingCollection,
                                          productCollectionReference: collection,
                                          backgroundColor: getRandomColor(),
                                          productVariants: collectionName ==
                                                  'watchesCatalogFr'
                                              ? streamSnapshot.data!.docs[index]
                                                  ['Product variation']
                                              : null,
                                          productName: streamSnapshot.data!
                                              .docs[index]['Product name'],
                                          productDescription:
                                              streamSnapshot.data!.docs[index]
                                                  ['Product description'],
                                          productImage: streamSnapshot.data!
                                              .docs[index]['Product image'],
                                          productSizes: collectionName ==
                                                  'watchesCatalogFr'
                                              ? streamSnapshot.data!.docs[index]
                                                  ['Product boxes']
                                              : streamSnapshot.data!.docs[index]
                                                  ['Product sizes'],
                                          productPrice: streamSnapshot.data!
                                              .docs[index]['Product price'],
                                          productSaved: streamSnapshot.data!
                                              .docs[index]['Product saved'],
                                          productListImages: streamSnapshot
                                              .data!
                                              .docs[index]['productListImages'],
                                        ),
                                      );
                                    }
                                  }));
                        }
                        return Center(child: Text('An error occured'));
                      },
                    ))
                  ],
                ))));
  }
}
