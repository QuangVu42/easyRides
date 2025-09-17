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
import '../utils/countdown_Text.dart';

// ================= Trip List Screen =================
class TripListScreen extends StatefulWidget {
  @override
  _TripListScreenState createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  List<Trip> _getTripsForStatus(TripStatus status) {
    return MockDataService.trips
        .where((trip) => trip.status == status)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final user = MockDataService.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chuyến đi', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Center(
              child: Text(
                'Điểm: ${user.points}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                    '3',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
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
                    '/login',
                        (Route<dynamic> route) => false,
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'settings', child: Text('Cài đặt')),
              PopupMenuItem(value: 'screen1', child: Text('Thông tin')),
              PopupMenuItem(value: 'screen2', child: Text('Lịch sử')),
              PopupMenuItem(value: 'screen3', child: Text('Đăng xuất')),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black54,
          indicatorColor: Colors.blue,
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

// ================= Trip Tab View =================
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

// ================= Trip Card =================
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
        screen = PendingScreen(trip: trip);
        break;
      case TripStatus.canceled:
        return;
    }
    if (screen != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => screen!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateByStatus(context),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER: From → To + Countdown
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.blueAccent),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${trip.fromLocation} → ${trip.toLocation}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              // Countdown nổi bật dạng chip
              if(trip.status == TripStatus.bidding || trip.status == TripStatus.pending)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CountdownText(endTime: trip.biddingEndTime),
              ),

              /// INFO
              _infoRow(Icons.access_time,
                  'Đón: ${DateFormatter.format(trip.startTime, 'HH:mm dd/MM/yyyy')}'),
              _infoRow(Icons.people, 'Số người: ${trip.participantCount}'),
              if (trip.vehicleType != null)
                _infoRow(Icons.directions_car, 'Xe: ${trip.vehicleType}'),
              if (trip.notes != null)
                _infoRow(Icons.note, 'Ghi chú: ${trip.notes}'),

              Divider(height: 20),

              /// FOOTER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Giá yêu cầu',
                          style: TextStyle(
                              fontSize: 13, color: Colors.black54)),
                      Text(
                        formatCurrency(trip.requestedPrice),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (trip.bidPrice != null && trip.status != TripStatus.canceled)
                        Text(
                          'Ra giá: ${formatCurrency(trip.bidPrice!)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                  if (trip.status == TripStatus.bidding)
                    ElevatedButton.icon(
                      onPressed: () => _navigateByStatus(context),
                      icon: Icon(Icons.gavel, size: 18),
                      label: Text("Ra giá"),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
