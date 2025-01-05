// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/main.dart';

void main() {
  testWidgets('Weather app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WeatherApp());

    // Verify that the main elements are present.
    expect(find.text('Weather'), findsOneWidget); // AppBar title
    expect(find.byType(TextField), findsOneWidget); // City input
    expect(find.byType(ElevatedButton), findsOneWidget); // Search button

    // Simulate entering a city name.
    await tester.enterText(find.byType(TextField), 'Rabat');
    expect(find.text('Rabat'), findsOneWidget);

    // Simulate tapping the search button.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Since API calls are asynchronous, we can't verify live data here.
    // You would need to mock the API response for further testing.
  });
}
