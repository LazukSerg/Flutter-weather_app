import "package:elementary/elementary.dart";
import "package:elementary_helper/elementary_helper.dart";
import "package:flutter/material.dart";
import "package:weather_app/screen/home_screen/home_screen_model.dart";
import "package:weather_app/screen/home_screen/home_screen_widget.dart";
import "package:weather_app/model/user.dart";
import "package:weather_app/model/weather.dart";
import "package:weather_app/repository/profile_repository.dart";


abstract interface class IHomeWidgetModel implements IWidgetModel {
  ValueNotifier<EntityState<User>> get profileListenable;
  ValueNotifier<EntityState<Weather>> get weatherListenable;
  setCity(String city);
}

class HomeWidgetModel extends WidgetModel<Home, IHomeModel> implements IHomeWidgetModel {
  HomeWidgetModel(HomeModel model) : super(model);

  final _profileEntity = EntityStateNotifier<User>();
  final _weatherEntity = EntityStateNotifier<Weather>();
  String? _city = null;

  @override
  ValueNotifier<EntityState<User>> get profileListenable => _profileEntity;

  @override
  ValueNotifier<EntityState<Weather>> get weatherListenable => _weatherEntity;

  @override
  setCity(String city){
    _city = city;
    _loadWeather();
  } 


  @override
  void initWidgetModel() {
    _loadProfile();
    _loadWeather();
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

}

HomeWidgetModel defaultHomeWidgetModelFactory(BuildContext context) {
  return HomeWidgetModel(HomeModel(ProfileRepository()));
}