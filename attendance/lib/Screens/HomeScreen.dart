import 'package:attendance/Screens/DetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;
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
        DateTime(2024, 1, 1, 0, 0, 0).add(Duration(days: DateTime.wednesday - 1))
      ],
      'location': 'Phòng D404',
      'organizer': 'Phạm Văn D',
      'endDate': DateTime(2025, 01, 30),
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
      'endDate':  DateTime(2025, 12, 20),
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

  List<Map<String, dynamic>> getFilteredAttendanceData() {
    final now = DateTime.now();
    switch (selectedTab) {
      case 0: // Sắp tới
        return _attendanceData
            .where((item) => isEventUpcoming(item, now))
            .toList();
      case 1: // Đang diễn ra
        return _attendanceData
            .where((item) => isEventOngoing(item, now))
            .toList();
      case 2: // Đã kết thúc
        return _attendanceData
            .where((item) => isEventCompleted(item, now))
            .toList();
      default:
        return _attendanceData;
    }
  }

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
        if (nextEventDay.isAfter(now) && nextEventDay.isBefore(item['endDate'])) {
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
        if (nextEventDay.isBefore(now) || nextEventDay.isAfter(item['endDate'])) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ứng dụng Điểm danh',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thống kê hôm nay',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            buildAttendanceSummary(),
            const SizedBox(height: 5),
            buildAttendanceSummary2(),
            const SizedBox(height: 20),
            buildTabs(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: getFilteredAttendanceData().map((item) {
                  return buildAttendanceCard(
                    itemData: item,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(eventData: item),
                        ),
                      );
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

  Widget buildAttendanceSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildSummaryCard(
          title: 'Đã điểm danh',
          value: '15',
          color: Colors.green[100]!,
        ),
        const SizedBox(width: 5),
        buildSummaryCard(
          title: 'Vắng',
          value: '2',
          color: Colors.red[100]!,
        ),
      ],
    );
  }

  Widget buildAttendanceSummary2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildSummaryCard(
          title: 'Chưa điểm danh',
          value: '3',
          color: Colors.orange[100]!,
        ),
        const SizedBox(width: 5),
        buildSummaryCard(
          title: 'Tổng buổi học',
          value: '20',
          color: Colors.blue[100]!,
        ),
      ],
    );
  }

  Widget buildSummaryCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        elevation: 2,
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
          buildTabButton(title: 'Đang diễn ra', index: 1),
          buildTabButton(title: 'Đã kết thúc', index: 2),
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
    required Map<String, dynamic> itemData,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
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
                itemData['className'],
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
                    itemData['time'],
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const Spacer(),
                  if (selectedTab != 0 && itemData['status'].isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: itemData['status'] == 'Đã điểm danh' ? Colors.green[100]
                            : (itemData['status'] == 'Vắng' ? Colors.red[100]
                            : Colors.orange[100]),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child:  Text(
                        itemData['status'],
                        style: TextStyle(
                          color: itemData['status'] == 'Đã điểm danh'
                              ? Colors.green[900]
                              : (itemData['status'] == 'Vắng' ? Colors.red[900] : Colors.orange[900]),
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
                    itemData['repeat'] == null
                        ? DateFormat('dd/MM/yyyy').format(itemData['date'])
                        : formatRepeatedEventDate(itemData),
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
                      itemData['location'],
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
                      itemData['organizer'],
                      style: const TextStyle(color: Colors.black87),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}