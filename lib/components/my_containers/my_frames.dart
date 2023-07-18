import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/model.dart';

class Frames extends StatefulWidget {
  final int index;
  final int? likeCount;
  final List postImages;
  final String postComment;

  const Frames({
    super.key,
    required this.index,
    this.likeCount,
    required this.postImages,
    required this.postComment,
  });

  @override
  State<Frames> createState() => _FramesState();
}

class _FramesState extends State<Frames> with SingleTickerProviderStateMixin {
  late bool likedState;
  bool initialized = false;
  bool showFullText = false;
  bool trans = false;
  final PageController _pageController = PageController();

  late String like_s;
  late List postImages;
  late AnimationController _lottieController;

  void showFullTextHandler() {
    if (!showFullText) {
      setState(() {
        showFullText = true;
      });
    } else {
      setState(() {
        showFullText = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    postImages = widget.postImages;
    if (widget.likeCount == 0 || widget.likeCount == 1) {
      setState(() {
        like_s = 'like';
      });
    } else {
      setState(() {
        like_s = 'likes';
      });
    }

    if (Provider.of<Model>(context, listen: false)
            .functionCalledHander2(widget.index) ==
        false) {
      Provider.of<Model>(context, listen: false)
          .addLikedItem(widget.index, false);
    }

    Provider.of<Model>(context, listen: false).refreshLikedItems();
    likedState =
        Provider.of<Model>(context, listen: false).getLikedState(widget.index);

    _lottieController = AnimationController(
        vsync: this,
        value: likedState ? 1 : 0,
        duration: Duration(milliseconds: 1000));
  }

  void dipsose() {
    super.dispose();
    _lottieController.dispose();
  }

  Widget build(BuildContext context) {
    final DocumentReference fashionFrames = FirebaseFirestore.instance
        .collection('fashionFrames')
        .doc('${widget.index + 1}');

    void likeIncrement() {
      fashionFrames.update({'Like Count': FieldValue.increment(1)});
    }

    void likeDecrement() {
      fashionFrames.update({'Like Count': FieldValue.increment(-1)});
    }

    return Consumer<Model>(
        builder: (context, value, child) => Container(
            margin: const EdgeInsets.symmetric(vertical: 7.5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(alignment: Alignment.bottomCenter, children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      // height: MediaQuery.of(context).size.width,
                      // width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(15)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7.5),
                        child: PageView.builder(
                            itemCount: postImages.length,
                            itemBuilder: (context, index) {
                              return CachedNetworkImage(
                                  imageUrl: postImages[index],
                                  placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(
                                            color: Colors.deepPurple[600]),
                                      ),
                                  errorWidget: (context, url, error) => Icon(
                                      Icons.error_outline_rounded,
                                      color: Colors.red));
                            }),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SmoothPageIndicator(
                        controller: _pageController,
                        count: postImages.length,
                        effect: ExpandingDotsEffect(
                            expansionFactor: 4,
                            dotWidth: 8,
                            dotHeight: 8,
                            activeDotColor: Colors.deepPurple[600]!,
                            dotColor: Colors.grey[500]!)),
                  ),
                ]),
                const SizedBox(height: 10),
                Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Expanded(child: Row(children: [const SizedBox(width: 10),
                    const Text(
                      'luchi ',
                      style: TextStyle(
                          fontSize: 13.5, fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: showFullTextHandler,
                        child: Text(widget.postComment,
                            overflow: showFullText
                                ? TextOverflow.clip
                                : TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 13.5)),
                      ),
                    ),]),),
                    
                    
                    /* InkWell(
                        onTap: () {
                          if (value.userLikedItems[widget.index]['likedItem'] ==
                              false) {
                            _lottieController.forward();
                            likeIncrement();
                            Provider.of<Model>(context, listen: false)
                                .addLikedItem(widget.index, true);
                          } else {
                            _lottieController.reverse();
                            likeDecrement();
                            Provider.of<Model>(context, listen: false)
                                .addLikedItem(widget.index, false);
                          }
                          print(
                              'userLiked:${value.userLikedItems[widget.index]['likedItem']}');
                        },
                        child: Lottie.asset(
                            controller: _lottieController,
                            'lib/assets/like_anim.json',
                            width: 75)),*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        CallButton(),
                        SizedBox(width: 5),
                        ChatButton()
                      ],
                    )
                  ],
                ),
               /*Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: InkWell(
                    onTap: () {
                      Provider.of<Model>(context, listen: false)
                          .removeAllLikedItem();
                    },
                    child: Text('${widget.likeCount} $like_s',
                        style: const TextStyle(
                            fontSize: 13.5, fontWeight: FontWeight.bold)),
                  ),
                ),*/
                
                
              ],
            )));
  }
}

class ChatButton extends StatelessWidget {
  const ChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        launchUrl(Uri.parse(
            'whatsapp://send?phone=+2348037772022'));
      },
      radius: 25,
      splashColor: Colors.grey,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.deepPurple[600]),
          child: Row(
            children: const [
              Icon(Icons.chat_rounded, size: 16, color: Colors.white),
             /* SizedBox(
                width: 8,
              ),
              Text('Chat with Luchi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                  ))*/
            ],
          )),
    );
  }
}

class CallButton extends StatelessWidget {
  const CallButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      radius: 25,
      splashColor: Colors.grey,
      onTap: () {
        launchUrl(Uri.parse('tel://08160287793'));
      },
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
             // border: Border.all(color: Colors.grey[900]!, width: 1.5)
              ),
          child: Icon(Icons.phone_rounded, size: 22, color: Colors.deepPurple[600])),
    );
  }
}
