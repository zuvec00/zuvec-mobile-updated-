import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_practice/routes/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../components/my_containers/my_productCard.dart';
import '../provider/model.dart';

class LuchiMaterials extends StatelessWidget {
  LuchiMaterials({super.key});

  @override
  Widget build(BuildContext context) {
    //get collection reference of the watches catalog
    final CollectionReference luchiMaterialsCatalogRef =
        FirebaseFirestore.instance.collection('luchiMaterialsCatalog');
        
     Color getRandomColor(){
      final Random random = Random();
      final List<Color> colors = [
        Color(0xFFC8E6C9),// light green
        Color(0xFFFFF9C4),// pale yellow
        Color(0xFFFFE0B2), //light peach
        Color(0xFFFFCDD2), //soft pink
        Color(0xFFE1BEE7),// lilac
        Color(0xFFB2EBF2), //light aqua
      ];
      return colors[random.nextInt(colors.length)];
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: StreamBuilder(
              stream: luchiMaterialsCatalogRef.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                        color: Colors.deepPurple[600]),
                  );
                } else if (streamSnapshot.hasData) {
                  documentLength2 = streamSnapshot.data!.docs.length;
                  int documentLength = streamSnapshot.data!.docs.length;
                  Provider.of<Model>(context, listen: false).itemSavedHandler();

                  if (documentLength == 0) {
                    return const Center(
                      child: Text(
                        'N O  P R O D U C T S  A V A I L A B L E💔 ',
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
                          final CollectionReference ratingCollection = luchiMaterialsCatalogRef.doc('${index+1}').collection('ratings_and_reviews');
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => ProductDetail(
                                        pID: 'ankara_material',
                                          index: index,
                                          ratingCollection: ratingCollection,
                                          backgroundColor: getRandomColor(),
                                          productListImages: streamSnapshot
                                              .data!
                                              .docs[index]['productListImages'],
                                          productDescription:
                                              streamSnapshot.data!.docs[index]
                                                  ['Product description'],
                                          productSizes: streamSnapshot.data!.docs[index]
                                              ['Product sizes'],
                                          productImage: streamSnapshot.data!
                                              .docs[index]['Product image'],
                                          productName: streamSnapshot.data!.docs[index]
                                              ['Product name'],
                                          productPrice: streamSnapshot.data!
                                              .docs[index]['Product price']))));
                            },
                            child: MyProductCard(
                              pID:'ankara_material',
                              index: index,
                              ratingCollection: ratingCollection,
                              backgroundColor: getRandomColor(),
                              productName: streamSnapshot.data!.docs[index]
                                  ['Product name'],
                              productImage: streamSnapshot.data!.docs[index]
                                  ['Product image'],
                              productDescription: streamSnapshot
                                  .data!.docs[index]['Product description'],
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
                        }),
                  );
                }

                return Center(child: Text('An error occured'));
              }),
        ),
      ],
    );
  }
}
