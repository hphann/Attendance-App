import 'package:flutter/material.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  OverlayEntry? _dropdownOverlay;

  // Các biến trạng thái để lọc dữ liệu
  String? _selectedStatusFilter;
  String _displayedStatusFilter = '';
  String? _selectedEventFilter;
  String _displayedEventFilter = '';

  // Các options để lọc dữ liệu
  final List<String> _statusOptions = [
    'Chờ duyệt',
    'Đã duyệt',
    'Đã từ chối',
    'Tất cả'
  ];
  final List<String> _eventOptions = [
    'Lớp Lập Trình Di Động',
    'Họp Dự Án',
    'Seminar AI',
    'Workshop React',
    'Hội thảo công nghệ',
    'Họp nhóm dự án',
    'Workshop Flutter'
        'Tất cả'
  ];
  final GlobalKey _statusKey = GlobalKey();
  final GlobalKey _eventKey = GlobalKey();

  // Dữ liệu mẫu (có thể lấy từ API hoặc database)
  final List<Map<String, dynamic>> _leaveRequests = [
    {
      'user': 'Nguyễn Văn A',
      'event': 'Lớp Lập Trình Di Động',
      'date': '2024-11-15',
      'reason': 'Bận việc riêng',
      'status': 'Chờ duyệt',
    },
    {
      'user': 'Trần Thị B',
      'event': 'Họp Dự Án',
      'date': '2024-11-20',
      'reason': 'Bị ốm',
      'status': 'Đã duyệt',
    },
    {
      'user': 'Lê Văn C',
      'event': 'Seminar AI',
      'date': '2024-11-22',
      'reason': 'Đi công tác',
      'status': 'Đã từ chối',
    },
    {
      'user': 'Phạm Thị D',
      'event': 'Workshop React',
      'date': '2024-11-23',
      'reason': 'Đi công tác',
      'status': 'Đã duyệt',
    },
    {
      'user': 'Nguyễn Văn E',
      'event': 'Lớp Lập Trình Di Động',
      'date': '2024-11-24',
      'reason': 'Bận việc riêng',
      'status': 'Chờ duyệt',
    },
    {
      'user': 'Trần Thị F',
      'event': 'Họp Dự Án',
      'date': '2024-11-25',
      'reason': 'Bị ốm',
      'status': 'Đã duyệt',
    },
    {
      'user': 'Lê Văn G',
      'event': 'Seminar AI',
      'date': '2024-11-26',
      'reason': 'Đi công tác',
      'status': 'Đã từ chối',
    },
    {
      'user': 'Phạm Thị H',
      'event': 'Workshop React',
      'date': '2024-11-27',
      'reason': 'Đi công tác',
      'status': 'Đã duyệt',
    },
  ];

  // Hàm để lọc dữ liệu
  List<Map<String, dynamic>> _filteredRequests() {
    return _leaveRequests.where((request) {
      bool statusMatch = true;
      if (_selectedStatusFilter != null && _selectedStatusFilter != 'Tất cả') {
        statusMatch = request['status'] == _selectedStatusFilter;
      }

      bool eventMatch = true;
      if (_selectedEventFilter != null && _selectedEventFilter != 'Tất cả') {
        eventMatch = request['event'] == _selectedEventFilter;
      }
      return statusMatch && eventMatch;
    }).toList();
  }

  int get _totalRequests => _leaveRequests.length;

  int get _pendingRequests =>
      _leaveRequests.where((req) => req['status'] == 'Chờ duyệt').length;

  int get _approvedRequests =>
      _leaveRequests.where((req) => req['status'] == 'Đã duyệt').length;

  int get _rejectedRequests =>
      _leaveRequests.where((req) => req['status'] == 'Đã từ chối').length;

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
                    key: _statusKey,
                    onItemSelected: (newValue) {
                      setState(() {
                        _selectedStatusFilter = newValue;
                        _displayedStatusFilter = newValue ?? '';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: _buildCustomDropdown(
                    hint: 'Chọn sự kiện',
                    value: _selectedEventFilter,
                    items: _eventOptions,
                    key: _eventKey,
                    onItemSelected: (newValue) {
                      setState(() {
                        _selectedEventFilter = newValue;
                        _displayedEventFilter = newValue ?? '';
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
                              const Icon(Icons.event,
                                  color: Colors.black54, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Sự kiện: ${request['event']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
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
                              Text(
                                'Lý do: ${request['reason']}',
                                style: const TextStyle(fontSize: 14),
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

  Widget buildAttendanceSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildSummaryCard(
          title: 'Tổng yêu cầu',
          value: _totalRequests.toString(),
          color: Colors.blue[100]!,
        ),
        const SizedBox(width: 5),
        buildSummaryCard(
          title: 'Chờ duyệt',
          value: _pendingRequests.toString(),
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
          value: _approvedRequests.toString(),
          color: Colors.green[100]!,
        ),
        const SizedBox(width: 5),
        buildSummaryCard(
          title: 'Đã từ chối',
          value: _rejectedRequests.toString(),
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

  // Widget _buildDropdownMenu({
  //   required List<String> items,
  //   required void Function(String?) onItemSelected,
  //   required GlobalKey key,
  // }) {
  //   final renderBox = key.currentContext!.findRenderObject() as RenderBox;
  //   final size = renderBox.size;
  //   final offset = renderBox.localToGlobal(Offset.zero);
  //   return Positioned(
  //     left: offset.dx,
  //     top: offset.dy + size.height,
  //     child: Container(
  //       constraints:
  //           BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 32),
  //       child: Material(
  //         elevation: 4.0,
  //         borderRadius: BorderRadius.circular(8),
  //         child: SingleChildScrollView(
  //           scrollDirection: Axis.horizontal,
  //           child: Container(
  //             width: size.width,
  //             child: ListView.builder(
  //               shrinkWrap: true,
  //               itemCount: items.length,
  //               itemBuilder: (context, index) {
  //                 final item = items[index];
  //                 return ListTile(
  //                   title: Text(
  //                     item,
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                   onTap: () {
  //                     onItemSelected(item);
  //                     _removeDropdownOverlay();
  //                   },
  //                 );
  //               },
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Hàm để tạo OverlayEntry
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
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
            ));
      },
    );
  }

  // Hàm để hiển thị OverlayEntry
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
        key: key);

    Overlay.of(context).insert(_dropdownOverlay!);
  }

  // Hàm để ẩn OverlayEntry
  void _removeDropdownOverlay() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
  }
}
