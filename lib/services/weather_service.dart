import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import '../models/weather_model.dart';

class WeatherService {
  final http.Client client;

  WeatherService({http.Client? client}) : client = client ?? http.Client();

  static const String _forecastUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String _geocodingUrl =
      'https://geocoding-api.open-meteo.com/v1/search';

    Future<WeatherModel> getWeather({
    required double latitude,
    required double longitude,
    String? locationName,
    bool useFahrenheit = false,
  }) async {
    final tempUnit = useFahrenheit ? 'fahrenheit' : 'celsius';
    final uri = Uri.parse(
      '$_forecastUrl?latitude=$latitude&longitude=$longitude'
      '&current=temperature_2m,relative_humidity_2m,apparent_temperature,'
      'precipitation,wind_speed_10m,weather_code'
      '&hourly=temperature_2m,weather_code,precipitation_probability'
      '&daily=weather_code,temperature_2m_max,temperature_2m_min'
      '&forecast_days=5'
      '&forecast_hours=24'
      '&temperature_unit=$tempUnit'
      '&timezone=auto',
    );

    try {
      final response = await client
          .get(uri)
          .timeout(const Duration(seconds: 12));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return WeatherModel.fromJson(json, locationName: locationName);
      }
      throw Exception('Falha ao buscar o clima (${response.statusCode})');
    } on SocketException {
      throw Exception(
        'Sem conexão com a internet. Verifique o Wi‑Fi ou os dados móveis.',
      );
    } on TimeoutException {
      throw Exception(
        'Tempo esgotado. Verifique sua conexão e tente novamente.',
      );
    } on http.ClientException {
      throw Exception(
        'Sem conexão com a internet. Verifique o Wi‑Fi ou os dados móveis.',
      );
    }
  }

  Future<WeatherModel> getWeatherByCity(
    String city, {
    bool useFahrenheit = false,
  }) async {
    final suggestions = await searchCities(city, count: 1);
    if (suggestions.isEmpty) {
      throw Exception('Cidade não encontrada');
    }
    final place = suggestions.first;
    return getWeather(
      latitude: place.latitude,
      longitude: place.longitude,
      locationName: place.displayName,
      useFahrenheit: useFahrenheit,
    );
  }

  Future<WeatherModel> getWeatherByCoords({
    required double latitude,
    required double longitude,
    required String locationName,
    bool useFahrenheit = false,
  }) {
    return getWeather(
      latitude: latitude,
      longitude: longitude,
      locationName: locationName,
      useFahrenheit: useFahrenheit,
    );
  }

  Future<WeatherModel> getWeatherByCurrentLocation({
    bool useFahrenheit = false,
  }) async {
    final position = await _determinePosition();
    final placeName = await _reverseGeocode(
      position.latitude,
      position.longitude,
    );
    return getWeather(
      latitude: position.latitude,
      longitude: position.longitude,
      locationName: placeName ?? 'Minha localização',
      useFahrenheit: useFahrenheit,
    );
  }

  Future<List<CitySuggestion>> searchCities(
    String query, {
    int count = 5,
  }) async {
    if (query.trim().length < 2) return [];

    final geoUri = Uri.parse(
      '$_geocodingUrl?name=${Uri.encodeComponent(query.trim())}'
      '&count=$count&language=pt&format=json',
    );

    try {
      final response = await client
          .get(geoUri)
          .timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return [];

      final geoJson = jsonDecode(response.body) as Map<String, dynamic>;
      final results = geoJson['results'] as List?;
      if (results == null) return [];

      return results
          .map((e) => CitySuggestion.fromJson(e as Map<String, dynamic>))
          .toList();
    } on SocketException {
      throw Exception(
        'Sem conexão com a internet. Verifique o Wi‑Fi ou os dados móveis.',
      );
    } on TimeoutException {
      throw Exception('Tempo esgotado ao buscar cidades.');
    } catch (_) {
      return [];
    }
  }

  Future<String?> _reverseGeocode(double lat, double lon) async {
    try {
      final uri = Uri.parse(
        'https://api.bigdatacloud.net/data/reverse-geocode-client'
        '?latitude=$lat&longitude=$lon&localityLanguage=pt',
      );
      final response = await client
          .get(uri)
          .timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return null;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final city =
          json['city'] as String? ??
          json['locality'] as String? ??
          json['principalSubdivision'] as String?;
      return (city != null && city.isNotEmpty) ? city : null;
    } catch (_) {
      return null;
    }
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
