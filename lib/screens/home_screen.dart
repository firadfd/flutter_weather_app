import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/bloc/weather_bloc.dart';

import '../permissions/geo_locator.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBloc()..add(WeatherByCityName("rangpur")),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.greenAccent.shade100,
            centerTitle: true,
            title: const Text("Weather App"),
          ),
          body: BlocConsumer<WeatherBloc, WeatherState>(
            listener: (context, state) {
              if (state is WeatherError) {
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //   content: Text(state.message),
                //   backgroundColor: Colors.red,
                // ));
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: textEditingController,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        label: const Text("Enter City Name"),
                        prefixIcon: IconButton(
                          onPressed: () async {
                            final weatherBloc = context.read<WeatherBloc>();
                            try {
                              Position? position = await getLocation();
                              if (position != null) {
                                double lat = position.latitude;
                                double lon = position.longitude;
                                weatherBloc.add(WeatherByLocation(lat, lon));
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Location Alert'),
                                      content: const Text(
                                        'Unable to get your location. Please ensure location services are enabled and permissions are granted.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Close'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Geolocator.openLocationSettings();
                                          },
                                          child: const Text('Open Settings'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            } catch (e) {
                              if (kDebugMode) {
                                print('Error: $e');
                              }
                            }
                          },
                          icon: const Icon(Icons.location_on),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (textEditingController.text.isNotEmpty) {
                              context.read<WeatherBloc>().add(WeatherByCityName(
                                  textEditingController.text.toLowerCase()));
                            } else {
                              context
                                  .read<WeatherBloc>()
                                  .add(WeatherByCityName("rangpur"));
                            }
                          },
                          icon: const Icon(Icons.search),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                  if (state is WeatherLoading) ...[
                    Center(child: CircularProgressIndicator())
                  ]
                  else if (state is WeatherLoaded) ...[
                    SizedBox(height: 20),
                    Text(
                      '${state.data.name}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Image.network(
                      "https://openweathermap.com/img/wn/${state.data.weather?[0].icon}@4x.png",
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                    Text(
                      '${state.data.weather![0].description}',
                      style: const TextStyle(fontSize: 26),
                    ),
                    Text(
                      '${kelvinToCelsius(state.data.main!.temp!).toStringAsFixed(1)} °C',
                      style: const TextStyle(fontSize: 40),
                    ),
                  ] else if (state is WeatherError) ...[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Error: ${state.message.substring(0,100)}",
                        style: const TextStyle(fontSize: 18, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ] else if (state is WeatherInitial) ...[
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Search for a city",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              );
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
