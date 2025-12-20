import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Map<String, dynamic>> getWeather(double latitude, double longitude) async {
    final url = 'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$latitude,$longitude';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, dynamic>> getForecast(double latitude, double longitude, {int days = 3}) async {
    final url = 'http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$latitude,$longitude&days=$days&aqi=no&alerts=yes';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load forecast data');
    }
  }
}
