import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../network/fetch_data.dart';

class MyBarChart extends StatefulWidget {
  final String title;
  final List<HealthData> dataList;
  const MyBarChart({required this.dataList, required this.title, super.key});

  @override
  State<StatefulWidget> createState() => _MyBarChartState();
}

class _MyBarChartState extends State<MyBarChart> {
  @override
  Widget build(BuildContext context) {
    if (widget.dataList.isEmpty) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: BarChart(
        mainData(),
      ),
    );
  }

  // Widget build(BuildContext context) {
  //   if (widget.dataList.isEmpty) {
  //     return Container();
  //   }
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal, // 수평 스크롤 가능하도록 설정
  //     child: Padding(
  //       padding: const EdgeInsets.all(5.0),
  //       child: SizedBox(
  //         // 그래프의 너비를 화면보다 크게 설정하여 수평 스크롤이 가능하도록 합니다.
  //         width: MediaQuery.of(context).size.width * 2,
  //         child: BarChart(
  //           mainData(),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    int index = value.toInt();
    if (index >= 0 && index < widget.dataList.length) {
      String date = widget.dataList[index].date;
      String day = int.parse(date.split('-').last).toString();
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
    if (value != meta.max) {
      return Text(
        value.toInt().toString(),
        style: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );
    }
    return Container(); // maxY 값일 때는 빈 컨테이너 반환
  }

  BarChartData mainData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.white,
          tooltipBorder: const BorderSide(color: Color(0xffA595C8)),
          getTooltipItem: (
              BarChartGroupData group,
              int groupIndex,
              BarChartRodData rod,
              int rodIndex,
              ) {
            String valueText;
            String date = widget.dataList[group.x.toInt()].date;
            if (widget.title == '이동시간') {
              valueText = rod.toY.toInt().toString();
            } else {
              valueText = rod.toY.toStringAsFixed(1);
            }
            return BarTooltipItem(
              '$date\n$valueText ${widget.title == '이동시간' ? ' 분' : ' km'}',
              const TextStyle(
                color: Color(0xff8562BB),
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),

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
            interval: widget.title == '이동시간' ? 20 : 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 40,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 2,
          ),
        ),
      ),
      barGroups: createBarGroups(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: widget.title == '이동시간' ? 20 : 1,
        getDrawingHorizontalLine: (value) {
          if (value % 1 == 0) {
            return const FlLine(
              color: Colors.grey,
              strokeWidth: 1,
            );
          } else {
            return const FlLine(
              color: Colors.transparent,
              strokeWidth: 0,
            );
          }
        },
      ),
      alignment: BarChartAlignment.spaceBetween,
    );
  }

  List<BarChartGroupData> createBarGroups() {
    List<BarChartGroupData> barGroups = [];
    List<int> showTooltips = const [];

    for (int i = 0; i < widget.dataList.length; i++) {
      HealthData data = widget.dataList[i];
      String stringValue = data.value.toString();

      double toYValue = double.parse(stringValue);

      BarChartGroupData barGroup = BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: toYValue,
            color: const Color(0xff8562BB),
          )
        ],
        showingTooltipIndicators: showTooltips,
      );
      barGroups.add(barGroup);
    }
    return barGroups;
  }
}
