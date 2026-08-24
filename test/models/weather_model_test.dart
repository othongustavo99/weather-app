import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/models/weather_model.dart';

void main() {
  test('deve criar WeatherModel corretamente a partir do JSON', () {
    final json = {
      'current': {
        'temperature_2m': 25.5,
        'wind_speed_10m': 12.3,
        'weather_code': 1,
      },
    };

    final weather = WeatherModel.fromJson(json);

    expect(weather.temperature, 25.5);
    expect(weather.windSpeed, 12.3);
    expect(weather.weatherCode, 1);
  });
}