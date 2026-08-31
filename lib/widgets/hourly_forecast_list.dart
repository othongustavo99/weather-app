import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/weather_model.dart';
import '../utils/weather_code_helper.dart';

class HourlyForecastList extends StatelessWidget {
  final List<HourlyForecast> forecasts;

  const HourlyForecastList({super.key, required this.forecasts});

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
            'Próximas horas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.grey.shade800,
            ),
          ),
        ),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: forecasts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final hour = forecasts[index];
              final isNow = index == 0;

              final timeLabel = isNow
                  ? 'Agora'
                  : DateFormat('HH:mm').format(hour.time);

              final showPrecip =
                  hour.precipitationProbability != null &&
                  hour.precipitationProbability! > 0;

              return Container(
                width: 72,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(18),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Temperatura
                    Text(
                      '${hour.temperature.toStringAsFixed(0)}°',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),

                    // Ícone + % de chuva
                    Column(
                      children: [
                        Icon(
                          WeatherCodeHelper.icon(
                            hour.weatherCode,
                            time: hour.time,
                          ),
                          size: 28,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        if (showPrecip) ...[
                          const SizedBox(height: 2),
                          Text(
                            '${hour.precipitationProbability}%',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? Colors.lightBlueAccent
                                  : Colors.blue.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Horário
                    Text(
                      timeLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isNow ? FontWeight.w600 : FontWeight.w400,
                        color: isDark ? Colors.white60 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
