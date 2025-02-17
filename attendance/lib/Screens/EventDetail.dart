import 'package:attendance/widgets/attendance_history_card.dart';
import 'package:attendance/widgets/attendance_methods_sheet_2.dart';
import 'package:flutter/material.dart';
import 'package:attendance/widgets/add_member_bottom_sheet.dart';
import 'package:attendance/screens/event_leave_requests_screen.dart';

class EventDetail extends StatefulWidget {
  final Map<String, dynamic> eventData;

  const EventDetail({Key? key, required this.eventData}) : super(key: key);

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  int selectedTab = 0;

  void showAttendanceMethods(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const AttendanceMethodsSheet2(),
    );
  }

  void _showAddMemberBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddMemberBottomSheet(
          onMembersAdded: (List<String> newMembers) {
            // TODO: Implement add members to event
            setState(() {
              final currentMembers = (widget.eventData['members']
                      as List<Map<String, dynamic>>?) ??
                  [];
              widget.eventData['members'] = [
                ...currentMembers,
                ...newMembers.map((email) =>
                    {'email': email, 'status': 'notYet', 'role': 'Thành viên'})
              ];
            });
          },
        ),
      ),
    );
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
              _buildInfoRow('Thời gian:', widget.eventData['time']),
              _buildInfoRow(
                'Số người tham gia:',
                '${(widget.eventData['members'] as List)?.length ?? 0} thành viên',
              ),
              _buildInfoRow('Địa điểm:', widget.eventData['location']),
              const SizedBox(height: 20),
              _buildActionButtons(context),
              const SizedBox(height: 20),
              _buildMemberList(),
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
              'Điểm danh',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventLeaveRequestsScreen(
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
              'Yêu cầu vắng mặt',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMemberList() {
    final members = widget.eventData['members'] as List<Map<String, dynamic>>?;

    if (members == null || members.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Danh sách thành viên',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: _showAddMemberBottomSheet,
              icon: const Icon(Icons.person_add, size: 20, color: Colors.white),
              label: const Text('Thêm'),
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: members.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final member = members[index];
            final status = member['status'] ?? 'notYet';

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                child: Text(
                  member['email'][0].toUpperCase(),
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                member['email'],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                member['role'] ?? 'Thành viên',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              trailing: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(_getAttendanceStatus(status))
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getStatusColor(_getAttendanceStatus(status))
                        .withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  _getStatusText(_getAttendanceStatus(status)),
                  style: TextStyle(
                    color: _getStatusColor(_getAttendanceStatus(status)),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              contentPadding: EdgeInsets.zero,
            );
          },
        ),
      ],
    );
  }

  Color _getStatusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.notYet:
        return Colors.orange;
      case AttendanceStatus.present:
        return Colors.green;
      case AttendanceStatus.absent:
        return Colors.red;
      case AttendanceStatus.late:
        return Colors.yellow;
    }
  }

  String _getStatusText(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.notYet:
        return 'Chưa điểm danh';
      case AttendanceStatus.present:
        return 'Có mặt';
      case AttendanceStatus.absent:
        return 'Vắng mặt';
      case AttendanceStatus.late:
        return 'Trễ';
    }
  }

  AttendanceStatus _getAttendanceStatus(String status) {
    switch (status) {
      case 'present':
        return AttendanceStatus.present;
      case 'late':
        return AttendanceStatus.late;
      case 'absent':
        return AttendanceStatus.absent;
      default:
        return AttendanceStatus.notYet;
    }
  }
}
