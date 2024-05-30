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

}