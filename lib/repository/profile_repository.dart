import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/storage/user_storage.dart';

class ProfileRepository {
  Future<String> getProfile(String uid) async {
    SharedPreferences _prefs =  await SharedPreferences.getInstance();
    var store = UserStorage(_prefs);
    var username = store.getUserName();
    var userEmail = store.getUserEmail();
    var userPhoto = store.getUserPhoto(uid);
    return '{"name":"$username","email":"$userEmail","photo":"$userPhoto"}';
  }
}