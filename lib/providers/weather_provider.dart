import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../services/widget_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _service = WeatherService();

  WeatherModel? weather;
  String cityName = '';
  bool isLoading = false;
  String? errorMessage;
  bool isFromLocation = false;
  bool useFahrenheit = false;
  List<String> favorites = [];
  List<CitySuggestion> suggestions = [];
  bool isSearchingSuggestions = false;

  static const _keyFavorites = 'favorites';
  static const _keyUnit = 'use_fahrenheit';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    favorites = prefs.getStringList(_keyFavorites) ?? [];
    useFahrenheit = prefs.getBool(_keyUnit) ?? false;
    notifyListeners();
  }

  Future<void> _syncWidget() async {
    if (weather == null) return;
    try {
      await WidgetService.updateWidgetData(
        cityName: cityName,
        temperature: weather!.temperature,
        feelsLike: weather!.feelsLike,
        description: weather!.description,
        weatherCode: weather!.weatherCode,
        unitSymbol: unitSymbol,
      );
    } catch (_) {}
  }

  Future<void> toggleUnit() async {
    useFahrenheit = !useFahrenheit;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyUnit, useFahrenheit);

    // Recarrega o clima atual na nova unidade
    if (weather != null) {
      if (isFromLocation) {
        await loadByLocation();
      } else if (cityName.isNotEmpty) {
        await loadByCity(cityName);
      }
    }
    notifyListeners();
  }

  Future<void> loadByCity(String city) async {
    if (city.trim().isEmpty) {
      errorMessage = 'Digite o nome de uma cidade';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    weather = null;
    isFromLocation = false;
    suggestions = [];
    notifyListeners();

    try {
      final result = await _service.getWeatherByCity(
        city,
        useFahrenheit: useFahrenheit,
      );
      weather = result;
      cityName = result.locationName ?? city;
      await _addFavorite(cityName);
      await _syncWidget();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadBySuggestion(CitySuggestion suggestion) async {
    isLoading = true;
    errorMessage = null;
    weather = null;
    isFromLocation = false;
    suggestions = [];
    notifyListeners();

    try {
      final result = await _service.getWeatherByCoords(
        latitude: suggestion.latitude,
        longitude: suggestion.longitude,
        locationName: suggestion.displayName,
        useFahrenheit: useFahrenheit,
      );
      weather = result;
      cityName = result.locationName ?? suggestion.displayName;
      await _addFavorite(cityName);
      await _syncWidget();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadByLocation() async {
    isLoading = true;
    errorMessage = null;
    weather = null;
    isFromLocation = true;
    suggestions = [];
    notifyListeners();

    try {
      final result = await _service.getWeatherByCurrentLocation(
        useFahrenheit: useFahrenheit,
      );
      weather = result;
      cityName = result.locationName ?? 'Minha localização';
      await _syncWidget();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    if (isFromLocation) {
      await loadByLocation();
    } else if (cityName.isNotEmpty) {
      await loadByCity(cityName);
    }
  }

  Future<void> searchSuggestions(String query) async {
    if (query.trim().length < 2) {
      suggestions = [];
      isSearchingSuggestions = false;
      notifyListeners();
      return;
    }

    isSearchingSuggestions = true;
    notifyListeners();

    try {
      suggestions = await _service.searchCities(query);
    } catch (_) {
      suggestions = [];
    } finally {
      isSearchingSuggestions = false;
      notifyListeners();
    }
  }

  void clearSuggestions() {
    suggestions = [];
    notifyListeners();
  }

  Future<void> _addFavorite(String name) async {
    if (name.isEmpty || name == 'Minha localização') return;
    favorites.remove(name);
    favorites.insert(0, name);
    if (favorites.length > 8) {
      favorites = favorites.sublist(0, 8);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyFavorites, favorites);
    notifyListeners();
  }

  Future<void> removeFavorite(String name) async {
    favorites.remove(name);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyFavorites, favorites);
    notifyListeners();
  }

  String get unitSymbol => useFahrenheit ? '°F' : '°C';
}
