import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/weather_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBloc()..add(WeatherByCityName("rangpur")),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.greenAccent.shade100,
            title: const Text("Weather App"),
          ),
          body: BlocConsumer<WeatherBloc, WeatherState>(
            listener: (context, state) {
              if (state is WeatherError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ));
              }
            },
            builder: (context, state) {
              if (state is WeatherLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is WeatherLoaded) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          '${state.data.name} : ${state.data.weather![0].description}',
                          style: const TextStyle(fontSize: 20)),
                      Text(
                          'Temperature: ${kelvinToCelsius(state.data.main!.temp!).toStringAsFixed(1)} °C',
                          style: const TextStyle(fontSize: 20)),
                      ElevatedButton(
                        onPressed: () {
                          if (state.data.name?.toLowerCase() == "dhaka") {
                            context
                                .read<WeatherBloc>()
                                .add(WeatherByCityName("rangpur"));
                          } else {
                            context
                                .read<WeatherBloc>()
                                .add(WeatherByCityName("dhaka"));
                          }
                        },
                        child: Text(state.data.name?.toLowerCase() == "dhaka"
                            ? "Rangpur"
                            : "Dhaka"),
                      ),
                    ],
                  ),
                );
                // Separate widget
              } else if (state is WeatherError) {
                return Center(child: Text("Error: ${state.message}"));
              } else if (state is WeatherInitial) {
                return const Center(child: Text("Search for a city"));
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }

  double kelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }
}
