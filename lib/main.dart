import 'package:boost_solutions/presentation/auth/login.dart';
import 'package:boost_solutions/presentation/home/Home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  _initializeLocalNotifications();
  await GetStorage.init();
  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
  _showNotification(message);
}

void _showNotification(RemoteMessage message) {
  const AndroidNotificationDetails androidNotificationDetails =
  AndroidNotificationDetails(
    'default_channel', // Channel ID
    'Default',         // Channel Name
    channelDescription: 'Default channel for notifications',
    importance: Importance.high,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);

  flutterLocalNotificationsPlugin.show(
    message.notification.hashCode,
    message.notification?.title ?? 'No Title',
    message.notification?.body ?? 'No Body',
    notificationDetails,
  );
}

void _initializeLocalNotifications() {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<bool> checkLoggedInStatus() async {
    final GetStorage storage = GetStorage();
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('count') ?? "";
    if(token!=""){
      await storage.write("token", token);
    }
    return await storage.read('token') != null;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.requestPermission();
    _subscribeToTopic();
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground Message: ${message.notification?.title}");
      // Show notification, or update the UI based on the message
      _showNotification(message);
    });


  }

  void _showNotification(RemoteMessage message) {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'default_channel', // Channel ID
      'Default',         // Channel Name
      channelDescription: 'Default channel for notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      notificationDetails,
    );
  }


  void _subscribeToTopic() {
    const topic = "news"; // Replace "news" with your topic name
    _firebaseMessaging.subscribeToTopic(topic).then((_) {
      print("Subscribed to topic: $topic");
    }).catchError((error) {
      print("Error subscribing to topic: $error");
    });
  }


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Boost Solutions',
          home: FutureBuilder<bool>(
            future: checkLoggedInStatus(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loading screen while waiting for token
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasData && snapshot.data == true) {
                // Navigate to HomeScreen if logged in
                return const HomeScreen();
              }

              // Default to login screen
              return const LogIn();
            },
          ),
        );
      },
    );
  }
}

