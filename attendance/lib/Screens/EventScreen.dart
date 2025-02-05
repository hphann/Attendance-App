import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  int _selectedTab = 0;

  final List<Map<String, dynamic>> _eventData = [
    {
      'className': 'Hội thảo công nghệ',
      'time': '09:00 - 12:00',
      'date': DateTime(2025, 01, 15),
      'location': 'Hội trường A',
    },
    {
      'className': 'Họp nhóm dự án',
      'time': '14:00 - 16:00',
      'date': DateTime(2025, 01, 10),
      'location': 'Phòng họp B',
    },
    {
      'className': 'Workshop Flutter',
      'time': '07:00 - 10:00',
      'date': DateTime(2025, 01, 08),
      'location': 'Phòng C',
    },
    {
      'className': 'Lịch sử đảng',
      'time': '13:00 - 15:00',
      'date': DateTime(2025, 02, 12),
      'location': 'Phòng 207',
    },
    {
      'className': 'Xác xuất thống kê',
      'time': '18:00 - 20:00',
      'date': DateTime(2025, 01, 30),
      'location': 'Phòng 402',
    },
    {
      'className': 'Kỹ năng giao tiếp',
      'time': '13:00 - 17:00',
      'date': DateTime(2025, 02, 17),
      'location': 'Phòng 905',
    },
    {
      'className': 'Chiến lược đầu tư',
      'time': '17:00 - 20:00',
      'date': DateTime(2025, 01, 27),
      'location': 'Phòng 605',
    },
  ];

  List<Map<String, dynamic>> _getFilteredEventData() {
    final now = DateTime.now();
    switch (_selectedTab) {
      case 0: // Sắp tới
        return _eventData.where((event) => event['date'].isAfter(now)).toList();
      case 1: // Đang diễn ra
        return _eventData.where((event) {
          final eventDate = event['date'];
          return eventDate.year == now.year &&
              eventDate.month == now.month &&
              eventDate.day == now.day;
        }).toList();
      case 2: // Đã kết thúc
        return _eventData.where((event) => event['date'].isBefore(now)).toList();
      default:
        return _eventData;
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedTab = index;
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
            _buildStatsSection(),
            const SizedBox(height: 20),
            _buildTabs(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: _getFilteredEventData().map((event) {
                  return _buildEventCard(
                    className: event['className'],
                    time: event['time'],
                    date: DateFormat('dd/MM/yyyy').format(event['date']),
                    location: event['location'],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Thêm sự kiện
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thống kê sự kiện',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Sắp tới', '3'),
              _buildStatItem('Đang diễn ra', '1'),
              _buildStatItem('Đã kết thúc', '4'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTabButton('Sắp tới', 0),
        _buildTabButton('Đang diễn ra', 1),
        _buildTabButton('Đã kết thúc', 2),
      ],
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => _onTabSelected(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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

  Widget _buildEventCard({
    required String className,
    required String time,
    required String date,
    required String location,
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
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.black54),
                const SizedBox(width: 8),
                Text(time),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                const SizedBox(width: 8),
                Text(date),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.black54),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(location),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
