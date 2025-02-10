import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io'; // Import để dùng Platform.environment

class QrScanner extends StatefulWidget {
  const QrScanner({Key? key}) : super(key: key);

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> with WidgetsBindingObserver {
  final TextEditingController _noteController = TextEditingController();
  String _qrCode = '';
  bool _isProcessing = false;
  MobileScannerController? scannerController;
  bool _isInitialized = false;

  // Sử dụng biến này để lưu trữ URL API
  String? _apiUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeApiUrl(); // Gọi hàm này trước khi khởi tạo scanner
    _initializeScanner();
  }

  // Hàm để thiết lập URL API từ biến môi trường
  void _initializeApiUrl() {
    // Lấy URL API từ biến môi trường
    _apiUrl = Platform.environment['API_URL'];

    // Sử dụng URL mặc định nếu biến môi trường không được thiết lập
    _apiUrl ??= 'http://10.0.2.2:3000/api/qr/scan';
    print('API URL: $_apiUrl'); // In URL API để kiểm tra
  }


  Future<void> _initializeScanner() async {
    bool granted = await _getCameraPermission();
    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cần quyền truy cập camera để quét mã QR')),
      );
      return;
    }

    scannerController = MobileScannerController(
      autoStart: false,
    );

    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        scannerController?.start().then((_) {
          if (mounted) {
            setState(() {
              _isInitialized = true;
            });
          }
        });
      }
    });
  }

  Future<bool> _getCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted) return true;
    var result = await Permission.camera.request();
    return result.isGranted;
  }

  Future<void> _onScan(String qrData) async {
    if (qrData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mã QR không hợp lệ!')),
      );
      return;
    }

    setState(() {
      _qrCode = qrData;
      _isProcessing = true;
    });

    try {
      // Sử dụng URL API từ biến môi trường
      final response = await http.post(
        Uri.parse(_apiUrl!), // Sử dụng URL API đã được khẳng định không null
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'qrData': qrData,
          'note': _noteController.text,
        }),
      );

      setState(() {
        _isProcessing = false;
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Điểm danh thành công!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${response.statusCode}')),
        );
      }
    } catch (error) {
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể kết nối đến server! $error')),
      );
    } finally {
      if (scannerController != null) {
        await scannerController?.start();
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (scannerController == null) return;

    if (state == AppLifecycleState.resumed) {
      scannerController?.start();
    } else if (state == AppLifecycleState.paused) {
      scannerController?.stop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _noteController.dispose();
    scannerController?.stop();
    scannerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Điểm danh'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Khu vực quét mã QR
            Container(
              padding: const EdgeInsets.only(left: 50.0, right: 50.0),
              width: 300.0,
              height: 300.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: _isInitialized && scannerController != null
                    ? MobileScanner(
                  controller: scannerController,
                  onDetect: (barcodeCapture) {
                    if (barcodeCapture.barcodes.isNotEmpty && !_isProcessing) {
                      final String? qrCode = barcodeCapture.barcodes.first.rawValue;
                      if (qrCode != null) {
                        scannerController?.stop();
                        _onScan(qrCode);
                      }
                    }
                  },
                  fit: BoxFit.cover,
                )
                    : Center(child: CircularProgressIndicator()),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Đưa mã QR vào vùng này',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blue),
            ),
            const SizedBox(height: 70),

            // Ô nhập ghi chú
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Ghi chú (nếu cần)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                filled: true,
                fillColor: Color.fromRGBO(230, 240, 255, 1.0),
              ),
              maxLines: 3,
            ),

            if (_isProcessing)
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}