class Comment {
  String text;
  String point;
  String temperature;
  String description;
  String icon;

  Comment( 
    this.text,
    this.point,
    this.temperature,
    this.description,
    this.icon
  );

  Comment.fromJson(Map<String, dynamic> json)
      :  text = json['text'],
         point = json['point'],
         temperature = json['temperature'],
         description = json['description'],
         icon = json['icon'];


  /// Convert an in-memory representation of a Favorite object to a Map<String, dynamic>
  Map<String, dynamic> toJson() => {
        'text': text,
        'point': point,
        'temperature': temperature,
        'description': description,
        'icon': icon,
      };

  @override
  bool operator==(Object other) =>
    other is Comment && 
    text == other.text && 
    point == other.point && 
    temperature == other.temperature && 
    description == other.description && 
    icon == other.icon;

  @override
  int get hashCode => Object.hash(text.hashCode, point.hashCode, temperature.hashCode, description.hashCode, icon.hashCode);
}
