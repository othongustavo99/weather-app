import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/models/weather_model.dart';

void main() {
  group('WeatherModel', () {
    test('deve criar corretamente a partir do JSON com daily', () {
      final json = {
        'current': {
          'temperature_2m': 25.5,
          'wind_speed_10m': 12.3,
          'weather_code': 1,
        },
        'daily': {
          'time': ['2026-08-24', '2026-08-25'],
          'temperature_2m_max': [28.0, 27.5],
          'temperature_2m_min': [18.0, 17.2],
          'weather_code': [0, 61],
        },
      };

      final weather = WeatherModel.fromJson(json);

      expect(weather.temperature, 25.5);
      expect(weather.windSpeed, 12.3);
      expect(weather.weatherCode, 1);
      expect(weather.dailyForecast.length, 2);
      expect(weather.dailyForecast[0].maxTemp, 28.0);
      expect(weather.dailyForecast[1].weatherCode, 61);
      expect(weather.dailyForecast[1].description, 'Chuva');
    });

    test('description deve retornar texto correto', () {
      final sunny = WeatherModel(temperature: 30, windSpeed: 5, weatherCode: 0);
      final rainy = WeatherModel(temperature: 18, windSpeed: 15, weatherCode: 61);
      final storm = WeatherModel(temperature: 22, windSpeed: 40, weatherCode: 95);

      expect(sunny.description, 'Céu limpo');
      expect(rainy.description, 'Chuva');
      expect(storm.description, 'Tempestade');
    });
  });
}