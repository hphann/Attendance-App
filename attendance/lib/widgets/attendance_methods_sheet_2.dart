import 'package:attendance/Attendance/QrGenerator.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceMethodsSheet2 extends StatelessWidget {
  const AttendanceMethodsSheet2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildMethodButton(
              context: context,
              icon: Icons.qr_code_scanner,
              label: 'Quét mã QR',
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) {
                    return _buildTimeSelectionSheet(context);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildMethodButton(
              context: context,
              icon: Icons.gps_fixed,
              label: 'Điểm danh GPS',
              onTap: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Row(
                        children: [
                          const CircularProgressIndicator(),
                          Container(margin: const EdgeInsets.only(left: 15), child: const Text("Đang lấy vị trí...")),
                        ],
                      ),
                    );
                  },
                );

                try {
                  Position position = await _getCurrentLocation();
                  Navigator.of(context, rootNavigator: true).pop();
                  if (context.mounted) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) {
                        return _buildTimeAndLocationSelectionSheet(context, position);
                      },
                    );
                  }
                } catch (e) {
                  Navigator.of(context, rootNavigator: true).pop();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Không thể lấy vị trí, vui lòng thử lại: ${e.toString()}")),
                    );
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildMethodButton(
              context: context,
              icon: Icons.bluetooth,
              label: 'Bluetooth (Chưa khả dụng)',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Bluetooth method is not yet implemented.")),
                );
              },
              enabled: false,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMethodButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: enabled ? Colors.white : Colors.grey[200],
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(icon, size: 28, color: enabled ? Theme.of(context).primaryColor : Colors.grey[500]),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  color: enabled ? Colors.black87 : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              if (enabled) Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey[500]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSelectionSheet(BuildContext context) {
    final List<int> timeOptions = [5, 10, 15, 20, 30, 45, 60];

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Chọn thời gian điểm danh",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[800])),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: timeOptions.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final minutes = timeOptions[index];
                  return ListTile(
                    title: Text("$minutes phút", style: const TextStyle(fontSize: 18)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              QrGenerator(initialExpireMinutes: minutes),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeAndLocationSelectionSheet(BuildContext context, Position position) {
    final List<int> timeOptions = [5, 10, 15, 20, 30, 45, 60];

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Chọn thời gian điểm danh",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[800])),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: timeOptions.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final minutes = timeOptions[index];
                  return ListTile(
                    title: Text("$minutes phút", style: const TextStyle(fontSize: 18)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      _showDistanceSelectionSheet(context, minutes, position);
                    },
                  );
                },
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DistanceSelectionSheet(
          distanceOptions: distanceOptions,
          selectedTime: selectedTime,
          initialPosition: position,
        );
      },
    );
  }

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

      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      throw Exception("Không thể lấy vị trí: $e");
    }
  }
}

class DistanceSelectionSheet extends StatefulWidget {
  final List<int> distanceOptions;
  final int selectedTime;
  final Position initialPosition;

  const DistanceSelectionSheet({
    Key? key,
    required this.distanceOptions,
    required this.selectedTime,
    required this.initialPosition,
  }) : super(key: key);

  @override
  _DistanceSelectionSheetState createState() => _DistanceSelectionSheetState();
}

