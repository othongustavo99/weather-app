import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hz_clima/main.dart';
import 'package:hz_clima/pages/home_page.dart';
import 'package:hz_clima/pages/splash_page.dart';
import 'package:hz_clima/providers/weather_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App deve iniciar na Splash sem erros', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => WeatherProvider()..init(),
        child: const WeatherApp(),
      ),
    );

    await tester.pump();

    expect(find.byType(SplashPage), findsOneWidget);
    expect(find.text('Carregando...'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('HomePage mostra título e campo de busca', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => WeatherProvider()..init(),
        child: const MaterialApp(home: HomePage()),
      ),
    );

    await tester.pump();

    expect(find.text('HzClima'), findsOneWidget);
    expect(find.text('Consulte o tempo em qualquer lugar'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('°C'), findsOneWidget);
  });

  testWidgets('HomePage exibe mensagem de boas-vindas sem clima', (
    tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => WeatherProvider()..init(),
        child: const MaterialApp(home: HomePage()),
      ),
    );

    await tester.pump();

    expect(find.text('Bem-vindo ao HzClima!'), findsOneWidget);
  });
}
