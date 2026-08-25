import 'package:flutter/material.dart';

class WeatherCodeHelper {
  static String description(int code, {bool short = false}) {
    switch (code) {
      case 0:
        return short ? 'Limpo' : 'Céu limpo';
      case 1:
      case 2:
      case 3:
        return short ? 'Nublado' : 'Parcialmente nublado';
      case 45:
      case 48:
        return 'Neblina';
      case 51:
      case 53:
      case 55:
        return short ? 'Chuvisco' : 'Chuvisco';
      case 61:
      case 63:
      case 65:
        return 'Chuva';
      case 71:
      case 73:
      case 75:
        return 'Neve';
      case 80:
      case 81:
      case 82:
        return short ? 'Pancadas' : 'Pancadas de chuva';
      case 95:
      case 96:
      case 99:
        return 'Tempestade';
      default:
        return short ? '—' : 'Condição desconhecida';
    }
  }

  static IconData icon(int code) {
    switch (code) {
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

  static List<Color> gradientColors(int code) {
    if (code == 0) {
      return [const Color(0xFF56CCF2), const Color(0xFF2F80ED)];
    }
    if (code <= 3) {
      return [const Color(0xFF89CFF0), const Color(0xFF5B86E5)];
    }
    if (code >= 51 && code <= 82) {
      return [const Color(0xFF4A6FA5), const Color(0xFF2C3E50)];
    }
    if (code >= 95) {
      return [const Color(0xFF434343), const Color(0xFF1C1C1C)];
    }
    return [const Color(0xFF667EEA), const Color(0xFF764BA2)];
  }
}