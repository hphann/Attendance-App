import 'package:attendance/Attendance/QrScanner.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceMethodsSheet extends StatelessWidget {
  const AttendanceMethodsSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)), // More rounded top corners
      ),
      child: Padding( // Add padding around the content
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60, // Wider drag handle
              height: 6, // Slightly thicker drag handle
              decoration: BoxDecoration(
                color: Colors.grey[400], // Darker grey for better visibility
                borderRadius: BorderRadius.circular(3), // Rounded drag handle
              ),
            ),
            const SizedBox(height: 24),
            _buildMethodButton(
              context: context, // Pass context for themed colors
              icon: Icons.qr_code_scanner,
              label: 'Quét QR Code', // More descriptive label
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QrScanner(),
                  ),
                );
              },
            ),
            _buildMethodButton(
              context: context, // Pass context for themed colors
              icon: Icons.location_on, // More relevant GPS icon
              label: 'Điểm danh GPS', // More descriptive label
              onTap: () async {
                // Lấy userId từ SharedPreferences
                String? userId = await getUserId();
                if (userId == null) {
                  if (!context.mounted) return; // Check context before using it
                  _showDialog(
                    context,
                    'Lỗi',
                    'Chưa đăng nhập, vui lòng đăng nhập lại!',
                    Colors.redAccent, // More vibrant error color
                    Icons.warning, // Warning icon for login issue
                  );
                  return;
                }

                if (!context.mounted) return; // Check context before using it
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Row(
                        children: [
                          const CircularProgressIndicator(),
                          Container(margin: const EdgeInsets.only(left: 16), child: const Text("Đang lấy vị trí...")), // Increased margin
                        ],
                      ),
                    );
                  },
                );

                try {
                  // Lấy vị trí hiện tại của người dùng
                  Position position = await _getCurrentLocation();
                  if (!context.mounted) return; // Check context before using it
                  Navigator.of(context, rootNavigator: true).pop(); // Đóng hộp thoại chờ

                  // Gọi API gửi thông tin điểm danh với vị trí và userId
                  _processGpsCheckIn(context, position, userId);
                } catch (e) {
                  if (!context.mounted) return; // Check context before using it
                  Navigator.of(context, rootNavigator: true).pop(); // Đóng hộp thoại chờ
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.grey[900], // Darker background for snackbar
                        content: Text("Không thể lấy vị trí, vui lòng thử lại: ${e.toString()}", style: const TextStyle(color: Colors.white)), // White text for better contrast
                      ),
                    );
                  }
                }
              },
            ),
            _buildMethodButton(
              context: context, // Pass context for themed colors
              icon: Icons.bluetooth_connected, // More relevant Bluetooth icon
              label: 'Điểm danh Bluetooth (chưa khả dụng)', // Indicate not yet implemented
              onTap: () {
                // TODO: Implement Bluetooth
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar( // Inform user about feature status
                  const SnackBar(
                    content: Text("Tính năng Bluetooth đang được phát triển."),
                  ),
                );
              },
              disabled: true, // Indicate button is disabled
            ),
            const SizedBox(height: 16), // Reduced bottom spacing
          ],
        ),
      ),
    );
  }

  // Phương thức lấy userId từ SharedPreferences
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId'); // Lấy userId
  }

  // Phương thức hiển thị hộp thoại
  void _showDialog(
      BuildContext context, // Thêm context vào phương thức
      String title, String message, Color color, IconData icon) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Rounded dialog corners
          title: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 12), // Increased spacing
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)), // Bold title, colored title
            ],
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: color, // Themed button color
              ),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMethodButton({
    required BuildContext context, // Context for theme
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool disabled = false, // Add disabled state
  }) {
    return Opacity( // Use Opacity for disabled state
      opacity: disabled ? 0.5 : 1.0, // Reduce opacity when disabled
      child: InkWell(
        onTap: disabled ? null : onTap, // Disable onTap when disabled
        borderRadius: BorderRadius.circular(12), // Rounded corners for InkWell
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // Increased vertical padding
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8), // Increased horizontal margin, vertical margin
          decoration: BoxDecoration(
            color: Colors.white, // White background for buttons
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!), // Slightly darker border
            boxShadow: [ // Subtle shadow for depth
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, size: 28, color: Theme.of(context).primaryColor), // Themed icon color, larger icon
              const SizedBox(width: 16), // Increased spacing
              Expanded( // Use Expanded to prevent text overflow
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 17, // Slightly larger font size
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600, // Slightly bolder font weight
                  ),
                ),
              ),
              if (disabled) const SizedBox(width: 28), // Keep space for potential icon even when disabled for alignment
            ],
          ),
        ),
      ),
    );
  }

  // Phương thức lấy vị trí hiện tại của người dùng
  Future<Position> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Dịch vụ vị trí chưa bật");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Cần cấp quyền vị trí");
        }
        if (permission == LocationPermission.deniedForever) {
          throw Exception("Quyền vị trí bị từ chối vĩnh viễn, hãy bật trong cài đặt");
        }
      }

      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      throw Exception("Không thể lấy vị trí: $e");
    }
  }

  // Phương thức gọi API khi điểm danh bằng GPS
  void _processGpsCheckIn(BuildContext context, Position position, String userId) async {
    const String apiUrl = "https://attendance-7f16.onrender.com/api/gps/check-in-gps";
    const String eventId = "rabPeQSPolmwCVzPDsWF";

    final Map<String, dynamic> requestData = {
      'user_id': userId,
      "event_id": eventId,
      'latitude': position.latitude,
      'longitude': position.longitude,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        print("Điểm danh thành công: ${response.body}");
        _showSuccessDialog(context);
      } else {
        print("Lỗi khi điểm danh: ${response.body}");
        _showErrorDialog(context, 'Đã xảy ra lỗi khi điểm danh. Vui lòng thử lại.');
      }
    } catch (e) {
      print("Lỗi mạng: $e");
      _showErrorDialog(context, 'Không thể kết nối với server. Vui lòng thử lại.');
    }
  }

  // Hiển thị thông báo thành công
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green[600]), // Success Icon
              const SizedBox(width: 12),
              Text("Điểm danh thành công", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[600])),
            ],
          ),
          content: const Text("Bạn đã điểm danh thành công!"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.green[600],
              ),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Hiển thị thông báo lỗi
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.redAccent), // Error Icon
              const SizedBox(width: 12),
              Text("Lỗi", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
            ],
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
              ),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}