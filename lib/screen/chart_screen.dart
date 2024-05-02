import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:healthcare/graph/weekly_bar_chart.dart';
import 'package:healthcare/graph/weekly_line_chart.dart';
import 'package:http/http.dart' as http;

import '../network/7days_data.dart';
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

    switch (widget.title) {
      case '이동거리':
        fieldEndpoint = 'distance';
        break;
      case '맥박':
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
      Uri.parse('${ApiResource.serverUrl}/days/$fieldEndpoint'),
      headers: {"ngrok-skip-browser-warning": "22"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> dataList = json.decode(response.body)['7days_data'];
      setState(() {
        HealthDataList = dataList
            .map((json) => HealthData.fromJson(json, fieldEndpoint))
            .toList();
      });
      print(dataList);
    } else {
      throw Exception('Failed to load data');
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('7일'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('31일'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('12개월'),
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
                });
              },
            ),
          ],
        ),
        SizedBox(height: 20.0),
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
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            getDateRange(),
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: Text(
            '${widget.title} ${widget.title != '이동시간' ? '(${widget.title == '체온' ? '°C' : widget.title == '이동거리' ? 'km' : widget.title == '산소포화도' ? '%' : widget.title == '맥박' ? 'bpm' : ''})' : ''}',
            style: TextStyle(
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
        title: Text('분석 결과'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
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
              SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.fromLTRB(13, 40, 20, 20),
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
              SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  '평균 ${widget.title} : ${widget.title == '이동시간' ? '${calculateAverageTime()}' : '${calculateAverage().toStringAsFixed(1)} ${widget.title == '이동거리' ? 'km' : widget.title == '체중' ? 'kg' : widget.title == '체온' ? '°C' : widget.title == '산소포화도' ? '%' : widget.title == '맥박' ? 'bpm' : ''}'}',
                  style: TextStyle(
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

// 평균값 계산
  double calculateAverage() {
    double totalValue = 0.0;
    for (final data in HealthDataList) {
      totalValue += data.value.toDouble();
    }
    return totalValue / HealthDataList.length;
  }

// 이동시간 평균값 계산
  String calculateAverageTime() {
    if (HealthDataList.isEmpty) {
      return '데이터 없음'; // 데이터가 비어 있는 경우 처리
    }

    int totalHours = 0;
    int totalMinutes = 0;

    for (final data in HealthDataList) {
      final timeParts = data.value.split(':');
      final hours = int.parse(timeParts[0]);
      final minutes = int.parse(timeParts[1]);

      totalHours += hours;
      totalMinutes += minutes;
    }

    // 분 단위가 60분을 넘어가면 시간에 반영
    totalHours += totalMinutes ~/ 60;
    totalMinutes %= 60;

    // 평균값 계산
    final averageHours = totalHours ~/ HealthDataList.length;
    final averageMinutes = totalMinutes ~/ HealthDataList.length;

    // 시간과 분을 합쳐서 반환
    return '$averageHours시간 $averageMinutes분';
  }

  Widget _buildChart() {
    switch (widget.title) {
      case '맥박':
      case '산소포화도':
      case '체온':
      case '체중':
        return MyLineChart(dataList: HealthDataList);
      case '이동거리':
      case '이동시간':
        return MyBarChart();
      default:
        return Container();
    }
  }
}
