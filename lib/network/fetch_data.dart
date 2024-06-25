//mainscreen의 화면에 표시할 데이터 수신

class HealthData {
  final String date;
  final dynamic value;

  HealthData({required this.date, required this.value});

  factory HealthData.fromJson(Map<String, dynamic> json, String field) {
    dynamic value;

    switch (field) {
      case 'distance':
        value = json['distance'];
        break;
      case 'heart':
        value = json['heart'];
        break;
      case 'oxygen':
        value = json['oxygen'];
        break;
      case 'temp':
        value = json['temp'];
        break;
      case 'today_weight':
        value = json['today_weight'];
        break;
      case 'workout_time':
      // 이동시간 문자열을 분 단위로 변환
        String workoutTimeString = json['workout_time'];
        List<String> parts = workoutTimeString.split(':');
        int hours = int.parse(parts[0]);
        int minutes = int.parse(parts[1]);
        value = hours * 60 + minutes;
        break;
      default:
        break;
    }

    return HealthData(
      date: json['date'],
      value: value,
    );
  }
}
