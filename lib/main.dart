import 'package:firebase_practice/provider/model.dart';
import 'package:firebase_practice/routes/accountRoutes/appRating.dart';
import 'package:firebase_practice/routes/accountRoutes/contactSupport.dart';
import 'package:firebase_practice/routes/accountRoutes/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/auth_page.dart';

//external packages
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'routes/accountRoutes/wishlist_test.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //set portrait orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //initialize hive
  await Hive.initFlutter();

  //open box
  await Hive.openBox('currentUserSavedItems');
  await Hive.openBox('currentUserCartItemsNew');
  await Hive.openBox('currentUserShippingAddressDetails');
  await Hive.openBox('currentUserOrderHistory');
  await Hive.openBox('userLikedItems');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Model(),
        )
      ],
      child: MaterialApp(
        routes: {
          '/preferences': (context) => Preferences(),
          '/contactSupport': (context) => ContactSupport(),
          '/appRating': (context) => AppRating(),
          '/wishlist_test':(context)=> WishlistTest()
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.grey,
            textTheme: TextTheme(
                bodyMedium: GoogleFonts.quicksand(
                    fontSize: 16, color: Colors.grey[900]))),
        home: AuthPage(),
      ),
    );
  }
}
