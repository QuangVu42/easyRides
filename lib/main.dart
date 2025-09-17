import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import './screens/trip_list_screen.dart';
import './screens/settings_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './utils/http_client.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  HttpClient.init();
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


