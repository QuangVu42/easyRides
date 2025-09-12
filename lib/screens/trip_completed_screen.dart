import 'package:flutter/material.dart';
import '../models/ride.dart';
import '../services/api_service.dart';
import '../widgets/ride_item.dart';

class TripCompletedScreen extends StatefulWidget {
  const TripCompletedScreen({super.key});

  @override
  State<TripCompletedScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends State<TripCompletedScreen> {
  late Future<List<Ride>> futureRides;

  @override
  void initState() {
    super.initState();
    futureRides = ApiService.fetchRides();
  }

  Future<void> _refresh() async {
    setState(() {
      futureRides = ApiService.fetchRides();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Danh sách chuyến xe")),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Ride>>(
          future: futureRides,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Lỗi: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Không có chuyến xe nào"));
            } else {
              final rides = snapshot.data!;
              return ListView.builder(
                itemCount: rides.length,
                itemBuilder: (context, index) {
                  return RideItem(ride: rides[index], onAccepted: _refresh);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
