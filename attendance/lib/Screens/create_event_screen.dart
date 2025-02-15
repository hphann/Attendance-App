import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;
  String? _selectedRepeat;
  List<bool> _selectedDays = List.generate(7, (index) => false);
  bool _isLoading = false;
  final _memberController = TextEditingController();
  List<String> _members = [];

  final List<String> _repeatOptions = [
    'Không lặp lại',
    'Hằng ngày',
    'Hằng tuần'
  ];
  final List<String> _weekDays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _memberController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null ||
        _startTime == null ||
        _endDate == null ||
        _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Vui lòng chọn thời gian bắt đầu và kết thúc')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Implement event creation
      final event = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'location': _locationController.text,
        'startDate': _startDate,
        'startTime': _startTime,
        'endDate': _endDate,
        'endTime': _endTime,
        'repeat': _selectedRepeat,
        'daysOfWeek': _selectedRepeat == 'Hằng tuần'
            ? _weekDays
                .where((day) => _selectedDays[_weekDays.indexOf(day)])
                .toList()
            : null,
      };

      // Giả lập delay network
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tạo sự kiện thành công'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildMemberSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thành viên',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _memberController,
                decoration: const InputDecoration(
                  labelText: 'Email thành viên',
                  border: OutlineInputBorder(),
                  hintText: 'Nhập email thành viên',
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                if (_memberController.text.isNotEmpty) {
                  setState(() {
                    _members.add(_memberController.text);
                    _memberController.clear();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
              ),
              child: const Text('Thêm', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Hoặc tải file lên',
          style: TextStyle(
            color: Colors.blue[700],
            decoration: TextDecoration.underline,
          ),
        ),
        if (_members.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _members.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_members[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline,
                        color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _members.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tạo sự kiện mới',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên sự kiện',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên sự kiện';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Địa điểm',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập địa điểm';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Thời gian',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Ngày bắt đầu',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      controller: TextEditingController(
                        text: _startDate == null
                            ? ''
                            : DateFormat('dd/MM/yyyy').format(_startDate!),
                      ),
                      onTap: () => _selectDate(context, true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Giờ bắt đầu',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      controller: TextEditingController(
                        text: _startTime?.format(context) ?? '',
                      ),
                      onTap: () => _selectTime(context, true),
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
                      decoration: const InputDecoration(
                        labelText: 'Ngày kết thúc',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      controller: TextEditingController(
                        text: _endDate == null
                            ? ''
                            : DateFormat('dd/MM/yyyy').format(_endDate!),
                      ),
                      onTap: () => _selectDate(context, false),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Giờ kết thúc',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      controller: TextEditingController(
                        text: _endTime?.format(context) ?? '',
                      ),
                      onTap: () => _selectTime(context, false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Lặp lại',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRepeat ?? _repeatOptions[0],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: _repeatOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRepeat = newValue;
                  });
                },
              ),
              if (_selectedRepeat == 'Hằng tuần') ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: List.generate(7, (index) {
                    return FilterChip(
                      label: Text(_weekDays[index]),
                      selected: _selectedDays[index],
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedDays[index] = selected;
                        });
                      },
                    );
                  }),
                ),
              ],
              const SizedBox(height: 24),
              _buildMemberSection(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Tạo sự kiện',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
