import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class TripDetailScreen extends StatefulWidget {
  final Map<String, String> trip;

  TripDetailScreen({required this.trip});

  @override
  _TripDetailScreenState createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  bool pickedUp = false;
  bool started = false;

  List<TextEditingController> extraCostControllers = [TextEditingController()];

  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  Set<Marker> _markers = {};
  List<LatLng> _polylineCoordinates = [];
  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng bật GPS")),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Quyền vị trí bị từ chối vĩnh viễn")),
      );
      return;
    }

    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = LatLng(pos.latitude, pos.longitude);
      _polylineCoordinates.add(_currentPosition!);
      _markers.add(Marker(
        markerId: MarkerId("driver"),
        position: _currentPosition!,
        infoWindow: InfoWindow(title: "Tài xế"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    });

    _mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition!));

    _positionStream =
        Geolocator.getPositionStream(locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        )).listen((Position pos) {
          LatLng newPos = LatLng(pos.latitude, pos.longitude);

          setState(() {
            _currentPosition = newPos;
            _polylineCoordinates.add(newPos);

            _markers.removeWhere((m) => m.markerId.value == "driver");
            _markers.add(Marker(
              markerId: MarkerId("driver"),
              position: _currentPosition!,
              infoWindow: InfoWindow(title: "Tài xế"),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            ));
          });

          _mapController?.animateCamera(CameraUpdate.newLatLng(newPos));
        });
  }

  void _addExtraCostField() {
    setState(() {
      extraCostControllers.add(TextEditingController());
    });
  }

  void _removeExtraCostField(int index) {
    setState(() {
      extraCostControllers[index].dispose();
      extraCostControllers.removeAt(index);
    });
  }

  @override
  void dispose() {
    for (var c in extraCostControllers) {
      c.dispose();
    }
    _positionStream?.cancel();
    super.dispose();
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 22),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "$label: $value",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;

    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết chuyến đi"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoRow(Icons.location_on, "Từ", trip['from'] ?? ""),
                          _infoRow(Icons.flag, "Đến", trip['to'] ?? ""),
                          _infoRow(Icons.access_time, "Thời gian đón", trip['time'] ?? ""),
                          _infoRow(Icons.attach_money, "Giá", trip['price'] ?? ""),
                          _infoRow(Icons.people, "Số khách", trip['passengers'] ?? ""),
                          _infoRow(Icons.directions_car, "Loại xe", trip['carType'] ?? ""),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => pickedUp = true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: pickedUp ? Colors.green : Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            pickedUp ? "✅ Đã đón khách" : "Xác nhận đón khách",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: pickedUp
                              ? () => setState(() => started = true)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: started ? Colors.orange : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            started ? "🚗 Đang chạy" : "Bắt đầu chuyến đi",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  Text(
                    "Chi phí phát sinh (nếu có):",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Column(
                    children: List.generate(extraCostControllers.length, (index) {
                      var controller = extraCostControllers[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller,
                                decoration: InputDecoration(
                                  labelText: "Chi phí ${index + 1}",
                                  prefixIcon: Icon(Icons.attach_money),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(width: 8),
                            IconButton(
                              icon: Icon(Icons.remove_circle, color: Colors.red),
                              onPressed: () => _removeExtraCostField(index),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: _addExtraCostField,
                      icon: Icon(Icons.add, color: Colors.blue),
                      label: Text("Thêm chi phí"),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: started
                        ? () {
                      final extraCosts = extraCostControllers
                          .map((c) => c.text.trim())
                          .where((c) => c.isNotEmpty)
                          .toList();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Chuyến đi đã hoàn thành ✅\nChi phí: ${extraCosts.join(", ")}",
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Hoàn thành chuyến đi",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
