import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  final List<Map<String, dynamic>> localData = [
    {
      'className': 'Lớp Lập Trình Di Động',
      'time': '09:00 AM',
      'date': DateTime(2025, 1, 15),
      'status': 'Đã điểm danh',
      'location': 'Phòng 101',
      'organizer': 'Nguyễn Văn A'
    },
    {
      'className': 'Workshop React',
      'time': '01:00 PM',
      'date': DateTime(2025, 1, 14),
      'status': 'Vắng',
      'location': 'Phòng 202',
      'organizer': 'Trần Thị B'
    },
    {
      'className': 'Seminar AI',
      'time': '03:00 PM',
      'date': DateTime(2025, 1, 13),
      'status': 'Đã điểm danh',
      'location': 'Phòng 303',
      'organizer': 'Lê Văn C'
    },
    {
      'className': 'Lớp Lập Trình Di Động',
      'time': '09:00 AM',
      'date': DateTime(2025, 1, 15),
      'status': 'Đã điểm danh',
      'location': 'Phòng 101',
      'organizer': 'Nguyễn Văn A'
    },
    {
      'className': 'Workshop React',
      'time': '01:00 PM',
      'date': DateTime(2025, 1, 14),
      'status': 'Vắng',
      'location': 'Phòng 202',
      'organizer': 'Trần Thị B'
    },
    {
      'className': 'Seminar AI',
      'time': '03:00 PM',
      'date': DateTime(2025, 1, 13),
      'status': 'Đã điểm danh',
      'location': 'Phòng 303',
      'organizer': 'Lê Văn C'
    },
  ];

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
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
                  const Icon(Icons.access_time, size: 16, color: Colors.black54),
                  const SizedBox(width: 8),
                  Text(
                    itemData['time'],
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const Spacer(),
                  if (itemData['status'].isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: itemData['status'] == 'Đã điểm danh'
                            ? Colors.green[100]
                            : (itemData['status'] == 'Vắng' ? Colors.red[100] : Colors.orange[100]),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
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
                    DateFormat('dd/MM/yyyy').format(itemData['date']),
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
              child: ListView(
                children: localData.where((item) {
                  final matchesEvent = selectedEventFilter == null || selectedEventFilter == 'Tất cả' || item['className'] == selectedEventFilter;
                  final matchesStatus = selectedStatusFilter == null || selectedStatusFilter == 'Tất cả' || item['status'] == selectedStatusFilter;
                  final matchesDate = selectedDate == null || item['date'].isAtSameMomentAs(selectedDate!);
                  return matchesEvent && matchesStatus && matchesDate;
                }).map((item) {
                  return buildHistoryCard(
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


// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class HistoryScreen extends StatefulWidget {
//   const HistoryScreen({super.key});
//
//   @override
//   State<HistoryScreen> createState() => _HistoryScreenState();
// }
//
// class _HistoryScreenState extends State<HistoryScreen> {
//   String? selectedClass;
//   String? selectedStatus;
//   DateTime? selectedDate;
//   OverlayEntry? _dropdownOverlay;
//   String? selectedStatusFilter;
//   String? selectedEventFilter;
//   String displayedEventFilter = '';
//   String displayedStatusFilter = '';
//   final GlobalKey statusKey = GlobalKey();
//   final GlobalKey eventKey = GlobalKey();
//
//   final List<String> eventOptions = [
//     'Lớp Lập Trình Di Động',
//     'Họp Dự Án',
//     'Seminar AI',
//     'Workshop React',
//     'Hội thảo công nghệ',
//     'Họp nhóm dự án',
//     'Workshop Flutter',
//     'Tất cả'
//   ];
//   final List<String> statusOptions = ['Tất cả', 'Đã điểm danh', 'Vắng'];
//
//   void _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }
//
//   Widget buildHistoryCard({
//     required Map<String, dynamic> itemData,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 2,
//         color: Colors.blue[50],
//         margin: const EdgeInsets.only(bottom: 16.0),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 itemData['className'],
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   const Icon(Icons.access_time, size: 16, color: Colors.black54),
//                   const SizedBox(width: 8),
//                   Text(
//                     itemData['time'],
//                     style: const TextStyle(color: Colors.black87),
//                   ),
//                   const Spacer(),
//                   if (itemData['status'].isNotEmpty)
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: itemData['status'] == 'Đã điểm danh'
//                             ? Colors.green[100]
//                             : (itemData['status'] == 'Vắng' ? Colors.red[100] : Colors.orange[100]),
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       child: Text(
//                         itemData['status'],
//                         style: TextStyle(
//                           color: itemData['status'] == 'Đã điểm danh'
//                               ? Colors.green[900]
//                               : (itemData['status'] == 'Vắng' ? Colors.red[900] : Colors.orange[900]),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Icon(Icons.calendar_today, size: 16, color: Colors.black54),
//                   const SizedBox(width: 8),
//                   Text(
//                     DateFormat('dd/MM/yyyy').format(itemData['date'].toDate()),
//                     style: const TextStyle(color: Colors.black87),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Icon(Icons.location_on, size: 16, color: Colors.black54),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       itemData['location'],
//                       style: const TextStyle(color: Colors.black87),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   const Icon(Icons.person, size: 16, color: Colors.black54),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       itemData['organizer'],
//                       style: const TextStyle(color: Colors.black87),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Lịch sử điểm danh'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Flexible(
//                   child: buildCustomDropdown(
//                     hint: 'Chọn sự kiện',
//                     value: selectedEventFilter,
//                     items: eventOptions,
//                     key: eventKey,
//                     onItemSelected: (newValue) {
//                       setState(() {
//                         selectedEventFilter = newValue;
//                         displayedEventFilter = newValue ?? '';
//                       });
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Flexible(
//                   child: buildCustomDropdown(
//                     hint: 'Chọn trạng thái',
//                     value: selectedStatusFilter,
//                     items: statusOptions,
//                     key: statusKey,
//                     onItemSelected: (newValue) {
//                       setState(() {
//                         selectedStatusFilter = newValue;
//                         displayedStatusFilter = newValue ?? '';
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     readOnly: true,
//                     decoration: InputDecoration(
//                       hintText: selectedDate != null
//                           ? DateFormat('dd/MM/yyyy').format(selectedDate!)
//                           : 'Chọn ngày',
//                       suffixIcon: const Icon(Icons.calendar_today),
//                       border: const OutlineInputBorder(),
//                     ),
//                     onTap: () => _selectDate(context),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance.collection('Events').snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//
//                   if (snapshot.hasError) {
//                     return const Center(child: Text('Đã xảy ra lỗi khi tải dữ liệu'));
//                   }
//
//                   final data = snapshot.data?.docs ?? [];
//                   final filteredData = data.where((doc) {
//                     final item = doc.data() as Map<String, dynamic>;
//                     final matchesEvent = selectedEventFilter == null || selectedEventFilter == 'Tất cả' || item['className'] == selectedEventFilter;
//                     final matchesStatus = selectedStatusFilter == null || selectedStatusFilter == 'Tất cả' || item['status'] == selectedStatusFilter;
//                     final matchesDate = selectedDate == null || item['date'].toDate().isAtSameMomentAs(selectedDate!);
//                     return matchesEvent && matchesStatus && matchesDate;
//                   }).toList();
//
//                   return ListView(
//                     children: filteredData.map((doc) {
//                       final item = doc.data() as Map<String, dynamic>;
//                       return buildHistoryCard(
//                         itemData: item,
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => DetailScreen(eventData: item),
//                             ),
//                           );
//                         },
//                       );
//                     }).toList(),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildCustomDropdown({
//     required String hint,
//     required String? value,
//     required List<String> items,
//     required void Function(String?) onItemSelected,
//     required GlobalKey key,
//     TextOverflow overflow = TextOverflow.ellipsis,
//   }) {
//     return GestureDetector(
//       key: key,
//       onTap: () {
//         if (_dropdownOverlay == null) {
//           _showDropdown(
//             context: context,
//             key: key,
//             items: items,
//             onItemSelected: (selectedValue) {
//               onItemSelected(selectedValue);
//               setState(() {});
//             },
//           );
//         } else {
//           _removeDropdownOverlay();
//         }
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: Colors.grey),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Text(
//                 value ?? hint,
//                 style: value == null
//                     ? const TextStyle(color: Colors.grey)
//                     : const TextStyle(color: Colors.black),
//                 maxLines: 1,
//                 overflow: overflow,
//               ),
//             ),
//             const Icon(Icons.arrow_drop_down, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }
//
//   OverlayEntry _createDropdownOverlay({
//     required BuildContext context,
//     required List<String> items,
//     required void Function(String?) onItemSelected,
//     required Offset offset,
//     required double width,
//     required GlobalKey key,
//   }) {
//     return OverlayEntry(
//       builder: (context) {
//         return Positioned(
//           left: offset.dx,
//           top: offset.dy,
//           child: Container(
//             constraints: BoxConstraints(
//                 maxWidth: MediaQuery.of(context).size.width - 32),
//             child: Material(
//               elevation: 4.0,
//               borderRadius: BorderRadius.circular(8),
//               child: Container(
//                 width: width,
//                 child: ListView.builder(
//                   padding: EdgeInsets.zero,
//                   shrinkWrap: true,
//                   itemCount: items.length,
//                   itemBuilder: (context, index) {
//                     final item = items[index];
//                     return ListTile(
//                       title: Text(
//                         item,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       onTap: () {
//                         onItemSelected(item);
//                         _removeDropdownOverlay();
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void _showDropdown({
//     required BuildContext context,
//     required GlobalKey key,
//     required List<String> items,
//     required void Function(String?) onItemSelected,
//   }) {
//     final renderBox = key.currentContext!.findRenderObject() as RenderBox;
//     final size = renderBox.size;
//     final offset = renderBox.localToGlobal(Offset.zero);
//
//     _dropdownOverlay = _createDropdownOverlay(
//       context: context,
//       items: items,
//       onItemSelected: onItemSelected,
//       offset: Offset(offset.dx, offset.dy + size.height),
//       width: size.width,
//       key: key,
//     );
//
//     Overlay.of(context).insert(_dropdownOverlay!);
//   }
//
//   void _removeDropdownOverlay() {
//     _dropdownOverlay?.remove();
//     _dropdownOverlay = null;
//   }
// }
//
// class DetailScreen extends StatelessWidget {
//   final Map<String, dynamic> eventData;
//
//   const DetailScreen({super.key, required this.eventData});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(eventData['className']),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Thời gian: ${eventData['time']}',
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Ngày: ${DateFormat('dd/MM/yyyy').format(eventData['date'].toDate())}',
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Trạng thái: ${eventData['status']}',
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Địa điểm: ${eventData['location']}',
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Người tổ chức: ${eventData['organizer']}',
//               style: const TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
