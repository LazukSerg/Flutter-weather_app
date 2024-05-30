import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/model/other_user.dart';
import 'package:weather_app/storage/user_storage.dart';

class ProfileRepository {

  static String users = '[{"id":"1","name":"user1","photo":"https://i.postimg.cc/fyHVRyr0/q-ICe-UTuyvi9kresq-OO8o-OEGi43-Hb-8-UFr-Ch-KTcu4-ZA9-U-Mh-KP-pold-X9ntm-F8j-PRG14o-Fi2aqye-Juoa6pxdj-VHRU.jpg"},' +
   '{"id":"2","name":"user2","photo":"https://i.postimg.cc/fyHVRyr0/q-ICe-UTuyvi9kresq-OO8o-OEGi43-Hb-8-UFr-Ch-KTcu4-ZA9-U-Mh-KP-pold-X9ntm-F8j-PRG14o-Fi2aqye-Juoa6pxdj-VHRU.jpg"},' +
   '{"id":"3","name":"user3","photo":"https://i.postimg.cc/fyHVRyr0/q-ICe-UTuyvi9kresq-OO8o-OEGi43-Hb-8-UFr-Ch-KTcu4-ZA9-U-Mh-KP-pold-X9ntm-F8j-PRG14o-Fi2aqye-Juoa6pxdj-VHRU.jpg"}]';

  Future<String> getProfile(String uid) async {
    SharedPreferences _prefs =  await SharedPreferences.getInstance();
    var store = UserStorage(_prefs);
    var username = store.getUserName();
    var userEmail = store.getUserEmail();
    var userPhoto = store.getUserPhoto(uid);
    
    return '{"name":"$username","email":"$userEmail","photo":"$userPhoto"}';
  }


  String getAllUsers() {
    return users;
  }

  OtherUser getOtherProfile(String id) {
    final usersJson = jsonDecode(users.toString()) as List<dynamic>;
    var usersList = usersJson.map((v) => OtherUser.fromJson(v)).toList();
    return usersList.firstWhere((element) => element.id == id);
  }
}
