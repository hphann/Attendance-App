import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  
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
          backgroundImage: AssetImage('images/avatar.jpg'),
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
  return ListView.builder(
    padding: const EdgeInsets.all(16.0),
    itemCount: 10,
    itemBuilder: (context, index) {
      return Card(
        color: Colors.blue[50],
        margin: const EdgeInsets.only(bottom: 16.0),
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
