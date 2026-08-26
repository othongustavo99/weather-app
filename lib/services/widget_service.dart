import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';

class WidgetService {
  static const String _androidWidgetName = 'WeatherHomeWidgetProvider';
  static const String _iOSWidgetName = 'WeatherHomeWidget';

  static const String _qualifiedAndroidName =
      'com.example.weather_app.WeatherHomeWidgetProvider';

  static Future<bool> requestPinWidget({
    required String cityName,
    double? temperature,
    double? feelsLike,
    String? description,
    int? weatherCode,
    String unitSymbol = '°C',
  }) async {
    await _saveData(
      cityName: cityName,
      temperature: temperature,
      feelsLike: feelsLike,
      description: description,
      weatherCode: weatherCode,
      unitSymbol: unitSymbol,
    );

    try {
      await HomeWidget.updateWidget(
        name: _androidWidgetName,
        androidName: _androidWidgetName,
        iOSName: _iOSWidgetName,
        qualifiedAndroidName: _qualifiedAndroidName,
      );
    } catch (_) {}

    if (!kIsWeb && Platform.isAndroid) {
      try {
        final supported = await HomeWidget.isRequestPinWidgetSupported();

        if (supported != true) {
          return false;
        }

        await HomeWidget.requestPinWidget(
          name: _androidWidgetName,
          androidName: _androidWidgetName,
          qualifiedAndroidName: _qualifiedAndroidName,
        );

        return true;
      } on PlatformException {
        return false;
      } catch (_) {
        return false;
      }
    }

    return false;
  }

  static Future<void> updateWidgetData({
    required String cityName,
    double? temperature,
    double? feelsLike,
    String? description,
    int? weatherCode,
    String unitSymbol = '°C',
  }) async {
    await _saveData(
      cityName: cityName,
      temperature: temperature,
      feelsLike: feelsLike,
      description: description,
      weatherCode: weatherCode,
      unitSymbol: unitSymbol,
    );

    try {
      await HomeWidget.updateWidget(
        name: _androidWidgetName,
        androidName: _androidWidgetName,
        iOSName: _iOSWidgetName,
        qualifiedAndroidName: _qualifiedAndroidName,
      );
    } catch (_) {}
  }

  static Future<void> _saveData({
    required String cityName,
    double? temperature,
    double? feelsLike,
    String? description,
    int? weatherCode,
    String unitSymbol = '°C',
  }) async {
    await HomeWidget.saveWidgetData<String>('city_name', cityName);

    await HomeWidget.saveWidgetData<String>(
      'temperature',
      temperature != null ? '${temperature.round()}$unitSymbol' : '--',
    );

    await HomeWidget.saveWidgetData<String>(
      'feels_like',
      feelsLike != null ? 'Sensação ${feelsLike.round()}$unitSymbol' : '',
    );

    await HomeWidget.saveWidgetData<String>(
      'description',
      description ?? 'HzClima',
    );

    await HomeWidget.saveWidgetData<String>(
      'weather_code',
      weatherCode?.toString() ?? '0',
    );

    final now = DateTime.now();

    await HomeWidget.saveWidgetData<String>(
      'updated_time',
      '${now.hour.toString().padLeft(2, '0')}:'
          '${now.minute.toString().padLeft(2, '0')}',
    );
  }
}
