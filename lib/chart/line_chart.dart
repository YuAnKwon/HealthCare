// 7일, 31일, 12개월 데이터를 꺾은선 그래프로 표시

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../network/fetch_data.dart';

class MyLineChart extends StatefulWidget {
  final String title;
  final List<HealthData> dataList;
  final int selectedIndex;
  const MyLineChart(
      {required this.dataList,
      required this.title,
      required this.selectedIndex,
      super.key});

  @override
  State<MyLineChart> createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  List<Color> gradientColors = [
    const Color(0xff8873B7),
    const Color(0xff8562BB),
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.dataList.isEmpty) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: LineChart(
        mainData(),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    int index = value.toInt();
    if (index >= 0 && index < widget.dataList.length) {
      String date = widget.dataList[index].date;
      String day =
          int.parse(date.split('-').last).toString(); // 일자를 정수로 변환하여 앞의 0을 제거

      String label = day;
      if (index == widget.dataList.length - 1) {
        if (widget.selectedIndex == 2) {
          label += '월';
        } else {
          label += '일';
        }
      }

      return Text(
        label,
        style: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );
    }
    return Container();
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black54,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    // 심박수이고 최대 값이 10의 배수인 경우에만 표시
    if (widget.title == '심박수') {
      if (value % 10 == 0) {
        String text = value.toInt().toString();
        return Text(text, style: style, textAlign: TextAlign.left);
      } else {
        return Container();
      }
    } else {
      String text = value.toInt().toString();
      return Text(text, style: style, textAlign: TextAlign.left);
    }
  }



  LineChartData mainData() {
    double minY = 200;
    double maxY = -2;

    List<FlSpot> spots = [];
    for (int i = 0; i < widget.dataList.length; i++) {
      int dayIndex = i % widget.dataList.length; // x값
      double value = widget.dataList[i].value.toDouble(); // y 값
      spots.add(FlSpot(dayIndex.toDouble(), value));

      if (value < minY) minY = value;
      if (value > maxY) maxY = value;
    }

    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          fitInsideVertically: widget.selectedIndex == 1 ? true : false,
          fitInsideHorizontally: true,
          tooltipBgColor: Colors.white,
          tooltipBorder: const BorderSide(color: Color(0xffA595C8)),
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final flSpot = touchedSpot;
              if (flSpot.barIndex == 0) {
                String date = widget.dataList[flSpot.x.toInt()].date;
                String unit = '';
                if (widget.title == '산소포화도') {
                  unit = '%';
                } else if (widget.title == '심박수') {
                  unit = 'bpm';
                } else if (widget.title == '체온') {
                  unit = '°C';
                } else if (widget.title == '체중') {
                  unit = 'kg';
                }
                String tooltipText =
                    '$date\n${flSpot.y.toStringAsFixed(unit == '%' || unit == 'bpm' ? 0 : 1)} $unit';
                return LineTooltipItem(
                  tooltipText,
                  const TextStyle(
                    color: Color(0xff8562BB),
                    fontWeight: FontWeight.bold,
                  ),
                );
              }
              return null;
            }).toList();
          },
        ),
      ),

      minY: widget.title == '심박수'
          ? (minY ~/ 10) * 10
          : widget.title == '산소포화도'
              ? minY - 2
              : minY.floorToDouble(),
      maxY: maxY.ceilToDouble(),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            //reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: widget.title == '심박수' ? 10 : 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 30,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey),
      ),

      // 그리드
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: widget.title == '심박수' ? 10 : 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
      ),

      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
