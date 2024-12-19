import 'package:flutter/material.dart';
import 'package:attendance/widgets/attendanceHistoryCard.dart';
import 'package:attendance/widgets/attendanceMethodsSheet.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key}) : super(key: key);

  void _showAttendanceMethods(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const AttendanceMethodsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Thông tin',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Họp ABC',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildInfoRow('Người tổ chức:', 'Trần Thế Luật'),
              _buildInfoRow('Thời gian:', '9:00 Thứ 6'),
              _buildInfoRow('Số người tham gia:', '29 thành viên'),
              _buildInfoRow('Địa điểm:', 'Trung tâm hội nghị\nThành Phát'),
              const SizedBox(height: 24),
              _buildActionButtons(context),
              const SizedBox(height: 24),
              _buildAttendanceHistory(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _showAttendanceMethods(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'Điểm danh ngay',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.blue),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'Đăng ký vắng mặt',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Lịch sử điểm danh',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Xem tất cả',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const AttendanceHistoryCard(
          date: 'Buổi 3 - 06/12/2024',
          time: 'Không có',
          status: AttendanceStatus.absent,
        ),
        const SizedBox(height: 12),
        const AttendanceHistoryCard(
          date: 'Buổi 2 - 29/11/2024',
          time: '09:45 AM',
          status: AttendanceStatus.late,
        ),
        const SizedBox(height: 12),
        const AttendanceHistoryCard(
          date: 'Buổi 1 - 22/11/2024',
          time: '09:05 AM',
          status: AttendanceStatus.present,
        ),
      ],
    );
  }
}
