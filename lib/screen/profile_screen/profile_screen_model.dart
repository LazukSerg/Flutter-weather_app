import "dart:convert";
import "dart:io";
import "dart:math";

import "package:dio/dio.dart";
import "package:elementary/elementary.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:weather_app/model/user.dart" as weather;
import "package:weather_app/model/weather.dart";
import "package:weather_app/repository/profile_repository.dart";
import "package:weather_app/storage/user_storage.dart";

abstract interface class IProfileModel extends ElementaryModel {

  Future<weather.User> getProfile();
  Future<void> updateName(String name);
  Future<void> updatePhoto(String base64Image);
}

class ProfileModel extends IProfileModel {
  final ProfileRepository _profileRepository;
  ProfileModel(this._profileRepository);

  FirebaseAuth firebase = FirebaseAuth.instance;

  @override
  Future<weather.User> getProfile() async {
    var uid = firebase.currentUser!.uid;
    final res = await _profileRepository.getProfile(uid);
    final userMap = jsonDecode(res.toString()) as Map<String, dynamic>;
    return weather.User.fromJson(userMap);
  }

  @override
  Future<void> updateName(String newName) async {
      SharedPreferences _prefs =  await SharedPreferences.getInstance();
      var store = UserStorage(_prefs);
      store.saveUserName(newName);
      firebase.currentUser!.updateDisplayName(newName);
  }

  @override
  Future<void> updatePhoto(String base64Image) async {
      SharedPreferences _prefs =  await SharedPreferences.getInstance();
      var store = UserStorage(_prefs);
      store.saveUserPhoto(base64Image, firebase.currentUser!.uid);
      firebase.currentUser!.updatePhotoURL(null);
  }

}