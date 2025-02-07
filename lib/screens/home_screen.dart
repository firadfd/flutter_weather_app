import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
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
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
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
                                context.read<WeatherBloc>().add(
                                    WeatherByCityName(textEditingController.text
                                        .toLowerCase()));
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
                    ] else if (state is WeatherLoaded) ...[
                      SizedBox(height: 10),
                      Text(
                        '${state.data.name}',
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      Image.network(
                        "https://openweathermap.com/img/wn/${state.data.weather?[0].icon}@4x.png",
                        height: 320,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          height: 320,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.blue.shade400,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.all(10.0),
                          alignment: Alignment.center,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  formatTimestamp(state.data.dt!.toInt()),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  '${kelvinToCelsius(state.data.main!.temp!).toStringAsFixed(1)} °C',
                                  style: TextStyle(
                                    fontSize: 48,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${state.data.weather![0].description}',
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 20),
                                weatherItem(
                                    "Wind",
                                    state.data.wind!.speed.toString(),
                                    Icons.wind_power_outlined),
                                SizedBox(height: 10),
                                weatherItem(
                                    "Hum",
                                    state.data.main!.humidity.toString(),
                                    Icons.water_drop_outlined),
                              ]),
                        ),
                      )
                    ] else if (state is WeatherError) ...[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Error: ${state.message.substring(0, 100)}",
                          style:
                              const TextStyle(fontSize: 18, color: Colors.red),
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
                ),
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

  Widget weatherItem(String title, String value, IconData icon) {
    String formattedValue = value;
    if (title.toLowerCase() == "wind") {
      formattedValue = "$value km/h";
    } else if (title.toLowerCase() == "hum" || title.toLowerCase() == "humidity") {
      formattedValue = "$value %";
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
        Expanded(
          child: Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Text("|",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Text(formattedValue,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }


  String formatTimestamp(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('d MMMM yyyy');

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return "Today, ${formatter.format(date)}";
    } else {
      return formatter.format(date);
    }
  }
}
