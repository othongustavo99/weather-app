import 'package:flutter_test/flutter_test.dart';
import 'package:hz_clima/models/weather_model.dart';

void main() {
  group('WeatherModel', () {
    test('deve criar corretamente a partir do JSON com daily', () {
      final json = {
        'current': {
          'temperature_2m': 25.5,
          'wind_speed_10m': 12.3,
          'weather_code': 1,
          'relative_humidity_2m': 70,
          'apparent_temperature': 26.0,
          'precipitation': 0.0,
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
      expect(weather.humidity, 70.0);
      expect(weather.feelsLike, 26.0);
      expect(weather.precipitation, 0.0);
      expect(weather.dailyForecast.length, 2);
      expect(weather.dailyForecast[0].maxTemp, 28.0);
      expect(
        weather.dailyForecast[0].description,
        'Limpo',
      ); // short: true no daily
      expect(weather.dailyForecast[1].weatherCode, 61);
      expect(weather.dailyForecast[1].description, 'Chuva');
    });

    test('description deve retornar texto correto', () {
      final sunny = WeatherModel(
        temperature: 30,
        windSpeed: 5,
        weatherCode: 0,
        fetchedAt: DateTime.now(),
      );
      final rainy = WeatherModel(
        temperature: 18,
        windSpeed: 15,
        weatherCode: 61,
        fetchedAt: DateTime.now(),
      );
      final storm = WeatherModel(
        temperature: 22,
        windSpeed: 40,
        weatherCode: 95,
        fetchedAt: DateTime.now(),
      );
      final cloudy = WeatherModel(
        temperature: 20,
        windSpeed: 8,
        weatherCode: 2,
        fetchedAt: DateTime.now(),
      );

      expect(sunny.description, 'Céu limpo');
      expect(rainy.description, 'Chuva');
      expect(storm.description, 'Tempestade');
      expect(cloudy.description, 'Parcialmente nublado');
    });

    test('fromJson sem daily deve funcionar', () {
      final json = {
        'current': {
          'temperature_2m': 22.0,
          'wind_speed_10m': 5.0,
          'weather_code': 0,
        },
      };

      final weather = WeatherModel.fromJson(json, locationName: 'Lisboa');

      expect(weather.temperature, 22.0);
      expect(weather.locationName, 'Lisboa');
      expect(weather.dailyForecast, isEmpty);
    });
  });

  group('CitySuggestion', () {
    test('displayName monta nome completo', () {
      final city = CitySuggestion(
        name: 'São Paulo',
        admin1: 'São Paulo',
        country: 'Brasil',
        latitude: -23.55,
        longitude: -46.63,
      );

      expect(city.displayName, 'São Paulo, São Paulo, Brasil');
    });

    test('fromJson preenche campos', () {
      final city = CitySuggestion.fromJson({
        'name': 'Lisboa',
        'admin1': 'Lisboa',
        'country': 'Portugal',
        'latitude': 38.72,
        'longitude': -9.14,
      });

      expect(city.name, 'Lisboa');
      expect(city.latitude, 38.72);
      expect(city.displayName, 'Lisboa, Lisboa, Portugal');
    });
  });
}
