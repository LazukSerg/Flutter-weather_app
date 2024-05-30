class Weather {
  final String point;
  final int temperature;
  final String main;
  final String description;
  final String icon;

  Weather(
    this.point,
    this.temperature, 
    this.main,
    this.description,
    this.icon
  );

  Weather.fromJson(Map<String, dynamic> json)
      : point = json['name'],
        temperature = ((json['main']['temp']) - 273).round(),
        main = json['weather'][0]['main'],
        description = json['weather'][0]['description'],
        icon = json['weather'][0]['icon'];

}