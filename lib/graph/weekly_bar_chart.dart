import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarChart extends StatefulWidget {
  const MyBarChart({Key? key});

  @override
  State<StatefulWidget> createState() => _MyBarChartState();
}

class _MyBarChartState extends State<MyBarChart> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: BarChart(
        BarChartData(
          barTouchData: barTouchData,
          titlesData: titlesData,
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey, // 테두리 색상 설정
                width: 2, // 테두리 두께 설정
              ),
            ),
          ),
          barGroups: barGroups,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              if (value % 1 == 0) {
                return FlLine(
                  color: Colors.grey,
                  strokeWidth: 1,
                );
              } else {
                // 그리드 선을 숨기기 위해 투명한 색을 설정
                return FlLine(
                  color: Colors.transparent,
                  strokeWidth: 0,
                );
              }
            },
          ),
        ),
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
    enabled: true,
    touchTooltipData: BarTouchTooltipData(
      tooltipBgColor: Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 8,
      getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
          ) {
        return BarTooltipItem(
          rod.toY.toStringAsFixed(2), // 반올림 없이 소수점 두 자리까지 표시
          const TextStyle(
            color: const Color(0xff8562BB),
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.black54,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '4';
        break;
      case 1:
        text = '5';
        break;
      case 2:
        text = '6';
        break;
      case 3:
        text = '7';
        break;
      case 4:
        text = '8';
        break;
      case 5:
        text = '9';
        break;
      case 6:
        text = '10';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: AxisTitles(
      drawBelowEverything: true,
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 40,
        interval: 1, // y label 간격
        getTitlesWidget: (double value, TitleMeta meta) {
          if (value == meta.max) {
            return const SizedBox.shrink();
          }
          return Text('${value.toInt()}km');
        },
      ),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );

  List<BarChartGroupData> get barGroups => [
    BarChartGroupData(
      x: 0,
      barRods: [
        BarChartRodData(
          toY: 2.32,
          color: const Color(0xff8562BB),
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 1,
      barRods: [
        BarChartRodData(
          toY: 0.4,
          color: const Color(0xff8562BB),
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 2,
      barRods: [
        BarChartRodData(
          toY: 3.22,
          color: const Color(0xff8562BB),
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 3,
      barRods: [
        BarChartRodData(
          toY: 0.9,
          color: const Color(0xff8562BB),
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 4,
      barRods: [
        BarChartRodData(
          toY: 2.63,
          color: const Color(0xff8562BB),
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 5,
      barRods: [
        BarChartRodData(
          toY: 3.7,
          color: const Color(0xff8562BB),
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 6,
      barRods: [
        BarChartRodData(
          toY: 1.4,
          color: const Color(0xff8562BB),
        )
      ],
      showingTooltipIndicators: [0],
    ),
  ];
}
