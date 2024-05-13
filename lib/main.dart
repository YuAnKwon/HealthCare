import 'package:flutter/material.dart';
import 'package:healthcare/screen/googlemap_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase/fcm_utils.dart';
import 'screen/main_screen.dart';
import 'screen/profile.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:healthcare/firebase/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  String deviceToken = await getMyDeviceToken(); // 토큰 얻기
  sendTokenToServer(deviceToken); // 토큰 서버에 전송

  await initializeNotification();
  await requestNotificationPermission(); // 알림 권한 요청
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _hasProfile = false;
  bool _profileChecked = false;

  @override
  void initState() {
    super.initState();
    _checkUserProfile();
    getMyDeviceToken(); // FCM 토큰 가져오기
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      Map<String, dynamic>? data = message.data; //위도경도

      if (notification != null) {
        FlutterLocalNotificationsPlugin().show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'high_importance_notification',
              importance: Importance.max,
            ),
          ),
        );
        print("Foreground 메시지 수신: ${message.notification!.body} ${data}");

        // 알림을 터치하면 MyGoogleMap 화면으로 이동
        if (data != null &&
            data.containsKey('latitude') &&
            data.containsKey('longitude')) {
          double latitude = double.parse(data['latitude']);
          double longitude = double.parse(data['longitude']);

          // MyGoogleMap 화면으로 이동
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => MyGoogleMap(latitude: latitude, longitude: longitude)
            ),
          );
        } else {
          print('데이터 페이로드에 위도와 경도가 없습니다.');
        }

      }
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // 기본정보 입력됐는지 여부 확인
  Future<bool> _checkUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasProfile = prefs.getBool('hasProfile') ?? false;
    return hasProfile;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(), // 로딩 중
            ),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }
        // 프로필 확인 여부에 따라 첫 화면을 Profile 페이지 또는 HealthInfoPage로 설정
        return snapshot.data! ? HealthInfoPage() : Profile();
      },
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("백그라운드 메시지 처리.. ${message.notification!.body} ${message.data}");
}
