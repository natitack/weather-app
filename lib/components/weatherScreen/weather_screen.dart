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
            forecasts: widget.getForecastsHourly())
        : LocationWidget(widget: widget));
  }
}

class ForecastWidget extends StatelessWidget {
  final UserLocation location;
  final List<WeatherForecast> forecasts;
  final BuildContext context;

  const ForecastWidget(
      {super.key,
      required this.context,
      required this.location,
      required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: SizedBox(
        width: 500,
        height: 200,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded( // Add this
              flex: 1,
              child: Column(
                children: [BoxedIcon(WeatherIcons.fromString(
                    "wi-day-${forecasts.elementAt(0).shortForecast.toLowerCase()}",
                    fallback: WeatherIcons.na)),TemperatureWidget(forecasts: forecasts)] 
                  
              ),
            ),
            
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  LocationTextWidget(location: location),
                  DescriptionWidget(forecasts: forecasts)
                ],
              ),
            ),
          ],
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
      child: Center(
          child: Text(forecasts.elementAt(0).shortForecast,
              style: Theme.of(context).textTheme.bodyMedium)),
    );
  }
}

class TemperatureWidget extends StatelessWidget {
  const TemperatureWidget({
    super.key,
    required this.forecasts,
  });

  final List<WeatherForecast> forecasts;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 75,
      child: 
        
            Text('${forecasts.elementAt(0).temperature}º',
                style: Theme.of(context).textTheme.displayLarge),
        
    );
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
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: 500,
        child: Text("${location.city}, ${location.state}, ${location.zip}",
            style: Theme.of(context).textTheme.headlineSmall),
      ),
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
              setLocation: widget.setLocation,
              getLocation: widget.getLocation),
        ],
      ),
    );
  }
}
