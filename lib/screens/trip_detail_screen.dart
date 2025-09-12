import 'package:flutter/material.dart';
import '../models/Trip.dart';
import '../services/MockDataService.dart';

// Trip Detail Screen (for accepted trips)
class TripDetailScreen extends StatefulWidget {
  final Trip trip;

  TripDetailScreen({required this.trip});

  @override
  _TripDetailScreenState createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  final TextEditingController costController = TextEditingController();
  bool isLoading = false;

  bool _canCancelOrSell() {
    return DateTime.now().isBefore(widget.trip.startTime);
  }

  Future<void> _cancelTrip() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận hủy chuyến'),
        content: Text('Bạn sẽ bị trừ 10 điểm. Bạn có chắc chắn muốn hủy?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Không'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Hủy chuyến'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        isLoading = true;
      });

      await MockDataService.cancelTrip(widget.trip.id);

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã hủy chuyến. Điểm còn lại: ${MockDataService.currentUser!.points}')),
      );

      Navigator.pop(context);
    }
  }

  Future<void> _addExtraCost() async {
    if (costController.text.trim().isEmpty) return;

    await MockDataService.addExtraCost(widget.trip.id, costController.text.trim());
    costController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã thêm chi phí phát sinh')),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final driver = MockDataService.drivers.firstWhere((d) => d.id == widget.trip.selectedDriverId);
    final vehicle = MockDataService.vehicles.firstWhere((v) => v.id == widget.trip.selectedVehicleId);

    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết chuyến đi')),
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
                    SizedBox(height: 8),
                    Text('Giá đấu: ${widget.trip.bidPrice?.toStringAsFixed(0)}đ'),
                    Text('Thời gian bắt đầu: ${widget.trip.startTime}'),
                    Text('Tài xế: ${driver.name} - ${driver.phone}'),
                    Text('Xe: ${vehicle.type} - ${vehicle.licensePlate}'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            if (_canCancelOrSell()) ...[
              Text(
                'Hành động (chỉ có thể thực hiện trước giờ đón):',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showSellDialog(),
                      child: Text('Bán lại'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _cancelTrip,
                      child: isLoading ? CircularProgressIndicator(color: Colors.white) : Text('Hủy chuyến'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
            Text(
              'Chi phí phát sinh:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: costController,
                    decoration: InputDecoration(
                      labelText: 'Nhập chi phí phát sinh',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addExtraCost,
                  child: Text('Thêm'),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (widget.trip.extraCosts.isNotEmpty) ...[
              Text('Danh sách chi phí phát sinh:'),
              ...widget.trip.extraCosts.map((cost) => ListTile(
                leading: Icon(Icons.money),
                title: Text(cost),
              )).toList(),
            ],
          ],
        ),
      ),
    );
  }

  void _showSellDialog() {
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Bán lại chuyến'),
        content: TextField(
          controller: phoneController,
          decoration: InputDecoration(
            labelText: 'Số điện thoại người mua',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã gửi yêu cầu bán chuyến đến ${phoneController.text}')),
              );
            },
            child: Text('Gửi yêu cầu'),
          ),
        ],
      ),
    );
  }
}
