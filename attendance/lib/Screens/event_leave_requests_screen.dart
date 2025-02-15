import 'package:flutter/material.dart';

class EventLeaveRequestsScreen extends StatefulWidget {
  final Map<String, dynamic> eventData;

  const EventLeaveRequestsScreen({
    Key? key,
    required this.eventData,
  }) : super(key: key);

  @override
  State<EventLeaveRequestsScreen> createState() =>
      _EventLeaveRequestsScreenState();
}

class _EventLeaveRequestsScreenState extends State<EventLeaveRequestsScreen> {
  String? _selectedStatusFilter;

  final List<String> _statusOptions = [
    'Chờ duyệt',
    'Đã duyệt',
    'Đã từ chối',
    'Tất cả'
  ];

  // Dữ liệu mẫu (sau này sẽ lấy từ API)
  final List<Map<String, dynamic>> _leaveRequests = [
    {
      'user': 'Nguyễn Văn A',
      'date': '2024-11-15',
      'reason': 'Bận việc gia đình',
      'status': 'Chờ duyệt',
    },
    {
      'user': 'Trần Thị B',
      'date': '2024-11-15',
      'reason': 'Bị ốm',
      'status': 'Đã duyệt',
    },
    {
      'user': 'Lê Văn C',
      'date': '2024-11-15',
      'reason': 'Đi công tác',
      'status': 'Đã từ chối',
    },
  ];

  List<Map<String, dynamic>> _filteredRequests() {
    if (_selectedStatusFilter == null || _selectedStatusFilter == 'Tất cả') {
      return _leaveRequests;
    }
    return _leaveRequests
        .where((req) => req['status'] == _selectedStatusFilter)
        .toList();
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
            buildAttendanceSummary(),
            const SizedBox(height: 10),
            buildAttendanceSummary2(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: _buildCustomDropdown(
                    hint: 'Chọn trạng thái',
                    value: _selectedStatusFilter,
                    items: _statusOptions,
                    onItemSelected: (newValue) {
                      setState(() {
                        _selectedStatusFilter = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredRequests().length,
                itemBuilder: (context, index) {
                  final request = _filteredRequests()[index];
                  return Card(
                    elevation: 4,
                    color: Colors.blue[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person,
                                      color: Colors.black54, size: 24),
                                  const SizedBox(width: 8),
                                  Text(
                                    request['user'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(request['status']),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.label,
                                        color: Colors.white, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      request['status'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.date_range,
                                  color: Colors.black54, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Ngày vắng mặt: ${request['date']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.comment,
                                  color: Colors.black54, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Lý do: ${request['reason']}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          if (request['status'] == 'Chờ duyệt') ...[
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      request['status'] = 'Đã duyệt';
                                    });
                                  },
                                  icon: const Icon(Icons.check_circle,
                                      color: Colors.green),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      request['status'] = 'Đã từ chối';
                                    });
                                  },
                                  icon: const Icon(Icons.cancel,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildAttendanceSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildSummaryCard(
          title: 'Tổng yêu cầu',
          value: _leaveRequests.length.toString(),
          color: Colors.blue[100]!,
        ),
        const SizedBox(width: 5),
        buildSummaryCard(
          title: 'Chờ duyệt',
          value: _leaveRequests
              .where((req) => req['status'] == 'Chờ duyệt')
              .length
              .toString(),
          color: Colors.orange[100]!,
        ),
      ],
    );
  }

  Widget buildAttendanceSummary2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildSummaryCard(
          title: 'Đã duyệt',
          value: _leaveRequests
              .where((req) => req['status'] == 'Đã duyệt')
              .length
              .toString(),
          color: Colors.green[100]!,
        ),
        const SizedBox(width: 5),
        buildSummaryCard(
          title: 'Đã từ chối',
          value: _leaveRequests
              .where((req) => req['status'] == 'Đã từ chối')
              .length
              .toString(),
          color: Colors.red[100]!,
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
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?) onItemSelected,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onItemSelected,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Chờ duyệt':
        return Colors.orange;
      case 'Đã duyệt':
        return Colors.green;
      case 'Đã từ chối':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
