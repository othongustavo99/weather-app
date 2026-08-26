import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/weather_model.dart';
import '../utils/weather_code_helper.dart';

class ForecastList extends StatelessWidget {
  final List<DailyForecast> forecasts;

  const ForecastList({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    if (forecasts.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Próximos 5 dias',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.grey.shade800,
            ),
          ),
        ),
        ...forecasts.map((day) {
          final dayName = DateFormat('EEE', 'pt_BR').format(day.date);
          final dateStr = DateFormat('dd/MM').format(day.date);

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dayName.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white54 : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  WeatherCodeHelper.icon(day.weatherCode),
                  size: 28,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    day.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
                Text(
                  '${day.maxTemp.toStringAsFixed(0)}° / ${day.minTemp.toStringAsFixed(0)}°',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
