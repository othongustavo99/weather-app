import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/main.dart';

void main() {
  testWidgets('App deve iniciar sem erros', (WidgetTester tester) async {
    await tester.pumpWidget(const WeatherApp());

    // Verifica se o título "Clima" aparece
    expect(find.text('Clima'), findsOneWidget);

    // Verifica se o campo de busca existe
    expect(find.byType(TextField), findsOneWidget);
  });
}