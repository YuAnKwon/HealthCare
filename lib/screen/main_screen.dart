import 'package:flutter/material.dart';
import 'package:healthcare/screen/chart_screen.dart';


class HealthInfoPage extends StatefulWidget {
  @override
  _HealthInfoPageState createState() => _HealthInfoPageState();
}

class _HealthInfoPageState extends State<HealthInfoPage> {
  void navigateToDetail(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChartPage(title: title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('홍길동님의 건강정보'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // 설정 액션 추가
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: '24.01.10',
                  items: <String>['24.01.10', '25.01.11', '26.01.11']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    // 선택된 날짜 처리 로직
                  },
                  underline: Container(),
                ),
              ),

              // ---------------------6개 데이터 container----------------------
              StatRow(
                data: [
                  StatData(title: '맥박', value: '80 bpm', height: 100.0),
                  StatData(title: '산소포화도', value: '98 %', height: 100.0),
                ],
                onTap: (title) => navigateToDetail(context, title),
              ),
              StatRow(
                data: [
                  StatData(title: '체온', value: '36.5 °C', height: 100.0),
                  StatData(title: '체중', value: '50.2 kg', height: 100.0),
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
                      height: 100.0, // Set the height
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            '이동거리',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '2.34 km',
                            textAlign: TextAlign.center,
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
                      height: 100.0, // Set the height
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            '이동시간',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '1시간 34분',
                            textAlign: TextAlign.center,
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
    );
  }
}

// ------------맥박,산소포화도,체온,몸무게 UI----------------
class StatRow extends StatelessWidget {
  final List<StatData> data;
  final Function(String) onTap;

  const StatRow({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: data
          .map((stat) => Expanded(
                child: StatCard(
                  data: stat,
                  onTap: () => onTap(stat.title),
                ),
              ))
          .toList(),
    );
  }
}

class StatData {
  final String title;
  final String value;
  final double height;

  StatData({required this.title, required this.value, required this.height});
}

class StatCard extends StatelessWidget {
  final StatData data;
  final VoidCallback onTap;

  const StatCard({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Card(
          child: Container(
            height: data.height,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  data.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  data.value,
                  textAlign: TextAlign.center,
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
    );
  }
}
