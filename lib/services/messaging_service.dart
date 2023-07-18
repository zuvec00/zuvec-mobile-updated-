import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MessagingService {
  String mtoken = 'd';

  // R E Q U E S T  P E R M I S S I O N
  void requestPermission() async {
    //get instance
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    //request Notification Permission
    NotificationSettings settings = await messaging.requestPermission();

    //End-User Handling
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User declined or has not accepted permission");
    }
  }

  initInfo() async {
    var andriodInitialize =
        const AndroidInitializationSettings('@mippmap/zuvec');
    //var iOSInitialize = const IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: andriodInitialize);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("....................onMessage...................");
      print(
          "onMessage: ${message.notification?.title}/ ${message.notification?.body}");

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(),
          htmlFormatContentTitle: true);
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'zuvec',
        'zuvec',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
      );
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
          message.notification!.body, platformChannelSpecifics,
          payload: message.data['body']);
    });
  }
}
