import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/components/my_containers/my_feedContainers.dart';
import 'package:firebase_practice/components/my_containers/my_savedItemsContainers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/model.dart';
import '../../routes/cart_page.dart';

class Discover extends StatelessWidget {
  Discover({super.key});

  final CollectionReference feed =
      FirebaseFirestore.instance.collection('feed');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        const SizedBox(height: 15),
        Expanded(
            child: StreamBuilder(
                stream: feed.snapshots(),
                builder: (context, streamSnapshot) {
                  if (streamSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                          color: Colors.deepPurple[600]),
                    );
                  } else if (streamSnapshot.hasData) {
                    int documentLength = streamSnapshot.data!.docs.length;
                    if (streamSnapshot.data!.docs.length == 0) {
                      return SizedBox.expand(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset('lib/assets/no_discover.png'),
                          Column(
                            children: [
                              Text('Nothing to Discover at the Moment :(',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  'Exciting things are happening and updates are on the way! Stay tuned for the latest news and happenings, and get ready to be blown away.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 13))
                            ],
                          ),
                        ],
                      ));
                    }
                    return SizedBox.expand(
                      child: ListView.builder(
                        itemCount: documentLength,
                        itemBuilder: (context, index) {
                          return MyFeedContainers(
                            feedTitle: streamSnapshot.data!.docs[index]
                                ['feedTitle'],
                            feedImagePath: streamSnapshot.data!.docs[index]
                                ['feedImagePath'],
                            feedContent: streamSnapshot.data!.docs[index]
                                ['feedContent'],
                            feedExpriration: streamSnapshot.data!.docs[index]
                                ['feedExpiration'],
                            feedTime: streamSnapshot
                                .data!.docs[index]['timeCreated']
                                .toDate(),
                          );
                        },
                      ),
                    );
                  } else if (!streamSnapshot.hasData) {
                    return Center(
                      child: Text('No Feed Yet'),
                    );
                  } else {
                    return Center(child: Text('An error Occured'));
                  }
                }))
      ]),
    );
  }
}
