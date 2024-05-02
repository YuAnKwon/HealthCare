class HealthData {
  final String date;
  final double value;

  HealthData({required this.date, required this.value});

  factory HealthData.fromJson(Map<String, dynamic> json, String field) {
    double value = 0.0;

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
        value = json['workout_time'];
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
