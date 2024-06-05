import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../network/fetch_data.dart';

class MyBarChart extends StatefulWidget {
  final String title;
  final List<HealthData> dataList;
  final int selectedIndex;
  const MyBarChart(
      {required this.dataList,
      required this.title,
      required this.selectedIndex,
      super.key});

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

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    int index = value.toInt();
    if (index >= 0 && index < widget.dataList.length) {
      String date = widget.dataList[index].date;
      String day = int.parse(date.split('-').last).toString();
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
    if (widget.title == '이동시간') {
      // 이동시간인 경우에는 20의 배수인 값만 표시
      if (value % 20 != 0) {
        return Container();
      }
    } else if (widget.title == '이동거리') {
      // 이동거리인 경우에는 정수인 값만 표시
      if (value.toInt() != value) {
        return Container();
      }
    }

    // 위의 조건에 해당하지 않는 경우 값 표시
    return Text(
      value.toInt().toString(),
      style: const TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  BarChartData mainData() {
    double maxY = widget.dataList.map((data) => data.value.toDouble()).reduce((a, b) => a > b ? a : b);
    bool isIntegerY = maxY % 1 == 0;
    bool isMultipleOf20 = maxY % 20 == 0;

    // 상단 및 하단의 경계선.
    BorderSide topBorder = isIntegerY ? BorderSide(color: Colors.grey, width: 1) : BorderSide.none;
    BorderSide bottomBorder = BorderSide(color: Colors.grey, width: 2);

    return BarChartData(
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          fitInsideVertically: widget.selectedIndex == 1 ? true : false,
          fitInsideHorizontally: true,
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
              valueText = rod.toY.toString();
            }
            return BarTooltipItem(
              '$date\n$valueText ${widget.title == '이동시간' ? '분' : ' km'}',
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
            reservedSize: 30,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          top: widget.title == '이동시간' && isMultipleOf20 ? topBorder :
          widget.title == '이동거리' ? topBorder : BorderSide.none,
          bottom: bottomBorder,
        ),
      ),
      barGroups: createBarGroups(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: widget.title == '이동시간' ? 20 : 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
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
