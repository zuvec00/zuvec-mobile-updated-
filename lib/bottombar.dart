import 'package:firebase_practice/screens/feed.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:fluentui_icons/fluentui_icons.dart';

import 'screens/account.dart';
import 'screens/home.dart';
import 'tabScreens/feedTabbars/discover.dart';
import 'screens/saved.dart';

class MyBottomBar extends StatefulWidget {
  final String? category;
  final int? index;
  const MyBottomBar({
    super.key,
    this.category,
    this.index,
  });

  @override
  State<MyBottomBar> createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {
  int currentIndex =  0;
  @override
  Widget build(BuildContext context) {
    
    List<Widget> screenPages = [
      Home(category: widget.category ?? 'Ready 2 Wear'),
      Saved(),
      const Feed(),
      Account(),
    ];

    return Scaffold(
      body: screenPages[widget.index??currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.grey[100], boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 5,
              spreadRadius: 0,
              offset: Offset(-4, -4))
        ]),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 15),
          child: GNav(
              selectedIndex: currentIndex,
              onTabChange: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              gap: 5,
              backgroundColor: Colors.grey[100]!,
              activeColor: Colors.grey[100]!,
              tabBackgroundColor: Colors.grey[900]!,
              padding: const EdgeInsets.all(16),
              tabBorderRadius: 100,
              color: Colors.grey[900]!,
              tabs: [
                GButton(
                    icon: currentIndex == 0
                        ? FluentSystemIcons.ic_fluent_home_filled
                        : FluentSystemIcons.ic_fluent_home_regular,
                    text: 'Home'),
                GButton(
                    icon: currentIndex == 1
                        ? FluentSystemIcons.ic_fluent_heart_filled
                        : FluentSystemIcons.ic_fluent_heart_regular,
                    text: 'Wishlist'),
                GButton(
                    icon: currentIndex == 2
                        ? Icons.rss_feed_rounded
                        : Icons.rss_feed_outlined,
                    text: 'Feed'),
                GButton(
                    icon: currentIndex == 3
                        ? FluentSystemIcons.ic_fluent_person_filled
                        : FluentSystemIcons.ic_fluent_person_regular,
                    text: 'Account'),
              ]),
        ),
      ),
    );
  }
}
