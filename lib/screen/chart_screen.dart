import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:healthcare/graph/weekly_bar_chart.dart';
import 'package:healthcare/graph/weekly_line_chart.dart';
import 'package:http/http.dart' as http;

import '../network/fetch_data.dart';
import '../network/ApiResource.dart';

class ChartPage extends StatefulWidget {
  final String title;
  ChartPage({required this.title});

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<HealthData> HealthDataList = [];
  int selectedIndex = 0; // 0: 일별, 1: 주별, 2: 월별

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    String fieldEndpoint = '';
    String periodEndpoint = '';

    switch (selectedIndex) {
      case 0:
        periodEndpoint = 'days';
        break;
      case 1:
        periodEndpoint = 'months';
        break;
      case 2:
        periodEndpoint = 'years';
        break;
      default:
        break;
    }

    switch (widget.title) {
      case '이동거리':
        fieldEndpoint = 'distance';
        break;
      case '심박수':
        fieldEndpoint = 'heart';
        break;
      case '산소포화도':
        fieldEndpoint = 'oxygen';
        break;
      case '체온':
        fieldEndpoint = 'temp';
        break;
      case '체중':
        fieldEndpoint = 'today_weight';
        break;
      case '이동시간':
        fieldEndpoint = 'workout_time';
        break;
      default:
        break;
    }

    final response = await http.get(
      Uri.parse('${ApiResource.serverUrl}/$periodEndpoint/$fieldEndpoint'),
      headers: {"ngrok-skip-browser-warning": "22"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> dataList = json.decode(response.body)['${selectedIndex == 0 ? '7days' : selectedIndex == 1 ? '31days' : '12months'}_data'];
      setState(() {
        HealthDataList = dataList
            .map((json) => HealthData.fromJson(json, fieldEndpoint))
            .toList();
      });
      print(dataList);
    } else {
      // 데이터 불러오기 실패 시 에러 메시지 출력
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('오류발생'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 에러 다이얼로그 닫기
              },
              child: Text('확인'),
            ),
          ],
        ),
      );
    }
  }


  Widget _buildHeader() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ToggleButtons(
              children: <Widget>[
                 Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: const Text('7일'),
                ),
                 Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: const Text('31일'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: const Text('12개월'),
                ),
              ],
              isSelected: [
                selectedIndex == 0,
                selectedIndex == 1,
                selectedIndex == 2
              ],
              onPressed: (int index) {
                setState(() {
                  selectedIndex = index;
                  fetchData();
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColor.withAlpha(128),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            getDateRange(),
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: Text(
            '${widget.title} (${widget.title == '이동시간' ? '분' : (widget.title == '체온' ? '°C' : widget.title == '이동거리' ? 'km':  widget.title == '체중' ? 'kg' : widget.title == '산소포화도' ? '%' : widget.title == '심박수' ? 'bpm' : '')})',
            style: const TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
      ],
    );
  }

  // 데이터 받은 날짜 며칠부터 며칠까지인지 표시
  String getDateRange() {
    if (HealthDataList.isEmpty) {
      return ''; // 데이터가 없으면 빈 문자열 반환
    }

    // 첫 번째 데이터의 날짜
    String firstDate = HealthDataList.first.date;
    // 마지막 데이터의 날짜
    String lastDate = HealthDataList.last.date;

    // 첫 번째와 마지막 날짜로 날짜 범위 생성
    return '$firstDate ~ $lastDate';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('분석 결과'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              _buildHeader(),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 40, 15, 15),
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withAlpha(128),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _buildChart(),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  '평균 ${widget.title} : ${widget.title == '이동시간' ? calculateAverageTime() : '${calculateAverage().toStringAsFixed(1)} ${widget.title == '이동거리' ? 'km' : widget.title == '체중' ? 'kg' : widget.title == '체온' ? '°C' : widget.title == '산소포화도' ? '%' : widget.title == '심박수' ? 'bpm' : ''}'}',
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// 이동시간 평균값 계산
  double calculateAverage() {
    double totalValue = 0.0;
    int count = 0;

    for (final data in HealthDataList) {
      if (data.value != 0) { // 0을 제외하고
        totalValue += data.value.toDouble();
        count++;
      }
    }

    // 0을 제외한 값이 없는 경우 0을 반환
    if (count == 0) return 0.0;

    return totalValue / count;
  }


  String calculateAverageTime() {
    if (HealthDataList.isEmpty) {
      return ''; // 데이터가 비어 있는 경우 처리
    }

    int totalMinutes = 0;
    int totalCount = 0; // 이동시간이 0이 아닌 데이터의 수를 세는 변수

    for (final data in HealthDataList) {
      final minutes = data.value as int;
      if (minutes > 0) {
        totalMinutes += minutes;
        totalCount++; // 이동시간이 0이 아닌 경우에만 데이터 수 증가
      }
    }

    // 이동시간이 0인 경우 데이터가 없으므로 평균 계산이 불가능
    if (totalCount == 0) {
      return '';
    }

    // 데이터 수로 나누어 평균값을 구함
    final averageMinutes = totalMinutes ~/ totalCount;

    // 시간과 분을 계산
    final averageHours = averageMinutes ~/ 60;
    final remainingMinutes = averageMinutes % 60;

    // 시간과 분을 합쳐서 반환
    return '$averageHours시간 $remainingMinutes분';
  }


  Widget _buildChart() {
    switch (widget.title) {
      case '심박수':
      case '산소포화도':
      case '체온':
      case '체중':
        return MyLineChart(dataList: HealthDataList,title : widget.title);
      case '이동거리':
      case '이동시간':
        return MyBarChart(dataList: HealthDataList,title : widget.title);
      default:
        return Container(child: const Text('데이터 불러오기에 실패했습니다.'),);
    }
  }
}
