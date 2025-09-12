import 'package:flutter/material.dart';
import '../models/Trip.dart';
import '../services/MockDataService.dart';
import '../utils/date_formatter.dart';
import '../utils/format_Currency.dart';

// Bidding Screen
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

    setState(() {
      isLoading = true;
    });

    await MockDataService.placeBid(
      widget.trip.id,
      bidPrice,
      selectedDriverId!,
      selectedVehicleId!,
    );

    setState(() {
      isLoading = false;
    });

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
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.trip.fromLocation} → ${widget.trip.toLocation}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text('Giá yêu cầu: ${formatCurrency(widget.trip.requestedPrice)}'),
                    Text('Thời gian: ${DateFormatter.format(widget.trip.startTime, 'HH:mm dd/MM/yyyy')} '),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: bidController,
              decoration: InputDecoration(
                labelText: 'Ra giá của bạn (VNĐ)',
                border: OutlineInputBorder(),
                helperText: 'Phải nhỏ hơn ${formatCurrency(widget.trip.requestedPrice)}',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Text('Chọn tài xế:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ...MockDataService.drivers.map((driver) => RadioListTile<String>(
              title: Text('${driver.name} - ${driver.phone}'),
              value: driver.id,
              groupValue: selectedDriverId,
              onChanged: (value) => setState(() => selectedDriverId = value),
            )).toList(),
            SizedBox(height: 16),
            Text('Chọn xe:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ...MockDataService.vehicles.map((vehicle) => RadioListTile<String>(
              title: Text('${vehicle.type} - ${vehicle.licensePlate}'),
              value: vehicle.id,
              groupValue: selectedVehicleId,
              onChanged: (value) => setState(() => selectedVehicleId = value),
            )).toList(),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text('Bao gồm chi phí phát sinh (xăng, cầu đường...)'),
              value: includeExtraCosts,
              onChanged: (value) => setState(() => includeExtraCosts = value ?? false),
            ),
            SizedBox(height: 24),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: _placeBid,
              child: Text('Đặt giá'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
