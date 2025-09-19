import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import './screens/trip_list_screen.dart';
import './screens/settings_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './utils/http_client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import './firebase_options.dart';

// Hàm này xử lý khi có noti lúc app background/terminated
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  HttpClient.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Lắng foreground noti
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Foreground message: ${message.notification?.title}");
  });

  FirebaseMessaging.instance.getToken().then((token) {
    print("FCM Token: $token");
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("User opened app from notification: ${message.notification?.title}");
  });

  runApp(TripBiddingApp());
}

class TripBiddingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip Bidding App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/trips': (context) => TripListScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}
