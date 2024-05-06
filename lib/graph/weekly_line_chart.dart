import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../network/fetchData.dart';

class MyLineChart extends StatefulWidget {
  final String title;
  final List<HealthData> dataList;
  const MyLineChart({required this.dataList, required this.title, super.key});

  @override
  State<MyLineChart> createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  List<Color> gradientColors = [
    const Color(0xffB3A5D1),
    const Color(0xff8562BB),
  ];

  @override
  Widget build(BuildContext context) {
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
        // 데이터 리스트의 마지막 값일 때만 '일' 추가
        label += '일';
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
    String text = value.toInt().toString();
    return Text(text, style: style, textAlign: TextAlign.left);
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
      minY: widget.title == '심박수' ? (minY ~/ 5) * 5: minY.floorToDouble(),
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
            interval: widget.title == '심박수' ? 10 : 1, // heart 데이터만 받을 때 interval을 10
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 40,
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
        horizontalInterval: widget.title == '심박수' ? 10 : 1, // heart 데이터만 받을 때 interval을 10,
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
