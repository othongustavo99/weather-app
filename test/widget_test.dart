import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hz_clima/main.dart';
import 'package:hz_clima/pages/home_page.dart';

void main() {
  testWidgets('App deve iniciar na Splash sem erros', (WidgetTester tester) async {
    await tester.pumpWidget(const WeatherApp());
    // Splash existe
    expect(find.textContaining('continuar'), findsOneWidget);
  });

  testWidgets('HomePage mostra título e campo de busca', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomePage()),
    );
    expect(find.text('Clima'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}