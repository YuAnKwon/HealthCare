import 'package:flutter/material.dart';
import 'package:healthcare/graph/weekly_bar_chart.dart';
import 'package:healthcare/graph/weekly_line_chart.dart';

class ChartPage extends StatefulWidget {
  final String title;
  ChartPage({required this.title});

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  int selectedIndex = 0; // 0: 일별, 1: 주별, 2: 월별

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('분석 결과'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context); // 현재 화면을 스택에서 제거하여 이전 화면으로 돌아갑니다.
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                children: [
                  ToggleButtons(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('일별'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('주별'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('월별'),
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
                width: double.infinity, // Container를 화면의 전체 너비로 설정
                alignment: Alignment.center, // 텍스트를 가운데 정렬
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withAlpha(128),// 테두리 색상을 설정
                    width: 2.0, // 테두리 굵기를 설정
                  ),
                  borderRadius: BorderRadius.circular(4.0), // 테두리 둥근 처리를 위한 설정
                ),
                padding: EdgeInsets.symmetric(
                    vertical: 8.0), // 내부 텍스트와 테두리 사이의 여백을 설정
                child: Text(
                  '2024.01.04 ~ 2024.01.10', // 단순히 표시할 텍스트
                  style: TextStyle(
                    fontSize: 16.0, // 폰트 크기 설정
                    fontWeight: FontWeight.bold, // 글씨 굵기 설정
                  ),
                ),
              ),

              SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.centerLeft, // 텍스트를 왼쪽 정렬로 설정
                child: Text(
                  '${widget.title}', // 표시할 텍스트
                  style: TextStyle(
                    fontSize: 20.0, // 글꼴 크기를 조정
                  ),
                ),
              ),
              // - ----------그래프 ------------
              Container(
                padding: const EdgeInsets.fromLTRB(13, 40, 20, 20),
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withAlpha(128),// 테두리 색상 설정
                    width: 2, // 테두리 두께 설정
                  ),
                  borderRadius: BorderRadius.circular(12), // 테두리 모서리를 둥글게 만듭니다.
                ),
                child: MyBarChart(),
              ),

              SizedBox(height: 10.0),

              Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.centerLeft, // 텍스트를 왼쪽 정렬로 설정
                child: Text(
                  '평균 ${widget.title} : 3.20 km', // 표시할 텍스트
                  style: TextStyle(
                    fontSize: 20.0, // 글꼴 크기를 조정
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
class InformationCard extends StatelessWidget {
  final String title;
  final String value;

  const InformationCard({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity, // 카드를 화면의 전체 너비로 설정
        height: 180.0, // 카드의 높이를 120.0으로 설정
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              value,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            // 여기에 변경사항에 대한 텍스트를 추가할 수 있습니다.
          ],
        ),
      ),
    );
  }
}

