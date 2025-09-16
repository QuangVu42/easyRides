import 'package:flutter/material.dart';
import '../models/Trip.dart';
import '../services/MockDataService.dart';
import './settings_screen.dart';
import './bidding_screen.dart';
import './trip_detail_screen.dart';
import './trip_completed_screen.dart';
import '../utils/format_Currency.dart';
import '../utils/date_formatter.dart';
import '../screens/pending_Screen.dart';
import './trip_accepted_screen.dart';
import './trip_running_screen.dart';
import './Agent_info_screen.dart';
import './point_history_screen.dart';
import '../components/notification_Screen.dart';
// Trip List Screen
class TripListScreen extends StatefulWidget {
  @override
  _TripListScreenState createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  List<Trip> _getTripsForStatus(TripStatus status) {
    return MockDataService.trips.where((trip) => trip.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    final user = MockDataService.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chuyến đi'),
        actions: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Điểm: ${user.points}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationScreen()),
                  );
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '3', // số thông báo (có thể lấy từ API)
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),

          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert), // Icon 3 chấm
            onSelected: (value) {
              switch (value) {
                case 'settings':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                  break;
                case 'screen1':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AgentInfoScreen()),
                  );
                  break;
                case 'screen2':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PointHistoryScreen()),
                  );
                  break;
                case 'screen3':
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',   // route name đã khai báo trong MaterialApp
                        (Route<dynamic> route) => false,
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'settings',
                child: Text('Cài đặt'),
              ),
              PopupMenuItem(
                value: 'screen1',
                child: Text('Thông tin'),
              ),
              PopupMenuItem(
                value: 'screen2',
                child: Text('Lịch sử'),
              ),
              PopupMenuItem(
                value: 'screen3',
                child: Text('Đăng xuất'),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: 'Chuyến'),
            Tab(text: 'Chờ duyệt'),
            Tab(text: 'Đã nhận'),
            Tab(text: 'Đang chạy'),
            Tab(text: 'Hoàn thành'),
            Tab(text: 'Hủy'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TripTabView(trips: _getTripsForStatus(TripStatus.bidding)),
          TripTabView(trips: _getTripsForStatus(TripStatus.pending)),
          TripTabView(trips: _getTripsForStatus(TripStatus.accepted)),
          TripTabView(trips: _getTripsForStatus(TripStatus.running)),
          TripTabView(trips: _getTripsForStatus(TripStatus.completed)),
          TripTabView(trips: _getTripsForStatus(TripStatus.canceled)),
        ],
      ),
    );
  }
}

class TripTabView extends StatelessWidget {
  final List<Trip> trips;

  TripTabView({required this.trips});

  @override
  Widget build(BuildContext context) {
    if (trips.isEmpty) {
      return Center(child: Text('Không có chuyến đi nào'));
    }

    return ListView.builder(
      itemCount: trips.length,
      itemBuilder: (context, index) {
        return TripCard(trip: trips[index]);
      },
    );
  }
}

class TripCard extends StatelessWidget {
  final Trip trip;

  TripCard({required this.trip});

  void _navigateByStatus(BuildContext context) {
    Widget? screen;
    switch (trip.status) {
      case TripStatus.bidding:
        screen = BiddingScreen(trip: trip);
        break;
      case TripStatus.accepted:
        screen = AcceptedScreen(trip: trip);
        break;
      case TripStatus.running:
        screen = RunningScreen(trip: trip);
        break;
      case TripStatus.completed:
        screen = TripCompletedScreen();
        break;
      case TripStatus.pending:
      // Placeholder: bạn có thể tạo PendingScreen riêng
      //   screen = Scaffold(
      //     appBar: AppBar(title: Text("Chờ duyệt")),
      //     body: Center(child: Text("Chuyến đi đang chờ duyệt...")),
      //   );
      screen = PendingScreen(trip: trip);
        break;
      case TripStatus.canceled:
        return;
    }

    if (screen != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => _navigateByStatus(context),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${trip.fromLocation} → ${trip.toLocation}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _getStatusChip(trip.status),
                ],
              ),
              SizedBox(height: 8),

              /// Info chung
               if (trip.status != TripStatus.completed)
              Text('Giá yêu cầu: ${formatCurrency(trip.requestedPrice)}'),
              if (trip.bidPrice != null)
                Text('Ra giá: ${formatCurrency(trip.bidPrice!)}'),
              Text('Thời gian đón: ${DateFormatter.format(trip.startTime, 'HH:mm dd/MM/yyyy')}'),
              Text('Hết hạn ra giá: ${DateFormatter.format(trip.biddingEndTime, 'HH:mm dd/MM/yyyy')}'),
              Text('Số người: ${trip.participantCount}'),
              if (trip.vehicleType != null) Text('Loại xe yêu cầu: ${trip.vehicleType}'),
              if (trip.notes != null) Text('Ghi chú: ${trip.notes}'),

            ],
          ),
        ),
      ),
    );
  }

  Widget _getStatusChip(TripStatus status) {
    Color color;
    String label;

    switch (status) {
      case TripStatus.bidding:
        color = Colors.blue;
        label = 'Ra giá';
        break;
      case TripStatus.pending:
        color = Colors.orange;
        label = 'Chờ duyệt';
        break;
      case TripStatus.accepted:
        color = Colors.green;
        label = 'Đã nhận';
        break;
      case TripStatus.running:
        color = Colors.purple;
        label = 'Đang chạy';
        break;
      case TripStatus.completed:
        color = Colors.grey;
        label = 'Hoàn thành';
        break;
      case TripStatus.canceled:
        return SizedBox.shrink();
    }

    return Chip(
      label: Text(label, style: TextStyle(color: Colors.white)),
      backgroundColor: color,
    );
  }
}
