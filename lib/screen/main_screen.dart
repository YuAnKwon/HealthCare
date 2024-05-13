import 'package:flutter/material.dart';
import 'package:healthcare/widgets/main_screen_widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../network/ApiResource.dart';
import 'chart_screen.dart';
import 'googlemap_screen.dart';

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
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (data == null) {
      // 데이터 가져오기 실패 시 메시지 표시
      return Scaffold(
        body: Center(
          child: const Text('보행보조차가 켜져있는지 확인해주세요'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${data?['last_workout_data']?['name'] ?? ''}님의 건강정보'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
              StatRow(
                data: [
                  StatData(
                      title: '심박수',
                      value:
                          '${data?['last_workout_data']?['heart'] ?? ''} bpm',
                      height: 100.0,
                      imagePath: 'assets/pulse_icon.png'),
                  StatData(
                      title: '산소포화도',
                      value: '${data?['last_workout_data']?['oxygen'] ?? ''} %',
                      height: 100.0,
                      imagePath: 'assets/oxygen_icon.png'),
                ],
                onTap: (title) => navigateToDetail(context, title),
              ),
              StatRow(
                data: [
                  StatData(
                      title: '체온',
                      value: '${data?['last_workout_data']?['temp'] ?? ''} °C',
                      height: 100.0,
                      imagePath: 'assets/temp_icon.png'),
                  StatData(
                      title: '체중',
                      value:
                          '${data?['last_workout_data']?['today_weight'] ?? ''} kg',
                      height: 100.0,
                      imagePath: 'assets/weight_icon.png'),
                ],
                onTap: (title) => navigateToDetail(context, title),
              ),

              // '이동거리' 카드
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => navigateToDetail(context, '이동거리'),
                  child: Card(
                    child: Container(
                      height: 100.0,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.asset('assets/distance_icon.png',
                                  height: 24.0), // 이미지
                              SizedBox(width: 8.0),
                              Text(
                                '이동거리',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '${data?['last_workout_data']?['distance'] ?? ''} km',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // '이동시간' 카드
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => navigateToDetail(context, '이동시간'),
                  child: Card(
                    child: Container(
                      height: 100.0,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.asset('assets/time_icon.png',
                                  height: 24.0), // 이미지
                              SizedBox(width: 8.0),
                              Text(
                                '이동시간',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '${formatWorkoutTime(data?['last_workout_data']?['workout_time'] ?? '')}',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_pin),
            label: 'Location',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
            // 추가: location이 클릭되면 인덱스를 1로 설정하여 GoogleMap 화면으로 이동
            if (_selectedIndex == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyGoogleMap()),
              );
            }
          });
        },
      ),
    );
  }

  void navigateToDetail(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChartPage(title: title)),
    );
  }
  @override
  void dispose() {
    super.dispose();
    if (_loading) {
      _loading = false;
    }
  }

}
