import 'package:flutter/material.dart';
import '../models/Trip.dart';
import '../services/MockDataService.dart';
import '../utils/date_formatter.dart';
import '../utils/format_Currency.dart';

class BiddingScreen extends StatefulWidget {
  final Trip trip;

  BiddingScreen({required this.trip});

  @override
  _BiddingScreenState createState() => _BiddingScreenState();
}

class _BiddingScreenState extends State<BiddingScreen> {
  final TextEditingController bidController = TextEditingController();
  String? selectedDriverId;
  String? selectedVehicleId;
  bool includeExtraCosts = false;
  bool isLoading = false;

  Future<void> _placeBid() async {
    if (selectedDriverId == null || selectedVehicleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng chọn tài xế và xe')),
      );
      return;
    }

    double bidPrice = double.tryParse(bidController.text) ?? 0;
    if (bidPrice <= 0 || bidPrice >= widget.trip.requestedPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giá đấu phải lớn hơn 0 và nhỏ hơn giá yêu cầu')),
      );
      return;
    }

    setState(() => isLoading = true);

    await MockDataService.placeBid(
      widget.trip.id,
      bidPrice,
      selectedDriverId!,
      selectedVehicleId!,
    );

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đấu giá thành công!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ra giá chuyến đi')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blueAccent),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${widget.trip.fromLocation} → ${widget.trip.toLocation}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text('Giá yêu cầu: ${formatCurrency(widget.trip.requestedPrice)}',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
                    Text('Thời gian đón: ${DateFormatter.format(widget.trip.startTime, 'HH:mm dd/MM/yyyy')}'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Input giá
            TextField(
              controller: bidController,
              decoration: InputDecoration(
                labelText: 'Ra giá của bạn',
                prefixText: '₫ ',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                helperText: 'Phải nhỏ hơn ${formatCurrency(widget.trip.requestedPrice)}',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),

            // Chọn tài xế
            Text('Chọn tài xế:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedDriverId,
              items: MockDataService.drivers.map((driver) {
                return DropdownMenuItem(
                  value: driver.id,
                  child: Text('${driver.name} - ${driver.phone}'),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedDriverId = value),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            SizedBox(height: 20),

            // Chọn xe
            Text('Chọn xe:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedVehicleId,
              items: MockDataService.vehicles.map((vehicle) {
                return DropdownMenuItem(
                  value: vehicle.id,
                  child: Text('${vehicle.type} - ${vehicle.licensePlate}'),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedVehicleId = value),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            SizedBox(height: 16),

            // Check box extra costs
            CheckboxListTile(
              title: Text('Bao gồm chi phí phát sinh (xăng, cầu đường...)'),
              value: includeExtraCosts,
              onChanged: (value) => setState(() => includeExtraCosts = value ?? false),
            ),
            SizedBox(height: 24),

            // Button
            isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: _placeBid,
              child: Text('Đặt giá', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
