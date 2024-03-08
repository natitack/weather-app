import 'dart:convert';

import './user_location.dart';
import 'package:http/http.dart' as http;

class WeatherForecast {
  final String name;
  final bool isDaytime;
  final int temperature;
  final String windSpeed;
  final String windDirection;
  final String shortForecast;
  final String detailedForecast;

  const WeatherForecast({
    required this.name,
    required this.isDaytime,
    required this.temperature,
    required this.windSpeed,
    required this.windDirection,
    required this.shortForecast,
    required this.detailedForecast,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String name,
        'isDaytime': bool isDaytime,
        'temperature': int temperature,
        'windSpeed': String windSpeed,
        'windDirection': String windDirection,
        'shortForecast': String shortForecast,
        'detailedForecast': String detailedForecast,
      } =>
        WeatherForecast(
          name: name,
          isDaytime: isDaytime,
          temperature: temperature,
          windSpeed: windSpeed,
          windDirection: windDirection,
          shortForecast: shortForecast,
          detailedForecast: detailedForecast,
        ),
      _ => throw const FormatException('Failed to load Weather Forecast.'),
    };
  }
}

Future<List<WeatherForecast>> getHourlyForecasts(UserLocation location) async {
  return getWeatherForecasts(location, true);
}

Future<List<WeatherForecast>> getTwiceDailyForecasts(
    UserLocation location) async {
  return getWeatherForecasts(location, false);
}

Future<List<WeatherForecast>> getWeatherForecasts(
    UserLocation location, bool hourly) async {
  // casts latitude and longitude to strings with 2 fixed digits
  // for example: 123.456789 -> '123.45'
  String lat = location.latitude.toStringAsFixed(2);
  String long = location.longitude.toStringAsFixed(2);

  // send a request to the weather api to get forecast details
  String forecastUrl = "https://api.weather.gov/points/$lat,$long";
  http.Response forecastResponse = await http.get(Uri.parse(forecastUrl));
  final Map<String, dynamic> forecastJson = jsonDecode(forecastResponse.body);

  // grabs the forecasts url from the json response
  final String currentForecastsUrl = hourly
      ? forecastJson["properties"]["forecastHourly"]
      : forecastJson["properties"]["forecast"];

  // send another request to the API which will return the specifics of the twice-daily forecasts
  http.Response currentForecastsResponse =
      await http.get(Uri.parse(currentForecastsUrl));
  final Map<String, dynamic> currentForecastsJson =
      jsonDecode(currentForecastsResponse.body);

  // gets the list of forecasts from the forecast request
  List<dynamic> forecastJsons = currentForecastsJson["properties"]["periods"];

  // uses json data to create list of WeatherForecast objects
  List<WeatherForecast> forecasts = [];
  for (final forecastJson in forecastJsons) {
    forecasts.add(WeatherForecast.fromJson(forecastJson));
  }

  return forecasts;
}

// create a list of just the next 12 hours of temperature forecasts
Future<List<int>> getHourlyTemperatures(UserLocation location) async {
  List<WeatherForecast> forecasts = await getHourlyForecasts(location);
  List<int> temperatures = [];
  for (int i = 0; i < 12; i++) {
    temperatures.add(forecasts[i].temperature);
  }
  // extract temperature from each list item and return a list of just the temperatures
  temperatures = forecasts.map((forecast) => forecast.temperature).toList();
  return temperatures;
}
