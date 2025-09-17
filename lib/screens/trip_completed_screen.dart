import 'package:flutter/material.dart';
import '../models/ride.dart';
import '../services/api_service.dart';
import '../utils/format_Currency.dart';
import '../widgets/ride_item.dart';
import '../components/Driver_Map_View.dart';

class TripCompletedScreen extends StatefulWidget {
  const TripCompletedScreen({super.key});

  @override
  State<TripCompletedScreen> createState() => _TripCompletedScreenState();
}

class _TripCompletedScreenState extends State<TripCompletedScreen> {
  late Future<List<Ride>> futureRides;

  @override
  void initState() {
    super.initState();
    futureRides = ApiService.fetchRides();
  }

  Future<void> _refresh() async {
    final rides = ApiService.fetchRides();
    setState(() {
      futureRides = rides;
    });
    await rides; // 👈 cần await để RefreshIndicator chạy đúng
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chuyến xe đã hoàn thành")),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Ride>>(
          future: futureRides,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("❌ Lỗi: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("🚗 Không có chuyến xe nào"));
            } else {
              final rides = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: rides.length,
                itemBuilder: (context, index) {
                  final ride = rides[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DriverMapView(ride: ride),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "${ride.startLocation} → ${ride.endLocation}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            /// Info
                            Row(
                              children: [
                                const Icon(Icons.person,
                                    size: 18, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text("Tài xế: ${ride.driver}"),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.directions_car,
                                    size: 18, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text("Xe: 30A-22221"),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.attach_money,
                                    size: 18, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text("Giá: ${formatCurrency(40000)}"),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.access_time,
                                    size: 18, color: Colors.grey),
                                const SizedBox(width: 6),
                                const Text("Hoàn thành"),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DriverMapView(ride: ride),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.info_outline,
                                      size: 18, color: Colors.blue),
                                  label: const Text("Chi tiết"),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
