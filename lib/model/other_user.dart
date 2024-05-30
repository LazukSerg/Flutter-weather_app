class OtherUser {
  String id;
  String name;
  String photo;

  OtherUser( 
    this.id,
    this.name,
    this.photo
  );

  OtherUser.fromJson(Map<String, dynamic> json)
      :  id = json['id'],
         name = json['name'],
         photo = json['photo'];


}