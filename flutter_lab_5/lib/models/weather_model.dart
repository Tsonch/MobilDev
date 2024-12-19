
class Wheather {
  final String currentTemp;
  final List<DailyForecast> forecast;

  Wheather({
    required this.currentTemp,
    required this.forecast,
  });

  factory Wheather.fromJson(Map<String, dynamic> json) {
    final forecastDays = json['forecast']['forecastday'] as List;
    return Wheather(
      currentTemp: (json['current']['temp_c']).toString(),
      forecast: forecastDays.map((day) => DailyForecast.fromJson(day)).toList()
    );
  }
}

class DailyForecast {
  final String date;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String icon;

  DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.icon,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: json['date'],
      maxTemp: json['day']['maxtemp_c'],
      minTemp: json['day']['mintemp_c'],
      condition: json['day']['condition']['text'],
      icon: json['day']['condition']['icon'],
    );
  }
}