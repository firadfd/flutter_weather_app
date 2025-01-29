part of 'weather_bloc.dart';

sealed class WeatherState extends Equatable {
  const WeatherState();
  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherResponse data;
  const WeatherLoaded(this.data);
  @override
  List<Object?> get props => [data];
}

class WeatherError extends WeatherState {
  final String message;
  const WeatherError(this.message);
  @override
  List<Object?> get props => [message];
}