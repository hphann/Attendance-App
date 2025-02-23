1. Cài đặt và chạy dự án
Đổi "https://attendance-7f16.onrender.com" thành http://10.0.2.2:3000 (nếu chạy trên máy áo) hoặc http://localhost:3000 (nếu test API)

git clone https://github.com/hphann/Attendance-App.git
cd attendance

2. Cài đặt dependencies
flutter pub get

3. Chạy ứng dụng
flutter run

4. Tài khoản demo
Email: trantheluat007@gmail.com
Mật khẩu: 123456

5. Thay đổi đường link để chạy local
account/create_new_password_screen.dart |  Dòng 31
account/forgot_password_screen.dart  |  Dòng 30
account/verify_email_screen.dart  |  Dòng 37 và Dòng 57

attendance/attendance_methods_create.dart  |  Dòng 80
attendance/qr_generator.dart  |  Dòng 28
attendance/qr_scanner.dart  |  Dòng 41

screens/event_detail.dart  |  Dòng 82

services/absence_request_service.dart  |  Dòng 7
services/attendace_service.dart  | Dòng 7
services/event_participant.dart  | Dòng 7
services/event_service.dart  |  Dòng 7
services/gps_checkin_service.dart  |  Dòng 11
services/gps_create_service.dart  |  Dòng 12
services/user_service.dart  |  Dòng 9
