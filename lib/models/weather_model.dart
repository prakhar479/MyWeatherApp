class Weather {
  final String cityName;
  final double temperature;
  final double feelslike;
  final String mainCondition;
  final String description;

  Weather(
      {required this.cityName,
      required this.temperature,
      required this.feelslike,
      required this.mainCondition,
      required this.description});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      feelslike: json['main']['feels_like'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
    );
  }
}
