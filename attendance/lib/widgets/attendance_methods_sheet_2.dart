import 'package:attendance/Attendance/QrGenerator.dart';
import 'package:flutter/material.dart';

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
            icon: Icons.face,
            label: 'Face ID',
            onTap: () {
              // TODO: Implement Face ID
              Navigator.pop(context);
            },
          ),
          _buildMethodButton(
            icon: Icons.bluetooth,
            label: 'Bluetooth',
            onTap: () {
              // TODO: Implement Bluetooth
              Navigator.pop(context);
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
}

Widget _buildTimeSelectionSheet(BuildContext context) {
  final List<int> timeOptions = [5, 10, 15, 20, 30, 45, 60];

  return Container(
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
        ...timeOptions.map((minutes) => ListTile(
          title: Text("$minutes phút"),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QrGenerator(initialExpireMinutes: minutes),
              ),
            );
          },
        )),
      ],
    ),
  );
}
