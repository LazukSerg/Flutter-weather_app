class User {
  String name;
  String email;
  String photo;

  User( 
    this.name,
    this.email,
    this.photo
  );

  User.fromJson(Map<String, dynamic> json)
      :  name = json['name'],
         email = json['email'],
         photo = json['photo'];


  /// Convert an in-memory representation of a Favorite object to a Map<String, dynamic>
  // Map<String, dynamic> toJson() => {
  //       'title': title,
  //       'artist': artist,
  //     };
}