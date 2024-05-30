import "package:elementary/elementary.dart";
import "package:elementary_helper/elementary_helper.dart";
import "package:flutter/material.dart";
import "package:weather_app/model/comment.dart";
import "package:weather_app/repository/comment_repository.dart";
import "package:weather_app/screen/home_screen/home_screen_model.dart";
import "package:weather_app/screen/home_screen/home_screen_widget.dart";
import "package:weather_app/model/user.dart";
import "package:weather_app/model/weather.dart";
import "package:weather_app/repository/profile_repository.dart";


abstract interface class IHomeWidgetModel implements IWidgetModel {
  ValueNotifier<EntityState<User>> get profileListenable;
  ValueNotifier<EntityState<Weather>> get weatherListenable;
  ValueNotifier<EntityState<List<Comment>>> get commentsListenable;
  setCity(String city);
  addComment(Comment comment);
  deleteComment(Comment comment);
  viewComments();
}

class HomeWidgetModel extends WidgetModel<Home, IHomeModel> implements IHomeWidgetModel {
  HomeWidgetModel(HomeModel model) : super(model);

  final _profileEntity = EntityStateNotifier<User>();
  final _weatherEntity = EntityStateNotifier<Weather>();
  final _commentsEntity = EntityStateNotifier<List<Comment>>();
  String? _city = null;

  @override
  ValueNotifier<EntityState<User>> get profileListenable => _profileEntity;

  @override
  ValueNotifier<EntityState<Weather>> get weatherListenable => _weatherEntity;

  @override
  ValueNotifier<EntityState<List<Comment>>> get commentsListenable => _commentsEntity;

  @override
  setCity(String city){
    _city = city;
    _loadWeather();
  } 

  @override
  addComment(Comment comment) {
    model.addComment(comment);
    _loadMyComments();
  }

  @override
  deleteComment(Comment comment) {
    model.deleteComment(comment);
    _loadMyComments();
  }

  @override
  void viewComments() {
    _loadMyComments();
  }


  @override
  void initWidgetModel() {
    _loadProfile();
    _loadWeather();
    _loadMyComments();
    super.initWidgetModel();
  }

  Future<void> _loadProfile() async {
    _profileEntity.loading();
    final profile = await model.getProfile();
    _profileEntity.content(profile);
  }

  Future<void> _loadWeather() async {
    _weatherEntity.loading();
    final weather = await model.getWeather(_city);
    _weatherEntity.content(weather);
  }

  Future<void> _loadMyComments() async {
    _commentsEntity.loading();
    final comments = await model.getMyComments();
    _commentsEntity.content(comments);
  }

}

HomeWidgetModel defaultHomeWidgetModelFactory(BuildContext context) {
  return HomeWidgetModel(HomeModel(ProfileRepository(), CommentRepository()));
}