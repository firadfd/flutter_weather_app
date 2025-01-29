part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class WeatherByCityName extends WeatherEvent {
  final String cityName;

  WeatherByCityName(this.cityName);

  @override
  List<Object?> get props => [cityName];
}

class WeatherByLocation extends WeatherEvent {
  final double lat;
  final double lon;

  WeatherByLocation(this.lat, this.lon);

  @override
  List<Object?> get props => [lat, lon];
}
