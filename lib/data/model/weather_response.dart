class Coord {
  final double? lon;
  final double? lat;

  Coord({this.lon, this.lat});

  factory Coord.fromJson(Map<String, dynamic> json) => Coord(
    lon: json['lon']?.toDouble(),
    lat: json['lat']?.toDouble(),
  );
}

class Weather {
  final int? id;
  final String? main;
  final String? description;
  final String? icon;

  Weather({this.id, this.main, this.description, this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
    id: json['id'],
    main: json['main'],
    description: json['description'],
    icon: json['icon'],
  );
}

class Main {
  final double? temp;
  final double? feelsLike;
  final double? tempMin;
  final double? tempMax;
  final int? pressure; // Could be int or double, handle both
  final int? humidity; // Could be int or double, handle both
  final int? seaLevel; // Could be int or double, handle both
  final int? grndLevel; // Could be int or double, handle both

  Main({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.humidity,
    this.seaLevel,
    this.grndLevel,
  });

  factory Main.fromJson(Map<String, dynamic> json) => Main(
    temp: _parseDouble(json['temp']),
    feelsLike: _parseDouble(json['feels_like']),
    tempMin: _parseDouble(json['temp_min']),
    tempMax: _parseDouble(json['temp_max']),
    pressure: json['pressure'],
    humidity: json['humidity'],
    seaLevel: json['sea_level'],
    grndLevel: json['grnd_level'],
  );

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return double.tryParse(value.toString()); // Handle string case too
  }
}


class Wind {
  final double? speed;
  final int? deg;
  final double? gust;

  Wind({this.speed, this.deg, this.gust});

  factory Wind.fromJson(Map<String, dynamic> json) => Wind(
    speed: json['speed']?.toDouble(),
    deg: json['deg'],
    gust: json['gust']?.toDouble(),
  );
}

class Clouds {
  final int? all;

  Clouds({this.all});

  factory Clouds.fromJson(Map<String, dynamic> json) => Clouds(
    all: json['all'],
  );
}

class Sys {
  final int? type;
  final int? id;
  final String? country;
  final int? sunrise;
  final int? sunset;

  Sys({this.type, this.id, this.country, this.sunrise, this.sunset});

  factory Sys.fromJson(Map<String, dynamic> json) => Sys(
    type: json['type'],
    id: json['id'],
    country: json['country'],
    sunrise: json['sunrise'],
    sunset: json['sunset'],
  );
}

class WeatherResponse {
  final Coord? coord;
  final List<Weather>? weather;
  final String? base;
  final Main? main;
  final int? visibility;
  final Wind? wind;
  final Clouds? clouds;
  final int? dt;
  final Sys? sys;
  final int? timezone;
  final int? id;
  final String? name;
  final int? cod;

  WeatherResponse({
    this.coord,
    this.weather,
    this.base,
    this.main,
    this.visibility,
    this.wind,
    this.clouds,
    this.dt,
    this.sys,
    this.timezone,
    this.id,
    this.name,
    this.cod,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) => WeatherResponse(
    coord: json['coord'] != null ? Coord.fromJson(json['coord']) : null,
    weather: (json['weather'] as List?)?.map((e) => Weather.fromJson(e)).toList(),
    base: json['base'],
    main: json['main'] != null ? Main.fromJson(json['main']) : null,
    visibility: json['visibility'],
    wind: json['wind'] != null ? Wind.fromJson(json['wind']) : null,
    clouds: json['clouds'] != null ? Clouds.fromJson(json['clouds']) : null,
    dt: json['dt'],
    sys: json['sys'] != null ? Sys.fromJson(json['sys']) : null,
    timezone: json['timezone'],
    id: json['id'],
    name: json['name'],
    cod: json['cod'],
  );
}