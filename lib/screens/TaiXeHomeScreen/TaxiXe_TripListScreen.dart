import 'package:flutter/material.dart';
import './TaiXe_TripDetailScreen.dart';

class TripListScreen extends StatelessWidget {
  final List<Map<String, String>> trips = [
    {
      "from": "Hà Nội",
      "to": "Hải Phòng",
      "time": "08:30",
      "price": "1,200,000đ",
      "passengers": "3",
      "carType": "SUV"
    },
    {
      "from": "Thanh Hóa",
      "to": "Ninh Bình",
      "time": "09:00",
      "price": "800,000đ",
      "passengers": "2",
      "carType": "Sedan"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            leading: Icon(Icons.directions_car, color: Colors.blue),
            title: Text("${trip['from']} → ${trip['to']}"),
            subtitle: Text(
              "Đón: ${trip['time']} | Giá: ${trip['price']} | ${trip['passengers']} khách | ${trip['carType']}",
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TripDetailScreen(trip: trip),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
