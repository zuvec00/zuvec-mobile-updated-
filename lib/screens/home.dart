import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/components/my_containers/my_tabBar_container.dart';
import 'package:firebase_practice/routes/cart_page.dart';
import 'package:firebase_practice/tabScreens/watches.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../components/my_containers/my_searchBar.dart';
import '../provider/model.dart';
import '../routes/dialogRoutes/filter_route.dart';
import '../routes/dialogRoutes/search_route.dart';
import '../services/database_service.dart';
import '../tabScreens/crocs.dart';
import '../tabScreens/footwear.dart';
import '../tabScreens/all_luchi.dart';
import '../tabScreens/luchi_material.dart';
import '../tabScreens/testtab.dart';

class Home extends StatefulWidget {
  String? firstName;
  String? category;
  Home({
    super.key,
    this.firstName,
    this.category,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //get current user ID
  late String greeting;

  late String category;
  bool hasInternet = true;
  bool _searchPressed = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  Map<String, dynamic> searchFilter = {
    'Ready 2 Wear': ['watchesCatalaog', 'ready_2_wear'],
    'Ankara Materials': ['luchiMaterialsCatalog', 'ankara_material'],
    'Watches': ['watchesCatalogFr', 'watches'],
    'Footwear': ['footwearCatalog','footwear']
  };

  String _getCurrentUserId() {
    final currentUser = FirebaseAuth.instance.currentUser!;
    String userID = currentUser.uid;
    return userID;
  }

  String _getGreeting() {
    int hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  void filterHandler() {
    showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return MyFilterPage();
        });
  }

  void searchProducts() {
    showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return MySearchPage(
            productID: searchFilter[category][1],
            collectionName: searchFilter[category][0],
            searchQuery: _searchQuery,
          );
        });
  }

  void searchPressedHandler() {
    setState(() {
      _searchPressed = !_searchPressed;
    });
  }

  void initState() {
    super.initState();

    checkInternetConnectivity();

    setState(() {
      greeting = _getGreeting();
    });

    setState(() {
      category = widget.category ?? 'Ready 2 Wear';
    });
  }

  Future<void> checkInternetConnectivity() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();

    print('Connectivity Result: ${ConnectivityResult.values}');
    if (connectivityResult == ConnectivityResult.none) {
      print('Connectivity Result: ${ConnectivityResult.none}');
      setState(() {
        hasInternet = false;
      });

      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: Colors.red[400]!,
        margin: const EdgeInsets.only(top: 0),
        duration: Duration(seconds: 2),
        icon: Icon(FluentSystemIcons.ic_fluent_wifi_1_filled,
            color: Colors.white),
        messageText: Text(
            "No internet connection. Please check your network settings.",
            style: GoogleFonts.quicksand(color: Colors.white)),
      )..show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final searchFilterCollection =
        FirebaseFirestore.instance.collection(searchFilter[category][0]);
    final DocumentReference cartDocumentRef = FirebaseFirestore.instance
        .collection('usersCartProducts')
        .doc(_getCurrentUserId());
    final CollectionReference cartSubCollection =
        cartDocumentRef.collection('user_cart_item');

    return Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          elevation: 0,
          automaticallyImplyLeading: false,
          // leading: Icon(Icons.menu_rounded, color: Colors.grey[900]),
          title: Text('Z U V E C',
              style: GoogleFonts.quicksand(color: Colors.grey[900])),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Consumer<Model>(
                builder: (context, value, child) => Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => Cart())));
                        },
                        icon: Icon(Icons.shopping_bag_outlined,
                            color: Colors.grey[900])),
                    Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0xFF5E35B1),
                          shape: BoxShape.circle,
                        ),
                        child: FutureBuilder<int>(
                          future: DatabaseService(uID: _getCurrentUserId())
                              .getTotalNoOfCartItems(cartSubCollection),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text('...',
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.grey[100],
                                      fontSize: 13.5));
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Text(
                                '${snapshot.data}',
                                style: TextStyle(color: Colors.grey[100]),
                              );
                            }
                          },
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: DefaultTabController(
          length: 4,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.5),
            child:
                // ignore: prefer_const_literals_to_create_immutables
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              GestureDetector(
                  onTap: () {
                    print('sth:${size.height}, ${size.width}');
                  },
                  child: Row(children: [
                    Text('Hello ',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    FutureBuilder<String>(
                      future: DatabaseService(uID: _getCurrentUserId())
                          .getUserFirstName(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text('...',
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.grey[100],
                                  fontSize: 13.5));
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Text(
                            '${snapshot.data},',
                            style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          );
                        }
                      },
                    ),
                  ])),
              Text('What are you buying today?',
                  style: TextStyle(fontSize: 13.5, color: Colors.grey[600])),
              const SizedBox(
                height: 15,
              ),
              /*Divider(
                indent: 15,
                endIndent: 15,
              ),*/
              Row(
                children: [
                  Expanded(
                    child: CupertinoSearchTextField(
                      controller: _searchController,
                      onSubmitted: (query) {
                        setState(() {
                          _searchQuery = query.trim();
                        });

                        print('category:$category');

                        if (!_searchPressed) {
                          searchPressedHandler();
                          print(
                              'after searchPressed when search button tapped: $_searchPressed');
                        }
                        print('User search the item: $query');

                        searchProducts();
                      },
                      onSuffixTap: () {
                        _searchController.clear();
                        if (_searchPressed) {
                          searchPressedHandler();
                          print('search pressed when cleared: $_searchPressed');
                        }
                      },
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      backgroundColor: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                      prefixIcon: Icon(
                          FluentSystemIcons.ic_fluent_search_regular,
                          size: 26,
                          color: Colors.grey[900]),
                      suffixIcon: const Icon(
                          FluentSystemIcons.ic_fluent_dismiss_circle_regular),
                      placeholder: 'Search in ${category}...',
                      placeholderStyle: GoogleFonts.quicksand(
                          fontSize: 14, color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: filterHandler,
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.grey[900], shape: BoxShape.circle),
                        child: Icon(FluentSystemIcons.ic_fluent_filter_filled,
                            color: Colors.grey[100])),
                  )
                ],
              ),
              SizedBox(height: 15),
              Expanded(child: MyTabBar())
            ]),
          ),
        ));
  }
}

