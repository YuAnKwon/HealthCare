// ------------맥박,산소포화도,체온,몸무게 UI----------------
import 'package:flutter/material.dart';

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
  final String imagePath;

  StatData(
      {required this.title,
        required this.value,
        required this.height,
        required this.imagePath});
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(data.imagePath, height: 25.0), // 이미지 크기 조정
                    SizedBox(width: 8.0),
                    Text(
                      data.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Text(
                  data.value,
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

class StatRowWidget extends StatelessWidget {
  final List<StatData> data;
  final Function(String) onTap;

  const StatRowWidget({
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: data
          .map((statData) => GestureDetector(
        onTap: () => onTap(statData.title),
        child: Column(
          children: [
            Image.asset(
              statData.imagePath,
              height: 24.0,
            ),
            SizedBox(height: 8.0),
            Text(
              statData.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.0),
            Text(
              statData.value,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ))
          .toList(),
    );
  }
}


// 01:42로 받을 시간 데이터를 1시간 42로 바꿔주는 함수
String formatWorkoutTime(String workoutTime) {
  if (workoutTime.isEmpty) return '';

  List<String> parts = workoutTime.split(':');

  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);

  String formattedTime = '';

  if (hours > 0) {
    formattedTime += '${hours}시간 ';
  }

  if (minutes > 0) {
    formattedTime += '${minutes}분';
  }

  return formattedTime.trim();
}

