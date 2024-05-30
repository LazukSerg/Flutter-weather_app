import "dart:convert";
import "dart:math";

import "package:dio/dio.dart";
import "package:elementary/elementary.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:weather_app/model/comment.dart";
import "package:weather_app/model/user.dart" as weather;
import "package:weather_app/model/weather.dart";
import "package:weather_app/repository/comment_repository.dart";
import "package:weather_app/repository/profile_repository.dart";
import "package:weather_app/storage/user_storage.dart";

abstract interface class IHomeModel extends ElementaryModel {

  Future<weather.User> getProfile();
  Future<Weather> getWeather(String? city);
  Future<List<Comment>> getMyComments();
  Future<void> addComment(Comment comment);
  Future<void> deleteComment(Comment comment);

}

class HomeModel extends IHomeModel {
  final ProfileRepository _profileRepository;
  final CommentRepository _commentRepository;
  final Dio dio = Dio();
  HomeModel(this._profileRepository, this._commentRepository);

  @override
  Future<weather.User> getProfile() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    final res = await _profileRepository.getProfile(uid);
    final userMap = jsonDecode(res.toString()) as Map<String, dynamic>;
    return weather.User.fromJson(userMap);
  }

  @override
  Future<Weather> getWeather(String? city) async {
    final res = await dio.get('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=18013f96fbcd3cd3182f80542e474b18');
    final weatherMap = jsonDecode(res.toString()) as Map<String, dynamic>;
    return Weather.fromJson(weatherMap);
  }

  @override
  Future<List<Comment>> getMyComments() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var comments = await _commentRepository.getCommentsByUserId(uid);
    return comments;
  }

  @override
  Future<void> addComment(Comment comment) async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    await _commentRepository.addComment(comment, uid);
  }

  @override
  Future<void> deleteComment(Comment comment) async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    await _commentRepository.deleteComment(comment, uid);
  }
}