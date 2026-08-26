import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:hz_clima/services/weather_service.dart';

void main() {
  group('WeatherService', () {
    test('getWeather deve retornar WeatherModel com daily', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'current': {
              'temperature_2m': 28.4,
              'wind_speed_10m': 9.1,
              'weather_code': 0,
              'relative_humidity_2m': 55,
              'apparent_temperature': 29.0,
              'precipitation': 0.0,
            },
            'daily': {
              'time': ['2026-08-24', '2026-08-25', '2026-08-26'],
              'temperature_2m_max': [30.0, 29.0, 28.5],
              'temperature_2m_min': [19.0, 18.5, 18.0],
              'weather_code': [0, 2, 61],
            },
          }),
          200,
        );
      });

      final service = WeatherService(client: mockClient);
      final weather = await service.getWeather(
        latitude: -23.55,
        longitude: -46.63,
      );

      expect(weather.temperature, 28.4);
      expect(weather.windSpeed, 9.1);
      expect(weather.weatherCode, 0);
      expect(weather.description, 'Céu limpo');
      expect(weather.humidity, 55.0);
      expect(weather.dailyForecast.length, 3);
      expect(weather.dailyForecast[2].description, 'Chuva');
    });

    test('getWeatherByCity deve funcionar com geocoding + forecast', () async {
      final mockClient = MockClient((request) async {
        if (request.url.host.contains('geocoding')) {
          return http.Response(
            jsonEncode({
              'results': [
                {
                  'latitude': -23.55,
                  'longitude': -46.63,
                  'name': 'São Paulo',
                  'admin1': 'São Paulo',
                  'country': 'Brasil',
                },
              ],
            }),
            200,
          );
        }

        return http.Response(
          jsonEncode({
            'current': {
              'temperature_2m': 26.0,
              'wind_speed_10m': 11.2,
              'weather_code': 2,
            },
            'daily': {
              'time': ['2026-08-24'],
              'temperature_2m_max': [27.0],
              'temperature_2m_min': [17.0],
              'weather_code': [2],
            },
          }),
          200,
        );
      });

      final service = WeatherService(client: mockClient);
      final weather = await service.getWeatherByCity('São Paulo');

      expect(weather.temperature, 26.0);
      expect(weather.weatherCode, 2);
      expect(weather.dailyForecast.length, 1);
      expect(weather.description, 'Parcialmente nublado');
    });

    test('deve lançar Exception quando cidade não é encontrada', () async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({'results': []}), 200);
      });

      final service = WeatherService(client: mockClient);

      expect(
        () => service.getWeatherByCity('CidadeInexistenteXYZ'),
        throwsA(isA<Exception>()),
      );
    });

    test('deve lançar Exception em status HTTP de erro', () async {
      final mockClient = MockClient((request) async {
        return http.Response('erro', 500);
      });

      final service = WeatherService(client: mockClient);

      expect(
        () => service.getWeather(latitude: 0, longitude: 0),
        throwsA(isA<Exception>()),
      );
    });
  });
}
