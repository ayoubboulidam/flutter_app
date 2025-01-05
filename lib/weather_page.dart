import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String _city = "Rabat"; // Default city
  String apiKey = "d423c4dbc6c8d38caa4ea3bffcb5df05"; // OpenWeatherMap API key
  dynamic _weatherData;
  bool _isLoading = false;
  String _errorMessage = '';
  bool _showGif = false; // Determines whether to show the GIF
  String _countryName = ''; // Stores the updated country name

  // Fetch the weather data asynchronously
  Future<void> _getWeatherData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _showGif = false;
      _countryName = '';
    });

    String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$_city&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _weatherData = jsonDecode(response.body);

          // Check if the country code is "EH" (Western Sahara)
          if (_weatherData['sys']['country'] == "EH") {
            _countryName = "MA (Maroc)";
            _showGif = true; // Show the GIF for Western Sahara
          } else {
            _countryName = _weatherData['sys']['country'];
            _showGif = false; // Do not show the GIF for other countries
          }

          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load weather data';
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching weather: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Title Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              'Weather Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
          ),

          // Main Content Section
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Enter city name",
                        border: OutlineInputBorder(),
                        hintText: 'e.g., Rabat',
                      ),
                      onChanged: (value) {
                        _city = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _getWeatherData,
                      child: const Icon(
                        Icons.search,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : _errorMessage.isNotEmpty
                        ? Text(
                      _errorMessage,
                      style: const TextStyle(fontSize: 20, color: Colors.red),
                    )
                        : _weatherData != null
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'City: ${_weatherData['name']}',
                          style: const TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                        Text(
                          'Country: $_countryName',
                          style: const TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                        Text(
                          'Temperature: ${_weatherData['main']['temp']}°C',
                          style: const TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                        Text(
                          'Pressure: ${_weatherData['main']['pressure']} hPa',
                          style: const TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                        Text(
                          'Humidity: ${_weatherData['main']['humidity']}%',
                          style: const TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                        if (_showGif)
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Image.network(
                              'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
                              height: 100,
                            ),
                          ),
                      ],
                    )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),

          // Footer Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'Made by Ayoub Boulidam',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
