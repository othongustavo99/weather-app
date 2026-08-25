import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;
  final String cityName;

  const WeatherCard({
    super.key,
    required this.weather,
    required this.cityName,
  });

  IconData get _icon {
    switch (weather.weatherCode) {
      case 0:
        return Icons.wb_sunny_rounded;
      case 1:
      case 2:
      case 3:
        return Icons.cloud_rounded;
      case 45:
      case 48:
        return Icons.foggy;
      case 51:
      case 53:
      case 55:
      case 61:
      case 63:
      case 65:
      case 80:
      case 81:
      case 82:
        return Icons.water_drop_rounded;
      case 71:
      case 73:
      case 75:
        return Icons.ac_unit_rounded;
      case 95:
      case 96:
      case 99:
        return Icons.thunderstorm_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  List<Color> get _gradientColors {
    if (weather.weatherCode == 0) {
      return [const Color(0xFF56CCF2), const Color(0xFF2F80ED)]; // sol
    }
    if (weather.weatherCode <= 3) {
      return [const Color(0xFF89CFF0), const Color(0xFF5B86E5)];
    }
    if (weather.weatherCode >= 51 && weather.weatherCode <= 82) {
      return [const Color(0xFF4A6FA5), const Color(0xFF2C3E50)]; // chuva
    }
    if (weather.weatherCode >= 95) {
      return [const Color(0xFF434343), const Color(0xFF1C1C1C)]; // tempestade
    }
    return [const Color(0xFF667EEA), const Color(0xFF764BA2)]; // padrão
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradientColors,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: _gradientColors.last.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cidade
            Text(
              cityName.toUpperCase(),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            // Ícone
            Icon(
              _icon,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 12),

            // Temperatura
            Text(
              '${weather.temperature.toStringAsFixed(1)}°',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 72,
                fontWeight: FontWeight.w200,
                height: 1,
              ),
            ),
            const SizedBox(height: 8),

            // Descrição
            Text(
              weather.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 28),

            // Vento
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.air_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${weather.windSpeed.toStringAsFixed(1)} km/h',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}