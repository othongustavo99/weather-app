class WeatherModel {
  final double temperature;
  final double windSpeed;
  final int weatherCode;
  final List<DailyForecast> dailyForecast;

  const WeatherModel({
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
    this.dailyForecast = const [],
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;

    List<DailyForecast> daily = [];
    if (json['daily'] != null) {
      final dailyData = json['daily'] as Map<String, dynamic>;
      final times = dailyData['time'] as List;
      final maxTemps = dailyData['temperature_2m_max'] as List;
      final minTemps = dailyData['temperature_2m_min'] as List;
      final codes = dailyData['weather_code'] as List;

      for (int i = 0; i < times.length; i++) {
        daily.add(DailyForecast(
          date: DateTime.parse(times[i] as String),
          maxTemp: (maxTemps[i] as num).toDouble(),
          minTemp: (minTemps[i] as num).toDouble(),
          weatherCode: codes[i] as int,
        ));
      }
    }

    return WeatherModel(
      temperature: (current['temperature_2m'] as num).toDouble(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      weatherCode: current['weather_code'] as int,
      dailyForecast: daily,
    );
  }

  String get description {
    switch (weatherCode) {
      case 0:
        return 'Céu limpo';
      case 1:
      case 2:
      case 3:
        return 'Parcialmente nublado';
      case 45:
      case 48:
        return 'Neblina';
      case 51:
      case 53:
      case 55:
        return 'Chuvisco';
      case 61:
      case 63:
      case 65:
        return 'Chuva';
      case 71:
      case 73:
      case 75:
        return 'Neve';
      case 80:
      case 81:
      case 82:
        return 'Pancadas de chuva';
      case 95:
      case 96:
      case 99:
        return 'Tempestade';
      default:
        return 'Condição desconhecida';
    }
  }
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

  String get description {
    switch (weatherCode) {
      case 0:
        return 'Limpo';
      case 1:
      case 2:
      case 3:
        return 'Nublado';
      case 45:
      case 48:
        return 'Neblina';
      case 51:
      case 53:
      case 55:
      case 61:
      case 63:
      case 65:
      case 80:
      case 81:
      case 82:
        return 'Chuva';
      case 71:
      case 73:
      case 75:
        return 'Neve';
      case 95:
      case 96:
      case 99:
        return 'Tempestade';
      default:
        return '—';
    }
  }
}