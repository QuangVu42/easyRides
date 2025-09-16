import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/ride.dart';

class DriverMapView extends StatefulWidget {
  final Ride ride;

  const DriverMapView({super.key, required this.ride});

  @override
  _DriverMapViewState createState() => _DriverMapViewState();
}

class _DriverMapViewState extends State<DriverMapView> {
  final String orsApiKey = dotenv.env['APP_ORS_API_KEY'] ?? '';

  final List<LatLng> points = [
    LatLng(21.0285, 105.8542),
    LatLng(21.0274, 105.8355),
    LatLng(21.0379, 105.8342),
    LatLng(21.0110, 105.8409),
    LatLng(21.0285, 105.7780),
  ];

  List<List<LatLng>> _segmentRoutes = [];

  @override
  void initState() {
    super.initState();
    _getRoute();
  }

  Future<void> _getRoute() async {
    try {
      final url = Uri.parse(
        "https://api.openrouteservice.org/v2/directions/driving-car/geojson",
      );

      final coordinates = points.map((p) => [p.longitude, p.latitude]).toList();

      final response = await http.post(
        url,
        headers: {
          "Authorization": orsApiKey,
          "Content-Type": "application/json",
        },
        body: jsonEncode({"coordinates": coordinates}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List coords =
        data["features"][0]["geometry"]["coordinates"] as List;

        final fullRoute =
        coords.map((c) => LatLng(c[1], c[0])).toList(); // [lon,lat]→LatLng

        List<List<LatLng>> segments = [];
        int step = (fullRoute.length / (points.length - 1)).floor();
        for (int i = 0; i < points.length - 1; i++) {
          int startIdx = i * step;
          int endIdx =
          (i == points.length - 2) ? fullRoute.length - 1 : (i + 1) * step;
          segments.add(fullRoute.sublist(startIdx, endIdx + 1));
        }

        setState(() {
          _segmentRoutes = segments;
        });
      } else {
        print("Lỗi ORS: ${response.body}");
      }
    } catch (e) {
      print("Lỗi lấy route: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final ride = widget.ride;

    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết chuyến: ${ride.code}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // 👉 nút quay lại
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Thông tin chuyến đi
          Padding(
            padding: const EdgeInsets.all(11.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 👈 căn trái
              children: [
                Text("Tài xế: ${ride.driver}", style: const TextStyle(fontSize: 16)),
                Text("Giá vé: ${ride.price} VND", style: const TextStyle(fontSize: 16)),
                Text("Điểm đi: ${ride.startLocation}", style: const TextStyle(fontSize: 16)),
                Text("Điểm đến: ${ride.endLocation}", style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: points.first,
                initialZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                if (_segmentRoutes.isNotEmpty)
                  PolylineLayer(
                    polylines: _segmentRoutes.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final segment = entry.value;
                      return Polyline(
                        points: segment,
                        strokeWidth: 4,
                        color: Colors.primaries[idx % Colors.primaries.length],
                      );
                    }).toList(),
                  ),
                MarkerLayer(
                  markers: points.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final p = entry.value;

                    if (idx == 0) {
                      return Marker(
                        point: p,
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.location_on,
                            color: Colors.green, size: 35),
                      );
                    } else if (idx == points.length - 1) {
                      return Marker(
                        point: p,
                        width: 40,
                        height: 40,
                        child:
                        const Icon(Icons.flag, color: Colors.red, size: 35),
                      );
                    } else {
                      return Marker(
                        point: p,
                        width: 30,
                        height: 30,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.circle,
                              color: Colors.orange.withOpacity(0.8),
                              size: 26,
                            ),
                            Text(
                              "$idx",
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
