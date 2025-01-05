import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to TP1'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to our App!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/calculs'),
              child: const Text('Go to Calculator'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/weather'),
              child: const Text('Go to Weather App'),
            ),
          ],
        ),
      ),
    );
  }
}
