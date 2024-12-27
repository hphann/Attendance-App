import 'package:flutter/material.dart';

class OrganizerDashboardScreen extends StatelessWidget {
  const OrganizerDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Trang chủ',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.qr_code_scanner),
      //       label: 'Quét QR',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Cá nhân',
      //     ),
      //   ],
      //   currentIndex: 0,
      //   onTap: (index) {
      //     // Handle navigation
      //   },
      // ),
    );
  }
}

Widget _buildHeader() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage('images/avatar.png'),
        ),
        const SizedBox(
          width: 12,
        ),
        const Text(
          'Trần Thế Luật',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notification_add_outlined,
            color: Colors.blue,
          ),
        ),
      ],
    ),
  );
}

Widget _buildBody() {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsSection(),
          SizedBox(
            height: 20,
          ),
          Text(
            'Sự kiện đang diễn ra',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          _buildEventList(),
        ],
      ),
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
        Text(
          'Thống kê hôm nay',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatItem('Sự kiện', '10'),
            _buildStatItem('Đã điểm danh', '120'),
            _buildStatItem('Vắng mặt', '8'),
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
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 5),
      Text(
        label,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
    ],
  );
}

Widget _buildEventList() {
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: 4,
    itemBuilder: (context, index) {
      return Card(
        margin: EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sự kiện ${index + 1}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ngày: ${DateTime.now().add(Duration(days: index)).toString().substring(0, 16)} ',
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                'Địa điểm: Trung tâm hội nghị A',
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Chi tiết',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Tham gia',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
