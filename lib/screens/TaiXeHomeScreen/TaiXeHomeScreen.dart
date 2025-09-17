import 'package:flutter/material.dart';
import './TaxiXe_TripListScreen.dart';
import './Taixe_CompletedTripsScreen.dart';
import './Taixe_NotificationsScreen.dart';
import './Taixe_Info_Screen.dart';

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
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _screens = [
    TripListScreen(),
    CompletedTripsScreen(),
    NotificationScreen(),
    Center(child: Text("Mở menu cài đặt để xem chi tiết")),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleMenuAction(String value) {
    if (value == "info") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DriverInfoScreen()),
      );
    } else if (value == "logout") {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
            (Route<dynamic> route) => false,
      );
    }
  }


  void _showSettingsMenu(BuildContext context, Offset offset) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final value = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          offset,
          offset,
        ),
        Offset.zero & overlay.size,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      items: [
        PopupMenuItem(
          value: "info",
          child: Row(
            children: [
              Icon(Icons.person, color: Colors.blue),
              SizedBox(width: 8),
              Text("Thông tin tài xế"),
            ],
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          value: "logout",
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 8),
              Text("Đăng xuất"),
            ],
          ),
        ),
      ],
    );

    if (value != null) _handleMenuAction(value);
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
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  final RenderBox button = context.findRenderObject() as RenderBox;
                  final Offset offset = button.localToGlobal(
                    button.size.bottomRight(Offset.zero),
                  );
                  _showSettingsMenu(context, offset);
                },
              );
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
