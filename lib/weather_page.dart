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
  String _weatherIcon = ''; // URL for the weather icon

  // Fetch the weather data asynchronously
  Future<void> _getWeatherData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _showGif = false;
      _countryName = '';
      _weatherIcon = ''; // Reset the icon
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
            _countryName = "MA";
            _showGif = true; // Show the GIF for Western Sahara
          } else {
            _countryName = _weatherData['sys']['country'];
            _showGif = false; // Do not show the GIF for other countries
          }

          // Set the weather icon
          String iconCode = _weatherData['weather'][0]['icon'];
          _weatherIcon = 'https://openweathermap.org/img/wn/$iconCode@2x.png';

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

  // Get the background image based on weather condition
  String _getBackgroundImage() {
    if (_weatherData == null) {
      return 'assets/images/default.jpg';
    }

    String condition = _weatherData['weather'][0]['main'].toLowerCase();
    if (condition.contains('clear')) {
      return 'assets/images/clear_sky.jpg';
    } else if (condition.contains('rain')) {
      return 'assets/images/rain.jpg';
    } else if (condition.contains('snow')) {
      return 'assets/images/snow.jpg';
    } else if (condition.contains('cloud')) {
      return 'assets/images/cloudy.jpg';
    } else {
      return 'assets/images/default.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          // Background image depends on weather
          image: DecorationImage(
            image: AssetImage(_getBackgroundImage()),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App title
                Text(
                  'Weather App\nMade by Ayoub Boulidam',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // City input field
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Enter city name",
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Rabat',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    _city = value;
                  },
                ),
                const SizedBox(height: 20),
                // Search button
                ElevatedButton(
                  onPressed: _getWeatherData,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Icon(Icons.search, size: 30),
                ),
                const SizedBox(height: 20),
                // Weather data container
                if (_isLoading)
                  const CircularProgressIndicator()
                else if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: const TextStyle(fontSize: 20, color: Colors.red),
                  )
                else if (_weatherData != null)
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Weather icon
                          if (_weatherIcon.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Image.network(
                                _weatherIcon,
                                height: 100,
                                width: 100,
                              ),
                            ),
                          Text(
                            'City: ${_weatherData['name']}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Country: $_countryName',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Temperature: ${_weatherData['main']['temp']}°C',
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Pressure: ${_weatherData['main']['pressure']} hPa',
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Humidity: ${_weatherData['main']['humidity']}%',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 20),
                          if (_showGif)
                            Image.network(
                              'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
                              height: 100,
                            ),
                        ],
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
