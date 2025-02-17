import 'package:attendance/account/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:attendance/services/attendance_service.dart';
import 'package:attendance/models/attendance.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? selectedClass;
  String? selectedStatus;
  DateTime? selectedDate;
  OverlayEntry? _dropdownOverlay;
  String? selectedStatusFilter;
  String? selectedEventFilter;
  String displayedEventFilter = '';
  String displayedStatusFilter = '';
  final GlobalKey statusKey = GlobalKey();
  final GlobalKey eventKey = GlobalKey();

  final List<String> eventOptions = [
    'Lớp Lập Trình Di Động',
    'Họp Dự Án',
    'Seminar AI',
    'Workshop React',
    'Hội thảo công nghệ',
    'Họp nhóm dự án',
    'Workshop Flutter',
    'Tất cả'
  ];
  final List<String> statusOptions = ['Tất cả', 'Đã điểm danh', 'Vắng'];

  final AttendanceService _attendanceService = AttendanceService();
  List<Attendance> attendanceHistory = [];
  bool isLoading = false;
  String? error;
  String? userId;

  @override
  void initState() {
    super.initState();
    _getUserIdAndLoadData();
  }

  Future<void> _getUserIdAndLoadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedUserId = prefs.getString('userId');

      if (storedUserId == null) {
        // Nếu không có userId, có thể chuyển về màn hình đăng nhập
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
        return;
      }

      setState(() {
        userId = storedUserId;
      });

      await _loadAttendanceHistory();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _loadAttendanceHistory() async {
    if (userId == null) return;

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final history =
          await _attendanceService.getUserAttendanceHistory(userId!);
      if (mounted) {
        setState(() {
          attendanceHistory = history;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = e.toString();
          isLoading = false;
        });
      }
    }
  }

  // Lọc dữ liệu theo bộ lọc đã chọn
  List<Attendance> _getFilteredData() {
    return attendanceHistory.where((attendance) {
      // Lọc theo sự kiện
      final matchesEvent = selectedEventFilter == null ||
          selectedEventFilter == 'Tất cả' ||
          attendance.eventInfo?['name'] == selectedEventFilter;

      // Lọc theo trạng thái
      final matchesStatus = selectedStatusFilter == null ||
          selectedStatusFilter == 'Tất cả' ||
          attendance.status == selectedStatusFilter;

      // Lọc theo ngày
      final matchesDate = selectedDate == null ||
          DateUtils.isSameDay(attendance.timestamp, selectedDate);

      return matchesEvent && matchesStatus && matchesDate;
    }).toList();
  }

  Widget buildHistoryCard({
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
                  const Icon(Icons.access_time,
                      size: 16, color: Colors.black54),
                  const SizedBox(width: 8),
                  Text(
                    itemData['time'],
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const Spacer(),
                  if (itemData['status'].isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: itemData['status'] == 'Đã điểm danh'
                            ? Colors.green[100]
                            : (itemData['status'] == 'Vắng'
                                ? Colors.red[100]
                                : Colors.orange[100]),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        itemData['status'],
                        style: TextStyle(
                          color: itemData['status'] == 'Đã điểm danh'
                              ? Colors.green[900]
                              : (itemData['status'] == 'Vắng'
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
                    DateFormat('dd/MM/yyyy', 'vi_VN').format(itemData['date']),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lịch sử điểm danh',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Đổi màu của mũi tên Back
        ),
        backgroundColor: Colors.blue,
        actions: [
          // Thêm nút refresh
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAttendanceHistory,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: buildCustomDropdown(
                    hint: 'Chọn sự kiện',
                    value: selectedEventFilter,
                    items: eventOptions,
                    key: eventKey,
                    onItemSelected: (newValue) {
                      setState(() {
                        selectedEventFilter = newValue;
                        displayedEventFilter = newValue ?? '';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: buildCustomDropdown(
                    hint: 'Chọn trạng thái',
                    value: selectedStatusFilter,
                    items: statusOptions,
                    key: statusKey,
                    onItemSelected: (newValue) {
                      setState(() {
                        selectedStatusFilter = newValue;
                        displayedStatusFilter = newValue ?? '';
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: selectedDate != null
                          ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                          : 'Chọn ngày',
                      suffixIcon: const Icon(Icons.calendar_today),
                      border: const OutlineInputBorder(),
                    ),
                    onTap: () => _selectDate(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Lỗi: $error'),
                              ElevatedButton(
                                onPressed: _loadAttendanceHistory,
                                child: const Text('Thử lại'),
                              ),
                            ],
                          ),
                        )
                      : _getFilteredData().isEmpty
                          ? const Center(child: Text('Không có dữ liệu'))
                          : RefreshIndicator(
                              onRefresh: _loadAttendanceHistory,
                              child: ListView.builder(
                                itemCount: _getFilteredData().length,
                                itemBuilder: (context, index) {
                                  final attendance = _getFilteredData()[index];
                                  return buildHistoryCard(
                                    itemData: {
                                      'className':
                                          attendance.eventInfo?['name'] ??
                                              'Không có tên',
                                      'time': DateFormat('HH:mm')
                                          .format(attendance.timestamp),
                                      'date': attendance.timestamp,
                                      'status': attendance.status,
                                      'location':
                                          attendance.eventInfo?['location'] ??
                                              'Không có địa điểm',
                                      'organizer':
                                          attendance.eventInfo?['organizer'] ??
                                              'Không có thông tin',
                                    },
                                    onTap: () => _showDetailDialog(attendance),
                                  );
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailDialog(Attendance attendance) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(attendance.eventInfo?['name'] ?? 'Chi tiết điểm danh'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Thời gian: ${DateFormat('HH:mm dd/MM/yyyy').format(attendance.timestamp)}'),
            const SizedBox(height: 8),
            Text('Trạng thái: ${attendance.status}'),
            if (attendance.note != null) ...[
              const SizedBox(height: 8),
              Text('Ghi chú: ${attendance.note}'),
            ],
            const SizedBox(height: 8),
            Text('Địa điểm: ${attendance.eventInfo?['location'] ?? 'N/A'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Widget buildCustomDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?) onItemSelected,
    required GlobalKey key,
    TextOverflow overflow = TextOverflow.ellipsis,
  }) {
    return GestureDetector(
      key: key,
      onTap: () {
        if (_dropdownOverlay == null) {
          _showDropdown(
            context: context,
            key: key,
            items: items,
            onItemSelected: (selectedValue) {
              onItemSelected(selectedValue);
              setState(() {});
            },
          );
        } else {
          _removeDropdownOverlay();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value ?? hint,
                style: value == null
                    ? const TextStyle(color: Colors.grey)
                    : const TextStyle(color: Colors.black),
                maxLines: 1,
                overflow: overflow,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  OverlayEntry _createDropdownOverlay({
    required BuildContext context,
    required List<String> items,
    required void Function(String?) onItemSelected,
    required Offset offset,
    required double width,
    required GlobalKey key,
  }) {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          left: offset.dx,
          top: offset.dy,
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 32),
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: width,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text(
                        item,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        onItemSelected(item);
                        _removeDropdownOverlay();
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDropdown({
    required BuildContext context,
    required GlobalKey key,
    required List<String> items,
    required void Function(String?) onItemSelected,
  }) {
    final renderBox = key.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _dropdownOverlay = _createDropdownOverlay(
      context: context,
      items: items,
      onItemSelected: onItemSelected,
      offset: Offset(offset.dx, offset.dy + size.height),
      width: size.width,
      key: key,
    );

    Overlay.of(context).insert(_dropdownOverlay!);
  }

  void _removeDropdownOverlay() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> eventData;

  const DetailScreen({super.key, required this.eventData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(eventData['className']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thời gian: ${eventData['time']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Ngày: ${DateFormat('dd/MM/yyyy').format(eventData['date'])}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Trạng thái: ${eventData['status']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Địa điểm: ${eventData['location']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Người tổ chức: ${eventData['organizer']}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
