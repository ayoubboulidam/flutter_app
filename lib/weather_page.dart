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
        title: Text(
          'Weather',
          style: TextStyle(fontSize: 30, color: Colors.red),
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(25),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _getWeatherData,
                child: Icon(
                  Icons.search,
                  size: 40,
                ),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : _errorMessage.isNotEmpty
                  ? Text(
                _errorMessage,
                style: TextStyle(fontSize: 20, color: Colors.red),
              )
                  : _weatherData != null
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'City: ${_weatherData['name']}',
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                  Text(
                    'Country: $_countryName',
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                  Text(
                    'Temperature: ${_weatherData['main']['temp']}°C',
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                  Text(
                    'Pressure: ${_weatherData['main']['pressure']} hPa',
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                  Text(
                    'Humidity: ${_weatherData['main']['humidity']}%',
                    style: TextStyle(fontSize: 20, color: Colors.blue),
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
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
