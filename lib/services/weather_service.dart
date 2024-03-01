// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_weather/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String api_key = "API_KEY";

  WeatherService(api_key);

  Future<Weather> getWeather(String city) async {
    // final url = "$BASE_URL?q=$city&appid=$api_key&units=metric";
    // final response = await http.get(Uri.parse(url));
    
    final response = await http.get(
      Uri.https(
        BASE_URL,
        "",
        {
          "q": city,
          "appid": api_key,
          "units": "metric",
        },
      ),
    );
    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load weather data");
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.requestPermission();
    while (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Convert the location into a list of placemark  objects
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // extract city name from the first placemark
    String? city = placemarks[0].locality;

    return city ?? "";
  }
}
