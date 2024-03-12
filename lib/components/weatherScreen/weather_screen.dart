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
        height: 160,
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
                      BoxedIcon(getIcon(
                        forecasts.elementAt(0).shortForecast,
                        forecasts.elementAt(0).isDaytime,
                      )),
                      CurrentTemperatureWidget(forecasts: hourly_forecasts),
                      TwiceDailyTemperatureWidget(forecasts: forecasts),
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

class TwiceDailyTemperatureWidget extends StatelessWidget {
  const TwiceDailyTemperatureWidget({
    super.key,
    required this.forecasts,
  });

  final List<WeatherForecast> forecasts;

  @override
  Widget build(BuildContext context) {
    return Text(
        '${forecasts.elementAt(0).temperature}º / ${forecasts.elementAt(1).temperature}º',
        style: Theme.of(context).textTheme.displaySmall);
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
          mainAxisAlignment: MainAxisAlignment.end,
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
          mainAxisAlignment: MainAxisAlignment.end,
          children: forecasts
              .take(4)
              .map(
                (forecast) => Text(
                  '    ${forecast.temperature}º  ',
                  style: Theme.of(context).textTheme.labelSmall,
                  textAlign: TextAlign.right,
                ),
              )
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
  } else if (shortForecast.toLowerCase().contains("clear")) {
    return isDaytime ? WeatherIcons.day_sunny : WeatherIcons.night_clear;
  } else if (shortForecast.toLowerCase().contains("cloud")) {
    return isDaytime ? WeatherIcons.day_cloudy : WeatherIcons.night_cloudy;
  } else if (shortForecast.toLowerCase().contains("fog")) {
    return isDaytime ? WeatherIcons.day_fog : WeatherIcons.night_fog;
  } else if (shortForecast.toLowerCase().contains("haze")) {
    return isDaytime ? WeatherIcons.day_haze : WeatherIcons.day_haze;
  } else if (shortForecast.toLowerCase().contains("sleet")) {
    return isDaytime ? WeatherIcons.day_sleet : WeatherIcons.night_sleet;
  } else if (shortForecast.toLowerCase().contains("wind")) {
    return isDaytime ? WeatherIcons.day_windy : WeatherIcons.day_windy;
  } else if (shortForecast.toLowerCase().contains("thunder")) {
    return isDaytime
        ? WeatherIcons.day_thunderstorm
        : WeatherIcons.night_thunderstorm;
  } else if (shortForecast.toLowerCase().contains("overcast")) {
    return isDaytime
        ? WeatherIcons.day_sunny_overcast
        : WeatherIcons.night_alt_partly_cloudy;
  } else if (shortForecast.toLowerCase().contains("sunny")) {
    return isDaytime ? WeatherIcons.day_sunny : WeatherIcons.night_clear;
  } else {
    return WeatherIcons.alien;
  }
}
