import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import '../utils/weather_code_helper.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;
  final String cityName;
  final String unitSymbol;

  const WeatherCard({
    super.key,
    required this.weather,
    required this.cityName,
    required this.unitSymbol,
  });

  @override
  Widget build(BuildContext context) {
    final colors = WeatherCodeHelper.gradientColors(weather.weatherCode);
    final updatedAt = DateFormat('HH:mm').format(weather.fetchedAt);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: colors.last.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              cityName.toUpperCase(),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Atualizado às $updatedAt',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            Icon(
              WeatherCodeHelper.icon(weather.weatherCode),
              size: 72,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              '${weather.temperature.toStringAsFixed(1)}$unitSymbol',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 64,
                fontWeight: FontWeight.w200,
                height: 1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              weather.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 22),
            // Métricas extras
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                _metricChip(Icons.air_rounded, '${weather.windSpeed.toStringAsFixed(1)} km/h'),
                if (weather.feelsLike != null)
                  _metricChip(
                    Icons.thermostat_rounded,
                    'Sensação ${weather.feelsLike!.toStringAsFixed(1)}$unitSymbol',
                  ),
                if (weather.humidity != null)
                  _metricChip(Icons.water_drop_outlined, '${weather.humidity!.toStringAsFixed(0)}%'),
                if (weather.precipitation != null)
                  _metricChip(
                    Icons.umbrella_rounded,
                    '${weather.precipitation!.toStringAsFixed(1)} mm',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}