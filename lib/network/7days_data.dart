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
        value = json[field].toString(); // 이동시간 데이터는 문자열로 변환
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
