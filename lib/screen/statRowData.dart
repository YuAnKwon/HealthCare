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