class _DistanceSelectionSheetState extends State<DistanceSelectionSheet> {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isProcessing = false; // Thêm biến _isProcessing

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Chọn phạm vi điểm danh",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[800])),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: widget.distanceOptions.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final distance = widget.distanceOptions[index];
                return ListTile(
                  title: Text("$distance mét", style: const TextStyle(fontSize: 18)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                  enabled: !_isLoading,
                  onTap: () async {
                    Navigator.pop(context);
                    _showCheckInDialog(
                        context, widget.selectedTime, widget.initialPosition, distance);
                  },
                );
              },
            ),
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                "Lỗi: $_errorMessage",
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  // Phương thức lấy userId từ SharedPreferences
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  void _showCheckInDialog(BuildContext context, int selectedTime,
      Position position, int selectedDistance) async {
    if (!context.mounted) return;

    String? userId = await getUserId();

    if (userId == null) {
      if (!mounted) return; // Add mounted check here as well
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không tìm thấy thông tin người dùng.")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            "Xác nhận điểm danh",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.grey[800]),
            textAlign: TextAlign.center,
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on_rounded, size: 60, color: Colors.blueAccent),
                const SizedBox(height: 16),
                Text(
                  "Bạn có chắc chắn muốn điểm danh?\n\n"
                      "Phạm vi: $selectedDistance mét\n"
                      "Thời gian: $selectedTime phút",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actionsPadding: const EdgeInsets.only(bottom: 16),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Text(
                "Hủy",
                style: TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _processCheckIn(selectedTime, position, selectedDistance, userId, context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 2,
              ),
              child: const Text("Xác nhận", style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  void _processCheckIn(int selectedTime, Position position, int selectedDistance, String userId, BuildContext context) async {
    setState(() {
      _isProcessing = true;
    });
    // Chuẩn bị dữ liệu gửi đến server
    const String apiUrl = "https://attendance-7f16.onrender.com/api/gps/create-gps";
    const String eventId = "rabPeQSPolmwCVzPDsWF";
    try {
      // Gửi yêu cầu API
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          'event_id': eventId,
          'latitude': position.latitude,
          'longitude': position.longitude,
          'distance': selectedDistance,
          'session_time': DateTime.now().toIso8601String(),
          'valid_minutes': selectedTime,
        }),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print("_processCheckIn: Response success, checking mounted before _showDialog (success)");
        if (!mounted) {
          print("_processCheckIn: Widget NOT mounted, returning early (success)");
          return;
        }
        _showDialog(
          context,
          'Điểm danh thành công!',
          'Bạn đã điểm danh thành công!',
          Colors.blue,
          Icons.check_circle,
        );
      } else {
        final responseBody = jsonDecode(response.body);
        print("_processCheckIn: Response failure, checking mounted before _showDialog (error)");
        if (!mounted) {
          print("_processCheckIn: Widget NOT mounted, returning early (error)");
          return;
        }
        _showDialog(
          context,
          'Lỗi',
          'Lỗi: ${responseBody['message']}',
          Colors.red,
          Icons.cancel,
        );
      }
    } catch (error) {
      print("_processCheckIn: Exception caught, checking mounted before setState (catch block)");
      if (!mounted) {
        print("_processCheckIn: Widget NOT mounted, returning early (catch block)");
        return;
      }
      setState(() {
        print("_processCheckIn: setState called in catch block");
        _isProcessing = false;
      });
      if (!mounted) { // Double check mounted after setState just in case (unlikely but for extra safety)
        print("_processCheckIn: Widget NOT mounted AFTER setState in catch, returning early (catch block - post setState)");
        return;
      }
      _showDialog(
        context,
        'Lỗi',
        'Không thể kết nối đến server! $error',
        Colors.red,
        Icons.cancel,
      );
    } finally {
      print("_processCheckIn: Finally block, checking mounted before setState (finally block)");
      if (!mounted) {
        print("_processCheckIn: Widget NOT mounted, returning early (finally block)");
        return;
      }
      setState(() {
        print("_processCheckIn: setState called in finally block");
        _isProcessing = false;
      });
      if (!mounted) { // Double check mounted after setState just in case (unlikely but for extra safety)
        print("_processCheckIn: Widget NOT mounted AFTER setState in finally, returning early (finally block - post setState)");
        return;
      }
    }
  }

  void _showDialog(BuildContext context, String title, String content, Color color, IconData icon) {
    if (!mounted) return; // Important: check mounted here as well before showing dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 100,
                color: color,
              ),
              SizedBox(height: 10),
              Text(
                content,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("OK", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        );
      },
    );
  }
}