class WeatherModel {
  final double temperature;
  final double windSpeed;
  final int weatherCode;

  WeatherModel({
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'];

    return WeatherModel(
      temperature: (current['temperature_2m'] as num).toDouble(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      weatherCode: current['weather_code'] as int,
    );
  }
}