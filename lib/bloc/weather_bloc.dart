import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/api_services.dart';
import '../data/model/weather_response.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<WeatherByCityName>((event, emit) async {
      emit(WeatherLoading());
      try {
        final response =
            await ApiServices().getWeather(cityName: event.cityName);
        emit(WeatherLoaded(response));
      } catch (e) {
        emit(WeatherError(e.toString())); // Capture and emit the error
      }
    });

    on<WeatherByLocation>((event, emit) async {
      emit(WeatherLoading());
      try {
        final response = await ApiServices().getWeatherByLocation(
          lat: event.lat,
          lon: event.lon,
        );

        emit(WeatherLoaded(response));
      } catch (e) {
        emit(WeatherError(e.toString())); // Capture and emit the error
      }
    });
  }
}
