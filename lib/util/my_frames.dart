import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyFramePics extends StatelessWidget {
  final String frameImages;
  const MyFramePics({super.key, required this.frameImages});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
              imageUrl: frameImages,
              placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                        color: Colors.deepPurple[600]),
                  ),
              errorWidget: (context, url, error) =>
                  Icon(Icons.error_outline_rounded, color: Colors.red))),
    ]);
  }
}
