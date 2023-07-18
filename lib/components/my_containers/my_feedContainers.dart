import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyFeedContainers extends StatelessWidget {
  final String feedTitle;
  final String feedImagePath;
  final String feedContent;
  final String feedExpriration;
  final DateTime feedTime;

  const MyFeedContainers(
      {super.key,
      required this.feedTitle,
      required this.feedImagePath,
      required this.feedContent,
      required this.feedTime,
      required this.feedExpriration});

  String getTimeCreated() {
    final now = DateTime.now();
    final duration = now.difference(feedTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes;
    String relativeTime;

    if (hours > 0) {
      relativeTime =
          Intl.message("$hours hours ago", name: 'timeAgo', args: [hours]);
    } else {
      relativeTime = Intl.message("$minutes minutes ago",
          name: 'timeAgo', args: [minutes]);
    }
    return relativeTime;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        width: size.width,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(feedTitle, style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Divider(
              indent: 15,
              endIndent: 15,
            ),
            Center(
              child: Image.network(
                feedImagePath,
                height: 150,
              ),
            ),
            const Divider(
              indent: 15,
              endIndent: 15,
            ),
            const SizedBox(height: 10),
            Text(feedContent,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                )),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getTimeCreated(),
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                Text(
                  feedExpriration,
                  style: TextStyle(
                      color: Colors.deepPurple[600],
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        ));
  }
}
