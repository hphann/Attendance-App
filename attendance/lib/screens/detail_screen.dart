import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:attendance/widgets/attendance_history_card.dart';
import 'package:attendance/attendance/attendance_methods_check_in.dart';
import 'package:attendance/screens/absence_registration_screen.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> eventData;

  const DetailScreen({Key? key, required this.eventData}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int selectedTab = 0;

  void showAttendanceMethods(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => AttendanceMethodsSheet(
        eventId: widget.eventData['id'],
      ),
    );
  }

  List<Map<String, dynamic>> getFilteredAttendanceData() {
    final now = DateTime.now();
    switch (selectedTab) {
      case 0: // Sắp tới
        return [
          _attendanceData.firstWhere(
              (item) =>
                  item['className'] == widget.eventData['className'] &&
                  isEventUpcoming(item, now),
              orElse: () => {})
        ].whereType<Map<String, dynamic>>().toList();
      case 1: // Đang diễn ra
        return [
          _attendanceData.firstWhere(
              (item) =>
                  item['className'] == widget.eventData['className'] &&
                  isEventOngoing(item, now),
              orElse: () => {})
        ].whereType<Map<String, dynamic>>().toList();
      case 2: // Đã kết thúc
        return [
          _attendanceData.firstWhere(
              (item) =>
                  item['className'] == widget.eventData['className'] &&
                  isEventCompleted(item, now),
              orElse: () => {})
        ].whereType<Map<String, dynamic>>().toList();
      default:
        return [
          _attendanceData.firstWhere(
              (item) => item['className'] == widget.eventData['className'],
              orElse: () => {})
        ].whereType<Map<String, dynamic>>().toList();
    }
  }

  final List<Map<String, dynamic>> _attendanceData = [
    {
      'className': 'Lập trình di động',
      'time': '08:00 - 11:00',
      'date': DateTime(2024, 10, 20),
      'status': 'Đã điểm danh',
      'repeat': null,
      'location': 'Phòng A101',
      'organizer': 'Nguyễn Văn A',
      'endDate': null,
    },
    {
      'className': 'Cơ sở dữ liệu',
      'time': '13:00 - 16:00',
      'date': DateTime(2025, 01, 10),
      'status': 'Vắng',
      'repeat': null,
      'location': 'Phòng B202',
      'organizer': 'Trần Thị B',
      'endDate': null,
    },
    {
      'className': 'Lập trình Web',
      'time': '10:00 - 12:00',
      'date': DateTime(2024, 10, 23),
      'status': 'Chưa điểm danh',
      'repeat': null,
      'location': 'Phòng C303',
      'organizer': 'Lê Văn C',
      'endDate': null,
    },
    {
      'className': 'Giải tích',
      'time': '08:00 - 10:00',
      'date': DateTime(2024, 11, 10),
      'status': 'Chưa điểm danh',
      'repeat': 'weekly',
      'daysOfWeek': [
        DateTime(2024, 1, 1, 0, 0, 0).add(Duration(days: DateTime.monday - 1)),
        DateTime(2024, 1, 1, 0, 0, 0)
            .add(Duration(days: DateTime.wednesday - 1))
      ],
      'location': 'Phòng D404',
      'organizer': 'Phạm Văn D',
      'endDate': DateTime(2025, 12, 30),
    },
    {
      'className': 'Toán rời rạc',
      'time': '10:00 - 11:30',
      'date': DateTime(2024, 11, 12),
      'status': 'Chưa điểm danh',
      'repeat': 'daily',
      'location': 'Phòng E505',
      'organizer': 'Hoàng Thị E',
      'endDate': DateTime(2025, 12, 10),
    },
    {
      'className': 'Xác suất thống kê',
      'time': '14:00 - 16:00',
      'date': DateTime(2024, 11, 11),
      'status': 'Đã điểm danh',
      'repeat': 'weekly',
      'daysOfWeek': [
        DateTime(2024, 1, 1, 0, 0, 0).add(Duration(days: DateTime.tuesday - 1)),
        DateTime(2024, 1, 1, 0, 0, 0).add(Duration(days: DateTime.thursday - 1))
      ],
      'location': 'Phòng F606',
      'organizer': 'Ngô Văn F',
      'endDate': DateTime(2025, 12, 20),
    },
    {
      'className': 'Mạng máy tính',
      'time': '15:00 - 17:00',
      'date': DateTime(2024, 11, 12),
      'status': 'Vắng',
      'repeat': null,
      'location': 'Phòng G707',
      'organizer': 'Đỗ Văn G',
      'endDate': null,
    }
  ];

  bool isEventUpcoming(Map<String, dynamic> item, DateTime now) {
    if (item['repeat'] == null) {
      return item['date'].isAfter(now);
    } else if (item['repeat'] == 'weekly') {
      if (item['endDate'] != null && now.isAfter(item['endDate'])) {
        return false;
      }
      for (final dayOfWeek in item['daysOfWeek']) {
        final eventDate = item['date'];
        final daysUntilNextEventDay = (dayOfWeek.weekday - now.weekday + 7) % 7;
        final nextEventDay = now.add(Duration(days: daysUntilNextEventDay));
        if (nextEventDay.isAfter(now) &&
            nextEventDay.isBefore(item['endDate'])) {
          return true;
        }
      }
      return false;
    } else if (item['repeat'] == 'daily') {
      if (item['endDate'] != null && now.isAfter(item['endDate'])) {
        return false;
      }
      return item['date'].isAfter(now);
    } else {
      return item['date'].isAfter(now);
    }
  }

  bool isEventOngoing(Map<String, dynamic> item, DateTime now) {
    if (item['repeat'] == null) {
      return item['date'].isAtSameMomentAs(now) ||
          (item['date'].isBefore(now) &&
              now.difference(item['date']) < const Duration(days: 1));
    } else if (item['repeat'] == 'weekly') {
      if (item['endDate'] != null && now.isAfter(item['endDate'])) {
        return false;
      }
      return item['daysOfWeek']
          .any((element) => element.weekday == now.weekday);
    } else if (item['repeat'] == 'daily') {
      if (item['endDate'] != null && now.isAfter(item['endDate'])) {
        return false;
      }
      return now.isAfter(item['date']) || now.isAtSameMomentAs(item['date']);
    } else {
      return item['date'].isAtSameMomentAs(now) ||
          (item['date'].isBefore(now) &&
              now.difference(item['date']) < const Duration(days: 1));
    }
  }

  bool isEventCompleted(Map<String, dynamic> item, DateTime now) {
    if (item['repeat'] == null) {
      return item['date'].isBefore(now);
    } else if (item['repeat'] == 'weekly') {
      if (item['endDate'] != null && now.isAfter(item['endDate'])) {
        return true;
      }
      for (final dayOfWeek in item['daysOfWeek']) {
        final eventDate = item['date'];
        final daysUntilNextEventDay = (dayOfWeek.weekday - now.weekday + 7) % 7;
        final nextEventDay = now.add(Duration(days: daysUntilNextEventDay));
        if (nextEventDay.isBefore(now) ||
            nextEventDay.isAfter(item['endDate'])) {
          return true;
        }
      }
      return false;
    } else if (item['repeat'] == 'daily') {
      if (item['endDate'] != null && now.isAfter(item['endDate'])) {
        return true;
      }
      return item['date'].isBefore(now);
    } else {
      return item['date'].isBefore(now);
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      selectedTab = index;
    });
  }

  String formatRepeatedEventDate(Map<String, dynamic> item) {
    if (item['repeat'] == 'weekly') {
      String days = '';
      for (var i = 0; i < item['daysOfWeek'].length; i++) {
        days += DateFormat('EEEE', 'vi_VN').format(item['daysOfWeek'][i]);
        if (i < item['daysOfWeek'].length - 1) {
          days += ', ';
        }
      }
      return days;
    } else {
      return 'Hằng ngày';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          widget.eventData['className'],
          style: const TextStyle(
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
              Text(
                widget.eventData['className'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildInfoRow('Người tổ chức:', widget.eventData['organizer']),
              _buildInfoRow('Thời gian:', widget.eventData['time']),
              _buildInfoRow('Số người tham gia:', '29 thành viên'),
              _buildInfoRow('Địa điểm:', widget.eventData['location']),
              const SizedBox(height: 20),
              _buildActionButtons(context),
              const SizedBox(height: 20),
              buildTabs(),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: ListView(
                    children: getFilteredAttendanceData().map((item) {
                  return buildAttendanceCard(
                    className: item['className'],
                    time: item['time'],
                    date: item['repeat'] == null
                        ? DateFormat('dd/MM/yyyy').format(item['date'])
                        : formatRepeatedEventDate(item),
                    status: selectedTab == 0 ? '' : item['status'],
                    location: item['location'],
                    organizer: item['organizer'],
                  );
                }).toList()),
              ),
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
            onPressed: () => showAttendanceMethods(context),
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
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AbsenceRegistrationScreen(
                    eventData: widget.eventData,
                  ),
                ),
              );
            },
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

  Widget buildTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 10,
        runSpacing: 8,
        children: [
          buildTabButton(title: 'Sắp tới', index: 0),
          buildTabButton(title: 'Đã diễn ra', index: 1),
          buildTabButton(title: 'Thành viên', index: 2),
        ],
      ),
    );
  }

  Widget buildTabButton({required String title, required int index}) {
    bool isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () => _onTabSelected(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget buildAttendanceCard({
    required String className,
    required String time,
    required String date,
    required String status,
    required String location,
    required String organizer,
  }) {
    return Card(
      elevation: 2,
      color: Colors.blue[50],
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              className,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.black54),
                const SizedBox(width: 8),
                Text(
                  time,
                  style: const TextStyle(color: Colors.black87),
                ),
                const Spacer(),
                if (status.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: status == 'Đã điểm danh'
                          ? Colors.green[100]
                          : (status == 'Vắng'
                              ? Colors.red[100]
                              : Colors.orange[100]),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: status == 'Đã điểm danh'
                            ? Colors.green[900]
                            : (status == 'Vắng'
                                ? Colors.red[900]
                                : Colors.orange[900]),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                const SizedBox(width: 8),
                Text(
                  date,
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.black54),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    location,
                    style: const TextStyle(color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.black54),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    organizer,
                    style: const TextStyle(color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
