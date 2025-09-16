import 'package:flutter/material.dart';
import './TaxiXe_TripListScreen.dart';
import './Taixe_CompletedTripsScreen.dart';
import './Taixe_NotificationsScreen.dart';
import './TaiXe_DriverSettingsScreen.dart';

class DriverHomePage extends StatefulWidget {
  final int initialIndex;
  const DriverHomePage({this.initialIndex = 0, Key? key}) : super(key: key);

  @override
  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // set tab mặc định
  }

  final List<Widget> _screens = [
    TripListScreen(),
    CompletedTripsScreen(),
    NotificationsScreen(),
    DriverSettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DriverHomePage(initialIndex: 0),
              ),
            );
          },
          child: Text("Tài xế"),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              setState(() => _selectedIndex = 2);
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              setState(() => _selectedIndex = 3);
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: "Chuyến đi",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: "Hoàn thành",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Thông báo",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Cài đặt",
          ),
        ],
      ),
    );
  }
}
