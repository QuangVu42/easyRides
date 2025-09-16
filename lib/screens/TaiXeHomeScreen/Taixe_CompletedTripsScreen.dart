import 'package:flutter/material.dart';

class CompletedTripsScreen extends StatelessWidget {
  final List<Map<String, String>> completedTrips = [
    {
      "from": "Hà Nội",
      "to": "Nghệ An",
      "time": "07:00",
      "price": "2,000,000đ",
      "passengers": "4",
      "carType": "Minivan"
    },
    {
      "from": "Đà Nẵng",
      "to": "Huế",
      "time": "10:30",
      "price": "1,500,000đ",
      "passengers": "2",
      "carType": "Sedan"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: completedTrips.length,
      itemBuilder: (context, index) {
        final trip = completedTrips[index];
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text("${trip['from']} → ${trip['to']}"),
            subtitle: Text(
              "Hoàn thành lúc: ${trip['time']} | Giá: ${trip['price']} | ${trip['carType']}",
            ),
          ),
        );
      },
    );
  }
}
