import 'package:attendance/Attendance/QrGenerator.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AttendanceMethodsSheet2 extends StatelessWidget {
  const AttendanceMethodsSheet2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          _buildMethodButton(
            icon: Icons.qr_code_scanner,
            label: 'QR',
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) {
                  return _buildTimeSelectionSheet(context);
                },
              );
            },
          ),
          _buildMethodButton(
            icon: Icons.gps_fixed,
            label: 'GPS',
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) {
                  return _buildTimeAndLocationSelectionSheet(context);
                },
              );
            },
          ),
          _buildMethodButton(
            icon: Icons.bluetooth,
            label: 'Bluetooth',
            onTap: () {
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMethodButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.grey[700]),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelectionSheet(BuildContext context) {
    final List<int> timeOptions = [5, 10, 15, 20, 30, 45, 60];

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5, // Giới hạn tối đa 50% màn hình
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Chọn thời gian điểm danh", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: timeOptions.map((minutes) => ListTile(
                  title: Text("$minutes phút"),
                  onTap: () {
                    Navigator.pop(context);
                    // Quá trình tạo QR sẽ ở đây
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QrGenerator(initialExpireMinutes: minutes),
                      ),
                    );
                  },
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeAndLocationSelectionSheet(BuildContext context) {
    final List<int> timeOptions = [5, 10, 15, 20, 30, 45, 60];

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            // Chọn thời gian
            Text("Chọn thời gian", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView(
                children: timeOptions.map((minutes) {
                  return ListTile(
                    title: Text("$minutes phút"),
                    onTap: () async {
                      // Sau khi chọn thời gian, lấy vị trí GPS và thực hiện điểm danh
                      try {
                        Position position = await _getCurrentLocation();
                        // Mở BottomSheet để chọn phạm vi
                        _showDistanceSelectionSheet(context, minutes, position);
                      } catch (e) {
                        // Xử lý lỗi nếu không thể lấy vị trí
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Không thể lấy vị trí: $e"),
                        ));
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDistanceSelectionSheet(BuildContext context, int selectedTime, Position position) {
    final List<int> distanceOptions = [5, 10, 15, 20, 30, 50, 100];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: [
              Text("Chọn phạm vi điểm danh", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              ...distanceOptions.map((distance) {
                return ListTile(
                  title: Text("$distance m"),
                  onTap: () {
                    // Sau khi chọn phạm vi, đóng cả hai BottomSheet
                    Navigator.pop(context); // Đóng BottomSheet chọn phạm vi
                    Navigator.pop(context); // Đóng BottomSheet chọn thời gian
                    Navigator.pop(context);

                    // Hiển thị dialog thông tin điểm danh
                    _showCheckInDialog(context, selectedTime, position, distance);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }


  Future<Position> _getCurrentLocation() async {
    // Kiểm tra quyền truy cập vị trí
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Vị trí không khả dụng");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Cần cấp quyền vị trí");
      }
    }

    // Lấy vị trí hiện tại
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  void _showCheckInDialog(BuildContext context, int selectedTime, Position position, int selectedDistance) {
    // Tạo nội dung cho dialog
    String timeInfo = "$selectedTime phút";
    String distanceInfo = "$selectedDistance m";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text("Thông tin điểm danh", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Điểm danh GPS", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text("Thời gian điểm danh", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(timeInfo),
              SizedBox(height: 16),
              Text("Phạm vi điểm danh", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(distanceInfo),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Đóng dialog
                Navigator.pop(context);
              },
              child: Text("Đóng"),
            ),
            TextButton(
              onPressed: () {
                // Chuyển sang màn hình điểm danh hoặc lưu thông tin vào hệ thống
                Navigator.pop(context); // Đóng dialog
                // Thực hiện điểm danh hoặc lưu thông tin
              },
              child: Text("Điểm danh"),
            ),
          ],
        );
      },
    );
  }
}
