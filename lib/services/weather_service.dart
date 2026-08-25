import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';

class WeatherService {
  final http.Client client;

  WeatherService({http.Client? client}) : client = client ?? http.Client();

  static const String _forecastUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String _geocodingUrl = 'https://geocoding-api.open-meteo.com/v1/search';

  Future<WeatherModel> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(
      '$_forecastUrl?latitude=$latitude&longitude=$longitude'
      '&current=temperature_2m,wind_speed_10m,weather_code'
      '&daily=weather_code,temperature_2m_max,temperature_2m_min'
      '&forecast_days=5'
      '&timezone=auto',
    );

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return WeatherModel.fromJson(json);
    }

    throw Exception('Falha ao buscar o clima (${response.statusCode})');
  }

  Future<WeatherModel> getWeatherByCity(String city) async {
    final geoUri = Uri.parse(
      '$_geocodingUrl?name=${Uri.encodeComponent(city)}&count=1&language=pt&format=json',
    );

    final geoResponse = await client.get(geoUri);

    if (geoResponse.statusCode != 200) {
      throw Exception('Erro ao buscar a cidade');
    }

    final geoJson = jsonDecode(geoResponse.body) as Map<String, dynamic>;
    final results = geoJson['results'] as List?;

    if (results == null || results.isEmpty) {
      throw Exception('Cidade não encontrada');
    }

    final location = results.first as Map<String, dynamic>;
    final lat = (location['latitude'] as num).toDouble();
    final lon = (location['longitude'] as num).toDouble();

    return getWeather(latitude: lat, longitude: lon);
  }

  /// Busca clima pela localização atual do usuário
  Future<WeatherModel> getWeatherByCurrentLocation() async {
    final position = await _determinePosition();
    return getWeather(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Serviço de localização desativado. Ative o GPS.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Permissão permanentemente negada. Vá nas configurações do celular.',
      );
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    );
  }
}