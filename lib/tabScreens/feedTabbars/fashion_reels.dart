import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../components/my_containers/my_reels.dart';

class FashionReels extends StatelessWidget {
  const FashionReels({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference fashionReelsRef =
        FirebaseFirestore.instance.collection('fashionReels');
    return Column(children: [
      Expanded(
        child: StreamBuilder(
            stream: fashionReelsRef.snapshots(),
            builder: ((context, streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child:
                      CircularProgressIndicator(color: Colors.deepPurple[600]),
                );
              } else if (streamSnapshot.hasData) {
                if (streamSnapshot.data!.docs.length == 0) {
                  return SizedBox.expand(
                      child: Column(
                    children: [
                      Image.asset('lib/assets/no_reels_fr.png'),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Sorry, No Videos Available :(',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                              'Looks like we\'re all out of videos at the moment. Don\'t worry though, we\'re working on getting more awesome content for you! Keep an eye out for future updates.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 13))
                        ],
                      ),
                      
                    ],
                  ));
                }
                return SizedBox.expand(
                  child: PageView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Reels(
                            postVideoUrl: streamSnapshot.data!.docs[
                                streamSnapshot.data!.docs.length -
                                    (index + 1)]['Video Url']);
                      }),
                );
              }
              return Center(child: Text('An error occured'));
            })),
      )
    ]);
  }
}
