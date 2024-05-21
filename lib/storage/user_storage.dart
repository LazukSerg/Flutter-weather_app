import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {

  UserStorage(this._prefs);

  final SharedPreferences _prefs;
  String _nameKey = "user.name.key";
  String _emailKey = "user.email.key";
  String _photoKey = "user.{id}.photo.key";

  Future<void> saveUserName(String value) => _prefs.setString(_nameKey, value);
  Future<void> saveUserEmail(String value) => _prefs.setString(_emailKey, value);
  Future<void> saveUserPhoto(String value, String id) => _prefs.setString(_photoKey.replaceFirst('{id}', id), value);

  String? getUserName() => _prefs.getString(_nameKey);
  String? getUserEmail() => _prefs.getString(_emailKey);
  String? getUserPhoto(String id) => _prefs.getString(_photoKey.replaceFirst('{id}', id));
  // String? getAll() {
  //   // _prefs.clear();
  //   var keys = _prefs.getKeys();
  //   keys.forEach((element) {print("$element: ${_prefs.getString(element)}");});
  // }

}