import 'package:flutter/material.dart';
import 'package:weather_app/pages/calculs.page.dart';
import 'package:weather_app/pages/home.page.dart';
import 'package:weather_app/pages/weather.page.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TP1',
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/calculs': (context) => const CalculsPage(),
        '/weather': (context) => const WeatherPage(),
      },
    );
  }
}
