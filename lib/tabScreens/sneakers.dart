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
        FirebaseFirestore.instance.collection('watchesCatalogFr');

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
                    return MasonryGridView.builder(
                        itemCount: streamSnapshot.data!.docs.length,
                        gridDelegate:
                            const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        itemBuilder: ((context, index) {
                          return ProductCardRedo();
                        }));
                  }
                  return Center(
                    child: Text('An error Occured'),
                  );
                })))
      ],
    );
  }
}
