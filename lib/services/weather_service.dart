import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  // Open-Meteo (gratuita, sem API key)
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  /// Busca o clima por latitude e longitude
  Future<WeatherModel> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl?latitude=$latitude&longitude=$longitude'
      '&current=temperature_2m,wind_speed_10m,weather_code'
      '&timezone=auto',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return WeatherModel.fromJson(json);
    } else {
      throw Exception('Erro ao buscar o clima: ${response.statusCode}');
    }
  }

  /// Busca clima por nome da cidade (usando geocoding do Open-Meteo)
  Future<WeatherModel> getWeatherByCity(String city) async {
    // 1. Geocoding
    final geoUri = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=${Uri.encodeComponent(city)}&count=1&language=pt&format=json',
    );

    final geoResponse = await http.get(geoUri);

    if (geoResponse.statusCode != 200) {
      throw Exception('Erro ao buscar a cidade');
    }

    final geoJson = jsonDecode(geoResponse.body) as Map<String, dynamic>;
    final results = geoJson['results'] as List?;

    if (results == null || results.isEmpty) {
      throw Exception('Cidade não encontrada: $city');
    }

    final location = results.first as Map<String, dynamic>;
    final lat = (location['latitude'] as num).toDouble();
    final lon = (location['longitude'] as num).toDouble();

    // 2. Busca o clima
    return getWeather(latitude: lat, longitude: lon);
  }
}