import 'package:flutter/material.dart';

class CalculsPage extends StatefulWidget {
  const CalculsPage({super.key});

  @override
  State<CalculsPage> createState() => _CalculsPageState();
}

class _CalculsPageState extends State<CalculsPage> {
  double _result = 0.0;
  double _operand1 = 0.0;
  double _operand2 = 0.0;
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  void _add() => setState(() => _result = _operand1 + _operand2);
  void _subtract() => setState(() => _result = _operand1 - _operand2);
  void _multiply() => setState(() => _result = _operand1 * _operand2);
  void _divide() => setState(() => _result = _operand2 != 0 ? _operand1 / _operand2 : double.nan);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller1,
              decoration: const InputDecoration(labelText: 'Enter first number'),
              keyboardType: TextInputType.number,
              onChanged: (text) => _operand1 = double.tryParse(text) ?? 0.0,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controller2,
              decoration: const InputDecoration(labelText: 'Enter second number'),
              keyboardType: TextInputType.number,
              onChanged: (text) => _operand2 = double.tryParse(text) ?? 0.0,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _add, child: const Text('+')),
                ElevatedButton(onPressed: _subtract, child: const Text('-')),
                ElevatedButton(onPressed: _multiply, child: const Text('*')),
                ElevatedButton(onPressed: _divide, child: const Text('/')),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _result.isNaN ? 'Error: Division by zero' : 'Result: $_result',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