// M Y  C U S T O M  T A B B A R  W I D G E T
class MyTabBar extends StatefulWidget {
  const MyTabBar({super.key});

  @override
  State<MyTabBar> createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  late AnimationController _animationController;

  void initState() {
    super.initState;
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    Provider.of<Model>(context, listen: false).refreshCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
            isScrollable: true,
            indicatorColor: Colors.transparent,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            labelStyle: GoogleFonts.quicksand(),
            unselectedLabelStyle: GoogleFonts.quicksand(),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              MyTabBarContainer(
                  icon: Icons.watch_rounded,
                  tabName: 'Ready 2 Wear ',
                  color: currentIndex == 0
                      ? Colors.grey[900]!
                      : Colors.transparent,
                  textColor:
                      currentIndex == 0 ? Colors.grey[100]! : Colors.grey[900]!,
                  textDecoration: currentIndex == 0,
                  borderColor: currentIndex == 0
                      ? Colors.grey[900]!
                      : Colors.grey[600]!),
              MyTabBarContainer(
                icon: Icons.watch_rounded,
                tabName: 'Ankara Materials ',
                color:
                    currentIndex == 1 ? Colors.grey[900]! : Colors.transparent,
                textColor:
                    currentIndex == 1 ? Colors.grey[100]! : Colors.grey[900]!,
                borderColor:
                    currentIndex == 1 ? Colors.grey[900]! : Colors.grey[600]!,
                textDecoration: currentIndex == 1,
              ),
              MyTabBarContainer(
                icon: Icons.outlined_flag,
                tabName: 'Watches ',
                color:
                    currentIndex == 2 ? Colors.grey[900]! : Colors.transparent,
                textColor:
                    currentIndex == 2 ? Colors.grey[100]! : Colors.grey[900]!,
                borderColor:
                    currentIndex == 2 ? Colors.grey[900]! : Colors.grey[600]!,
                textDecoration: currentIndex == 2,
              ),
              MyTabBarContainer(
                  icon: Icons.favorite_outline_rounded,
                  tabName: 'Footwear ',
                  textDecoration: currentIndex == 3,
                  color: currentIndex == 3
                      ? Colors.grey[900]!
                      : Colors.transparent,
                  textColor:
                      currentIndex == 3 ? Colors.grey[100]! : Colors.grey[900]!,
                  borderColor: currentIndex == 3
                      ? Colors.grey[900]!
                      : Colors.grey[600]!),
            ]),
        const SizedBox(height: 15),
        Expanded(
            child: TabBarView(children: [
          Luchi(),
          LuchiMaterials(),
          Watches(),
          Sneakers(),
          //Crocs(),
          //TestTab()
        ]))
      ],
    );
  }
}
