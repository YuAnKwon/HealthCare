import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:healthcare/network/ApiResource.dart';

//----------------토큰 전송-------------------------
Future<void> sendTokenToServer(String token) async {
  final response = await http.post(
    Uri.parse('${ApiResource.serverUrl}/token'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'token': token}),
  );

  // 응답 확인
  if (response.statusCode == 200) {
    print('토큰이 성공적으로 서버에 전송되었습니다.');
  } else {
    print('토큰 서버에 전송 중 오류가 발생했습니다: ${response.reasonPhrase}');
  }
}

Future<String> getMyDeviceToken() async {
  final token = await FirebaseMessaging.instance.getToken();
  print("내 디바이스 토큰: $token");
  return token!; // 토큰 반환
}

//-------------FCM Messaging 설정---------------
Future<void> initializeNotification() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // 채널 ID
    'High Importance Notifications', // 채널 이름
    description: 'This channel is used for important notifications.', // 채널 설명
    importance: Importance.high, // 채널 중요도
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('warning'), // 앱 아이콘
    ),
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

// 알림 설정
Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.status;
  if (status.isDenied) {
    // 알림 권한이 거부된 경우, 권한 요청
    final result = await Permission.notification.request();
    if (result.isGranted) {
      // 권한이 허용된 경우
    } else if (result.isPermanentlyDenied) {
      // 사용자가 권한 요청을 영구적으로 거부한 경우
      openAppSettings(); // 앱 설정을 열어 사용자가 수동으로 권한을 변경할 수 있도록 함
    }
  } else if (status.isGranted) {
    // 알림 권한이 이미 허용된 경우
    print("Notification permission is already granted.");
  }
}


