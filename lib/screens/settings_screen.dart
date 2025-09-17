import 'package:flutter/material.dart';
import '../models/index.dart';
import '../services/MockDataService.dart';

// =================== SETTINGS SCREEN ===================
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // 👈 tránh che UI khi bàn phím bật
      appBar: AppBar(
        title: Text('Cài đặt'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tài xế'),
            Tab(text: 'Xe'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DriverSettingsTab(),
          VehicleSettingsTab(),
        ],
      ),
    );
  }
}

// =================== DRIVER TAB ===================
class DriverSettingsTab extends StatefulWidget {
  @override
  _DriverSettingsTabState createState() => _DriverSettingsTabState();
}

class _DriverSettingsTabState extends State<DriverSettingsTab> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  void _addDriver() {
    if (nameController.text.trim().isEmpty || phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
      return;
    }

    setState(() {
      MockDataService.drivers.add(Driver(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
      ));
    });

    nameController.clear();
    phoneController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã thêm tài xế')),
    );
  }

  void _deleteDriver(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xóa tài xế'),
        content: Text('Bạn có chắc chắn muốn xóa tài xế này?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Hủy')),
          TextButton(
            onPressed: () {
              setState(() => MockDataService.drivers.removeAt(index));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã xóa tài xế')),
              );
            },
            child: Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Thêm tài xế mới',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Tên tài xế',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Số điện thoại',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addDriver,
                  style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                  child: Text('Thêm tài xế'),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Danh sách tài xế',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: MockDataService.drivers.length,
                separatorBuilder: (_, __) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final driver = MockDataService.drivers[index];
                  return ListTile(
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Text(driver.name),
                    subtitle: Text(driver.phone),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteDriver(index),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =================== VEHICLE TAB ===================
class VehicleSettingsTab extends StatefulWidget {
  @override
  _VehicleSettingsTabState createState() => _VehicleSettingsTabState();
}

class _VehicleSettingsTabState extends State<VehicleSettingsTab> {
  final typeController = TextEditingController();
  final licensePlateController = TextEditingController();
  String? selectedDriverId;

  void _addVehicle() {
    if (typeController.text.trim().isEmpty ||
        licensePlateController.text.trim().isEmpty ||
        selectedDriverId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
      return;
    }

    setState(() {
      MockDataService.vehicles.add(Vehicle(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: typeController.text.trim(),
        licensePlate: licensePlateController.text.trim(),
        driverId: selectedDriverId!,
      ));
    });

    typeController.clear();
    licensePlateController.clear();
    selectedDriverId = null;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã thêm xe')),
    );
  }

  void _deleteVehicle(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xóa xe'),
        content: Text('Bạn có chắc chắn muốn xóa xe này?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Hủy')),
          TextButton(
            onPressed: () {
              setState(() => MockDataService.vehicles.removeAt(index));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã xóa xe')),
              );
            },
            child: Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Thêm xe mới', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                TextField(
                  controller: typeController,
                  decoration: InputDecoration(
                    labelText: 'Loại xe (VD: 4 chỗ, 7 chỗ)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: licensePlateController,
                  decoration: InputDecoration(
                    labelText: 'Biển số xe',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Chọn tài xế',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedDriverId,
                  items: MockDataService.drivers.map((driver) {
                    return DropdownMenuItem<String>(
                      value: driver.id,
                      child: Text('${driver.name} - ${driver.phone}'),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => selectedDriverId = value),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addVehicle,
                  style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                  child: Text('Thêm xe'),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Danh sách xe',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: MockDataService.vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = MockDataService.vehicles[index];
                  final driver = MockDataService.drivers.firstWhere(
                        (d) => d.id == vehicle.driverId,
                    orElse: () => Driver(id: '', name: 'Unknown', phone: ''),
                  );
                  return ListTile(
                    leading: CircleAvatar(child: Icon(Icons.directions_car)),
                    title: Text('${vehicle.type} - ${vehicle.licensePlate}'),
                    subtitle: Text('Tài xế: ${driver.name}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteVehicle(index),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
