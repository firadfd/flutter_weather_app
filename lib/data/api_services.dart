import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:weather_app/data/model/weather_response.dart';
import 'package:weather_app/utils/constants.dart';

class ApiServices {
  final Dio _dio;

  ApiServices()
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
        )) {
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
    _dio.interceptors.add(
      AwesomeDioInterceptor(
        // Disabling headers and timeout would minimize the logging output.
        // Optional, defaults to true
        logRequestTimeout: false,
        logRequestHeaders: false,
        logResponseHeaders: false,
      ),
    );
  }

  Future<WeatherResponse> getWeather({required String cityName}) async {
    try {
      final response = await _dio.get(
        '',
        queryParameters: {'q': cityName, 'appid': apiKey},
      );
      final weatherResponse = WeatherResponse.fromJson(response.data);
      return weatherResponse;
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<WeatherResponse> getWeatherByLocation(
      {required double lat, required double lon}) async {
    try {
      final response = await _dio.get(
        '',
        queryParameters: {'lat': lat, 'lon': lon, 'appid': apiKey},
      );
      final weatherResponse = WeatherResponse.fromJson(response.data);
      return weatherResponse;
    } on DioError catch (e) {
      rethrow;
    }
  }
}
