import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screen/main_screen.dart';
import 'screen/profile.dart';

void main() {
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