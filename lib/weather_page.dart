import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';  // Import flutter_svg

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
  String _countryFlag = ''; // URL for the country flag
  String _weatherIcon = ''; // URL for the weather icon

  // Fetch the weather data asynchronously
  Future<void> _getWeatherData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _showGif = false;
      _countryName = '';
      _countryFlag = ''; // Reset the flag URL
      _weatherIcon = ''; // Reset the icon
    });

    String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$_city&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _weatherData = jsonDecode(response.body);

          if (_weatherData['sys']['country'] == "EH") {
            _countryName = "MA";
            _showGif = true;
          } else {
            _countryName = _weatherData['sys']['country'];
            _showGif = false;
          }

          String iconCode = _weatherData['weather'][0]['icon'];
          _weatherIcon = 'https://openweathermap.org/img/wn/$iconCode@2x.png';

          _fetchCountryFlag(_countryName);
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

  Future<void> _fetchCountryFlag(String countryCode) async {
    final response = await http.get(Uri.parse('https://restcountries.com/v3.1/alpha/$countryCode'));

    if (response.statusCode == 200) {
      final countryData = jsonDecode(response.body);
      setState(() {
        _countryFlag = countryData[0]['flags']['svg'];
      });
    } else {
      setState(() {
        _countryFlag = '';
      });
    }
  }

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
          image: DecorationImage(
            image: AssetImage(_getBackgroundImage()),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: _getWeatherData,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 35, vertical: 10),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: const Icon(Icons.search, size: 30),
                      ),
                      const SizedBox(height: 15),
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else if (_errorMessage.isNotEmpty)
                        Text(
                          _errorMessage,
                          style: const TextStyle(fontSize: 20, color: Colors.red),
                        )
                      else if (_weatherData != null)
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_countryFlag.isNotEmpty)
                                      SvgPicture.network(
                                        _countryFlag,
                                        width: 25,
                                        height: 20,
                                      ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Country: $_countryName',
                                      style: const TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                if (_weatherIcon.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Image.network(
                                      _weatherIcon,
                                      height: 80,
                                      width: 80,
                                    ),
                                  ),
                                Text(
                                  'City: ${_weatherData['name']}',
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Temperature: ${_weatherData['main']['temp']}°C',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(
                                  'Pressure: ${_weatherData['main']['pressure']} hPa',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(
                                  'Humidity: ${_weatherData['main']['humidity']}%',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 10),
                                if (_showGif)
                                  Image.network(
                                    'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
                                    height: 80,
                                  ),
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.black.withOpacity(0.8),
              child: const Text(
                'Made by Ayoub Boulidam',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
