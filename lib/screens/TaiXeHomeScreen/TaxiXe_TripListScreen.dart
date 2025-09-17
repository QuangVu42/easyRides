import 'package:flutter/material.dart';
import './TaiXe_TripDetailScreen.dart';

class TripListScreen extends StatelessWidget {
  final List<Map<String, String>> trips = [
    {
      "from": "Bến xe Giáp Bát, Hà Nội",
      "to": "Bến xe Niệm Nghĩa, Hải Phòng",
      "pickupTime": "2025-09-20 08:30",
      "endTime": "2025-09-20 11:30",
      "price": "1,200,000đ",
      "passengers": "3",
      "carType": "SUV"
    },
    {
      "from": "Ga Thanh Hóa",
      "to": "Tràng An, Ninh Bình",
      "pickupTime": "2025-09-21 09:00",
      "endTime": "2025-09-21 10:30",
      "price": "800,000đ",
      "passengers": "2",
      "carType": "Sedan"
    },
    {
      "from": "Sân bay Nội Bài, Hà Nội",
      "to": "Trung tâm TP Bắc Ninh",
      "pickupTime": "2025-09-22 13:15",
      "endTime": "2025-09-22 14:45",
      "price": "650,000đ",
      "passengers": "1",
      "carType": "Hatchback"
    },
    {
      "from": "Chợ Bến Thành, TP.HCM",
      "to": "Sân bay Liên Khương, Đà Lạt",
      "pickupTime": "2025-09-23 07:45",
      "endTime": "2025-09-23 12:00",
      "price": "1,500,000đ",
      "passengers": "4",
      "carType": "Van"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return Card(
          margin: const EdgeInsets.all(8),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const Icon(Icons.directions_car, color: Colors.blue),
            title: Text("${trip['from']} → ${trip['to']}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Đón: ${trip['pickupTime']}"),
                Text("Kết thúc: ${trip['endTime']}"),
                Text("Giá: ${trip['price']} | ${trip['passengers']} khách | ${trip['carType']}"),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
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
