import 'package:cs492_weather_app/models/weather_forecast.dart';
import '../../models/user_location.dart';
import 'package:flutter/material.dart';
import '../location/location.dart';
import 'package:weather_icons/weather_icons.dart';
// https://github.com/worldturtlemedia/weather_icons

class WeatherScreen extends StatefulWidget {
  final Function getLocation;
  final Function getForecasts;
  final Function getForecastsHourly;
  final Function setLocation;

  const WeatherScreen(
      {super.key,
      required this.getLocation,
      required this.getForecasts,
      required this.getForecastsHourly,
      required this.setLocation});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  Widget build(BuildContext context) {
    return (widget.getLocation() != null && widget.getForecasts().isNotEmpty
        ? ForecastWidget(
            context: context,
            location: widget.getLocation(),
            hourly_forecasts: widget.getForecastsHourly(),
            forecasts: widget.getForecasts(),
          )
        : LocationWidget(widget: widget));
  }
}

class ForecastWidget extends StatelessWidget {
  final UserLocation location;
  final List<WeatherForecast> hourly_forecasts;
  final BuildContext context;
  final List<WeatherForecast> forecasts;

  const ForecastWidget(
      {super.key,
      required this.context,
      required this.location,
      required this.hourly_forecasts,
      required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: SizedBox(
        width: 500,
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                // Add this
                flex: 1,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BoxedIcon(
                        getIcon(
                          forecasts.elementAt(0).shortForecast,
                          forecasts.elementAt(0).isDaytime,
                        )),
                      CurrentTemperatureWidget(forecasts: hourly_forecasts)
                    ]),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    LocationTextWidget(location: location),
                    DescriptionWidget(forecasts: hourly_forecasts),
                    HourlyTemperatureWidget(forecasts: hourly_forecasts),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({
    super.key,
    required this.forecasts,
  });

  final List<WeatherForecast> forecasts;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      width: 500,
      child: Text(
        forecasts.elementAt(0).shortForecast,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.right,
      ),
    );
  }
}

class CurrentTemperatureWidget extends StatelessWidget {
  const CurrentTemperatureWidget({
    super.key,
    required this.forecasts,
  });

  final List<WeatherForecast> forecasts;

  @override
  Widget build(BuildContext context) {
    return Text('${forecasts.elementAt(0).temperature}º',
        style: Theme.of(context).textTheme.displayLarge);
  }
}

class LocationTextWidget extends StatelessWidget {
  const LocationTextWidget({
    super.key,
    required this.location,
  });

  final UserLocation location;

  @override
  Widget build(BuildContext context) {
    return Text(
      "${location.city}",
      style: Theme.of(context).textTheme.headlineSmall,
      textAlign: TextAlign.right,
    );
  }
}

class LocationWidget extends StatelessWidget {
  const LocationWidget({
    super.key,
    required this.widget,
  });

  final WeatherScreen widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Requires a location to begin"),
          ),
          Location(
              setLocation: widget.setLocation, getLocation: widget.getLocation),
        ],
      ),
    );
  }
}

class HourlyTemperatureWidget extends StatelessWidget {
  const HourlyTemperatureWidget({
    super.key,
    required this.forecasts,
  });

  final List<WeatherForecast> forecasts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: forecasts
              .take(4)
              .map((forecast) => BoxedIcon(
                    getIcon(
                      forecast.shortForecast,
                      forecast.isDaytime,
                    ),
                  ))
              .toList(),
              ),
        Row(
          children: forecasts
              .take(4)
              .map((forecast) => Text('${forecast.temperature}º      ',
                  style: Theme.of(context).textTheme.labelSmall))
              .toList(),
        ),
      ],
    );
  }
}

// function that takes in short forecasts and returns an appropriate icon based on if isDaytime true or false, and if the forecast is for rain, snow, or clear
IconData getIcon(String shortForecast, bool isDaytime) {
  if (shortForecast.toLowerCase().contains("rain")) {
    return isDaytime ? WeatherIcons.day_rain : WeatherIcons.night_rain;
  } else if (shortForecast.toLowerCase().contains("snow")) {
    return isDaytime ? WeatherIcons.day_snow : WeatherIcons.night_snow;
  } else {
    return isDaytime ? WeatherIcons.day_sunny : WeatherIcons.night_clear;
  }
}