// 하루치 데이터를 표시하는 화면

import 'package:flutter/material.dart';
//import 'package:healthcare/widgets/main_screen_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../main.dart';
import '../network/ApiResource.dart';
import 'chart_screen.dart';
import 'googlemap_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HealthInfoPage extends StatefulWidget {
  @override
  _HealthInfoPageState createState() => _HealthInfoPageState();
}

class _HealthInfoPageState extends State<HealthInfoPage> {
  Map<String, dynamic>? data;
  bool _loading = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      _loading = true; // 데이터 가져오는 중임을 표시
    });

    try {
      final response = await http.get(
        Uri.parse('${ApiResource.serverUrl}/main'),
        headers: {"ngrok-skip-browser-warning": "22"},
      );
      if (response.statusCode == 200) {
        setState(() {
          data = jsonDecode(response.body);
          _loading = false; // 데이터 가져오기 성공
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      setState(() {
        _loading = false; // 데이터 가져오기 실패
      });
      // 데이터 가져오기 실패 메시지 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('에러'),
            content: const Text('데이터 불러오기에 실패했습니다.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        body: Center(
          child:  LoadingAnimationWidget.staggeredDotsWave(
            color: Color(0xFFC7B3A3),
            size: 50.0,
          ),
        ),
      );
    }

    if (data == null) {
      return Scaffold(
        body: Center(
          child: const Text('보행보조차가 켜져있는지 확인해주세요'),
        ),
        appBar: AppBar(
        elevation: 1,
        title: Text(''),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              fetchData();
            },
          ),
        ],
      ),
        bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.location_pin),
                  label: '위치정보'
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: (int index) {
              handleBottomNavigationBarTap(index);
            }
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text('${data?['last_workout_data']?['name'] ?? ''}님의 건강정보'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              fetchData();
            },
          ),
        ],
      ),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '${data?['last_workout_data']?['date'] ?? ''} ',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // ---------------------6개 데이터 container----------------------
                // StatRow(
                //   data: [
                //     StatData(
                //         title: '심박수',
                //         value:
                //             '${data?['last_workout_data']?['heart'] ?? ''} bpm',
                //         height: 100.0,
                //         imagePath: 'assets/pulse_icon.png'),
                //     StatData(
                //         title: '산소포화도',
                //         value: '${data?['last_workout_data']?['oxygen'] ?? ''} %',
                //         height: 100.0,
                //         imagePath: 'assets/oxygen_icon.png'),
                //   ],
                //   onTap: (title) => navigateToDetail(context, title),
                // ),
                // StatRow(
                //   data: [
                //     StatData(
                //         title: '체온',
                //         value: '${(data?['last_workout_data']?['temp'] as double?)?.toStringAsFixed(1) ?? ''} °C',
                //         height: 100.0,
                //         imagePath: 'assets/temp_icon.png'),
                //     StatData(
                //         title: '체중',
                //         value:
                //             '${data?['last_workout_data']?['today_weight'] ?? ''} kg',
                //         height: 100.0,
                //         imagePath: 'assets/weight_icon.png'),
                //   ],
                //   onTap: (title) => navigateToDetail(context, title),
                // ),

                buildStatCard('심박수', '${data?['last_workout_data']?['heart'] ?? ''} bpm', 'assets/pulse_icon.png', () => navigateToDetail(context, '심박수')),
                buildStatCard('산소포화도', '${data?['last_workout_data']?['oxygen'] ?? ''} %', 'assets/oxygen_icon.png', () => navigateToDetail(context, '산소포화도')),
                buildStatCard('체온', '${(data?['last_workout_data']?['temp'] as double?)?.toStringAsFixed(1) ?? ''} °C', 'assets/temp_icon.png', () => navigateToDetail(context, '체온')),
                buildStatCard('이동거리', '${data?['last_workout_data']?['distance'] ?? ''} km', 'assets/distance_icon.png', () => navigateToDetail(context, '이동거리')),
                //buildStatCard('이동시간', '${formatWorkoutTime(data?['last_workout_data']?['workout_time'] ?? '')}', 'assets/time_icon.png', () => navigateToDetail(context, '이동시간')),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_pin),
              label: '위치정보'
          ),
        ],
        currentIndex: _selectedIndex,
          onTap: (int index) {
            handleBottomNavigationBarTap(index);
          }
      ),
    );
  }
  void handleBottomNavigationBarTap(int index) async {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 1) {
        showRecentPushNotificationLocation();
      }
    });
  }

  // 최근 푸시 알림 정보를 검색하는 메서드
  Future<Map<String, dynamic>> getRecentPushNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble('recentPushNotificationLatitude');
    double? longitude = prefs.getDouble('recentPushNotificationLongitude');
    String? receivedDateTime = prefs.getString('recentPushNotificationReceivedDateTime');

    return {
      'latitude': latitude,
      'longitude': longitude,
      'receivedDateTime': receivedDateTime,
    };
  }

  Future<void> showRecentPushNotificationLocation() async {
    Map<String, dynamic> recentPushNotification = await getRecentPushNotification();
    double? latitude = recentPushNotification['latitude'];
    double? longitude = recentPushNotification['longitude'];
    String? receivedDateTime = recentPushNotification['receivedDateTime'];

    if (latitude != null && longitude != null) {
      navigatorKey.currentState!.pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyGoogleMap(
            latitude: latitude,
            longitude: longitude,
            receivedDateTime: receivedDateTime,
          ),
        ),
      );
    } else {
      // 최근 푸시 알림 정보가 없는 경우
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('최근 푸시 알림 정보를 찾을 수 없습니다.'),
        ),
      );
    }
  }

  void navigateToDetail(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChartPage(title: title)),
    );
  }

  // 심박수, 산소포화도, 체온, 이동거리 위젯
  Widget buildStatCard(String title, String value, String imagePath, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: onTap,
        child: Card(
          child: Container(
            height: 103.0,
            padding: const EdgeInsets.all(13.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(imagePath, height: 24.0), // 이미지
                    SizedBox(width: 8.0),
                    Text(
                      title,
                      style: TextStyle(
                        //fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//위치 정보 가져오기
// void _fetchLocation() async {
//   setState(() {
//     _loading = true; // 위치 가져오는 중임을 표시
//   });
//
//   try {
//     final response = await http.get(
//       Uri.parse('${ApiResource.serverUrl}/location'),
//       headers: {"ngrok-skip-browser-warning": "22"},
//     );
//     if (response.statusCode == 200) {
//       final locationData = jsonDecode(response.body);
//       double latitude = double.parse(locationData['latitude']);
//       double longitude = double.parse(locationData['longitude']);
//
//       // 위치 정보를 받아왔으므로 MyGoogleMap 화면으로 이동
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => MyGoogleMap(latitude: latitude, longitude: longitude)),
//       );
//
//       setState(() {
//         _loading = false; // 위치 가져오기 성공
//       });
//     } else {
//       throw Exception('위치정보 가져오기 실패');
//     }
//   } catch (error) {
//     setState(() {
//       _loading = false; // 위치 가져오기 실패
//     });
//     // 위치 가져오기 실패 메시지 표시
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('위치정보를 가져오는데 실패했습니다.'),
//       ),
//     );
//   }
// }

}
