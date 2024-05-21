class Weather {
  final int temperature;
  final String main;
  final String description;
  final String icon;

  Weather(
    this.temperature, 
    this.main,
    this.description,
    this.icon
  );

  Weather.fromJson(Map<String, dynamic> json)
      : temperature = ((json['main']['temp']) - 273).round(),
        main = json['weather'][0]['main'],
        description = json['weather'][0]['description'],
        icon = json['weather'][0]['icon'];


  /// Convert an in-memory representation of a Favorite object to a Map<String, dynamic>
  // Map<String, dynamic> toJson() => {
  //       'title': title,
  //       'artist': artist,
  //     };
}