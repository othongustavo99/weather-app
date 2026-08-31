import '../utils/weather_code_helper.dart';

class WeatherModel {
  final double temperature;
  final double windSpeed;
  final int weatherCode;
  final double? humidity;
  final double? feelsLike;
  final double? precipitation;
  final List<DailyForecast> dailyForecast;
  final List<HourlyForecast> hourlyForecast;
  final String? locationName;
  final DateTime fetchedAt;
  final double? latitude;
  final double? longitude;

  const WeatherModel({
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
    this.humidity,
    this.feelsLike,
    this.precipitation,
    this.dailyForecast = const [],
    this.hourlyForecast = const [],
    this.locationName,
    required this.fetchedAt,
    this.latitude,
    this.longitude,
  });

  factory WeatherModel.fromJson(
    Map<String, dynamic> json, {
    String? locationName,
  }) {
    final current = json['current'] as Map<String, dynamic>;

    // ----- Daily -----
    List<DailyForecast> daily = [];
    if (json['daily'] != null) {
      final dailyData = json['daily'] as Map<String, dynamic>;
      final times = dailyData['time'] as List;
      final maxTemps = dailyData['temperature_2m_max'] as List;
      final minTemps = dailyData['temperature_2m_min'] as List;
      final codes = dailyData['weather_code'] as List;

      for (int i = 0; i < times.length; i++) {
        daily.add(
          DailyForecast(
            date: DateTime.parse(times[i] as String),
            maxTemp: (maxTemps[i] as num).toDouble(),
            minTemp: (minTemps[i] as num).toDouble(),
            weatherCode: codes[i] as int,
          ),
        );
      }
    }

    // ----- Hourly -----
    List<HourlyForecast> hourly = [];
    if (json['hourly'] != null) {
      final hourlyData = json['hourly'] as Map<String, dynamic>;
      final times = hourlyData['time'] as List;
      final temps = hourlyData['temperature_2m'] as List;
      final codes = hourlyData['weather_code'] as List;
      final precipProb = hourlyData['precipitation_probability'] as List?;

      final now = DateTime.now();

      for (int i = 0; i < times.length; i++) {
        final time = DateTime.parse(times[i] as String);

        // Pega só as próximas 24 horas a partir da hora atual
        if (time.isBefore(now.subtract(const Duration(hours: 1)))) continue;
        if (hourly.length >= 24) break;

        hourly.add(
          HourlyForecast(
            time: time,
            temperature: (temps[i] as num).toDouble(),
            weatherCode: codes[i] as int,
            precipitationProbability: precipProb != null
                ? (precipProb[i] as num).toInt()
                : null,
          ),
        );
      }
    }

    return WeatherModel(
      temperature: (current['temperature_2m'] as num).toDouble(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      weatherCode: current['weather_code'] as int,
      humidity: current['relative_humidity_2m'] != null
          ? (current['relative_humidity_2m'] as num).toDouble()
          : null,
      feelsLike: current['apparent_temperature'] != null
          ? (current['apparent_temperature'] as num).toDouble()
          : null,
      precipitation: current['precipitation'] != null
          ? (current['precipitation'] as num).toDouble()
          : null,
      dailyForecast: daily,
      hourlyForecast: hourly,
      locationName: locationName,
      fetchedAt: DateTime.now(),
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
    );
  }

  String get description => WeatherCodeHelper.description(weatherCode);
}

class DailyForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final int weatherCode;

  const DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherCode,
  });

  String get description =>
      WeatherCodeHelper.description(weatherCode, short: true);
}

class HourlyForecast {
  final DateTime time;
  final double temperature;
  final int weatherCode;
  final int? precipitationProbability;

  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.weatherCode,
    this.precipitationProbability,
  });

  String get description =>
      WeatherCodeHelper.description(weatherCode, short: true);
}

class CitySuggestion {
  final String name;
  final String? admin1;
  final String? country;
  final double latitude;
  final double longitude;

  const CitySuggestion({
    required this.name,
    this.admin1,
    this.country,
    required this.latitude,
    required this.longitude,
  });

  String get displayName {
    final parts = <String>[name];
    if (admin1 != null && admin1!.isNotEmpty) parts.add(admin1!);
    if (country != null && country!.isNotEmpty) parts.add(country!);
    return parts.join(', ');
  }

  factory CitySuggestion.fromJson(Map<String, dynamic> json) {
    return CitySuggestion(
      name: json['name'] as String? ?? '',
      admin1: json['admin1'] as String?,
      country: json['country'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}