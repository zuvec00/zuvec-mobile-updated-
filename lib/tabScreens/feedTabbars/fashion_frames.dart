import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../provider/model.dart';
import '../../util/my_frames.dart';

class FashionFrames extends StatelessWidget {
  const FashionFrames({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference fashionFramesRef =
        FirebaseFirestore.instance.collection('fashionFrames');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.00),
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: fashionFramesRef.snapshots(),
              builder: ((context, streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                        color: Colors.deepPurple[600]),
                  );
                } else if (streamSnapshot.hasData) {
                  for (int i = 0; i < streamSnapshot.data!.docs.length; i++) {
                    Provider.of<Model>(context, listen: false)
                        .functionCalledHandler();
                  }
                  if (streamSnapshot.data!.docs.length == 0) {
                    return SizedBox.expand(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset('lib/assets/no_post.png'),
                        Column(
                          children: [
                            Text('Sorry, No Posts Available :(',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                                'Looks like we don\'t have any posts to show you at the moment. But no worries, we\'ll notify you once we upload new ones. Stay tuned!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 13))
                          ],
                        ),
                      ],
                    ));
                  }
                  return SizedBox.expand(
                      child: MasonryGridView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemBuilder: ((context, index) {
                      return MyFramePics(
                        frameImages: streamSnapshot.data!.docs[
                                streamSnapshot.data!.docs.length - (index + 1)]
                            ['Post Image'],
                      );
                    }),
                  ));
                }
                return Center(child: Text('An error occured'));
              }),
            ),
          )
        ],
      ),
    );
  }
}
