import 'package:attendance/models/event.dart';
import 'package:attendance/providers/event_provider.dart';
import 'package:attendance/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    await context.read<EventProvider>().fetchUserEvents();
  }

  List<Event> getFilteredEvents() {
    final events = context.watch<EventProvider>().events;
    final now = DateTime.now();

    switch (selectedTab) {
      case 0: // Sắp tới
        return events.where((event) => event.startTime.isAfter(now)).toList();
      case 1: // Đang diễn ra
        return events
            .where((event) =>
                event.startTime.isBefore(now) && event.endTime.isAfter(now))
            .toList();
      case 2: // Đã kết thúc
        return events.where((event) => event.endTime.isBefore(now)).toList();
      default:
        return events;
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<EventProvider>().isLoading;
    final error = context.watch<EventProvider>().error;

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
      body: RefreshIndicator(
        onRefresh: _loadEvents,
        child: Padding(
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
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (error != null)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Lỗi: $error'),
                      ElevatedButton(
                        onPressed: _loadEvents,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: getFilteredEvents().length,
                    itemBuilder: (context, index) {
                      final event = getFilteredEvents()[index];
                      return buildAttendanceCard(event: event);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
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
      child: Row(
        children: [
          buildTabButton(title: 'Sắp tới', index: 0),
          const SizedBox(width: 10),
          buildTabButton(title: 'Đang diễn ra', index: 1),
          const SizedBox(width: 10),
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

  Widget buildAttendanceCard({required Event event}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              eventData: {
                'id': event.id ?? '',
                'className': event.name,
                'time':
                    '${DateFormat('HH:mm').format(event.startTime)} - ${DateFormat('HH:mm').format(event.endTime)}',
                'date': event.startTime,
                'status': event.getStatus(),
                'repeat': event.repeat ?? '',
                'daysOfWeek': event.daysOfWeek ?? [],
                'location': event.location,
                'organizer': event.createdByUser?['name'] ?? 'Unknown',
                'type': event.type,
                'description': event.description,
                'createdBy': event.createdBy,
                'createdByUser': event.createdByUser ?? {},
                'endDate': event.endTime,
                'participants':
                    event.participants?.map((p) => p.toJson()).toList() ?? [],
              },
            ),
          ),
        );
      },
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
                event.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time,
                      size: 16, color: Colors.black54),
                  const SizedBox(width: 8),
                  Text(
                    '${DateFormat('HH:mm').format(event.startTime)} - ${DateFormat('HH:mm').format(event.endTime)}',
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const Spacer(),
                  if (selectedTab != 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(event.getStatus()),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        _getStatusText(event.getStatus()),
                        style: TextStyle(
                          color: _getStatusTextColor(event.getStatus()),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 16, color: Colors.black54),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('dd/MM/yyyy').format(event.startTime),
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 16, color: Colors.black54),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      event.location,
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
                      event.createdByUser?['name'] ?? 'Unknown',
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'upcoming':
        return Colors.blue.shade50;
      case 'active':
        return Colors.green.shade50;
      case 'completed':
        return Colors.grey.shade50;
      default:
        return Colors.grey.shade50;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'upcoming':
        return Colors.blue.shade700;
      case 'active':
        return Colors.green.shade700;
      case 'completed':
        return Colors.grey.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'upcoming':
        return 'Sắp diễn ra';
      case 'active':
        return 'Đang diễn ra';
      case 'completed':
        return 'Đã kết thúc';
      default:
        return 'Không xác định';
    }
  }
}
