// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_weather/models/weather_model.dart';
import 'package:my_weather/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  static const String api_key = "API_KEY";
  final _weatherService = WeatherService(api_key);
  Weather? _weather;

  // fetch weather data
  void _fetchWeather() async {
    // get current city
    final String city = await _weatherService.getCurrentCity();
    try {
      // get weather details
      final weather = await _weatherService.getWeather(city);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // weather animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return "assets/loading.json";
    }

    switch (mainCondition.toLowerCase()) {
      case "clouds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return "assets/cloudy.json";
      case "rain":
      case "drizzle":
      case "shower rain":
        return "assets/rainy.json";
      case "thunderstorm":
        return "assets/thunderstorm.json";
      case "clear":
        return "assets/sunny.json";

      default:
        return "assets/deafault.json";
    }
  }

  // init state
  @override
  void initState() {
    super.initState();
    // fetch weather data on init
    _fetchWeather();
  }

  // weather animation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // location icon animation
            SizedBox(
              width: 200, // Replace with your desired width
              height: 200, // Replace with your desired height
              child: Lottie.asset("assets/location.json"),
            ),
            // city name
            Text(
              _weather?.cityName ?? "Loading...",
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),


            // animation
            SizedBox(
              width: 300, // Replace with your desired width
              height: 300, // Replace with your desired height
              child: Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            ),
            

            // weather condition with styling
            Text(
              _weather?.mainCondition ?? "",
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),

            // weather description with styling
            Text(
              _weather?.description ?? "",
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),

            // temperature with styling
            Text(
              '${_weather?.temperature.round() ?? ""}°C',
              style: const TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            // feels like with styling
            Text(
              'Feels like: ${_weather?.feelslike.round() ?? ""}°C',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
