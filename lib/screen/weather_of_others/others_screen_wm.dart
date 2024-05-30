import "package:elementary/elementary.dart";
import "package:elementary_helper/elementary_helper.dart";
import "package:flutter/material.dart";
import "package:weather_app/model/comment.dart";
import "package:weather_app/model/other_user.dart";
import "package:weather_app/repository/comment_repository.dart";
import "package:weather_app/screen/home_screen/home_screen_model.dart";
import "package:weather_app/screen/home_screen/home_screen_widget.dart";
import "package:weather_app/model/user.dart";
import "package:weather_app/model/weather.dart";
import "package:weather_app/repository/profile_repository.dart";
import "package:weather_app/screen/weather_of_others/others_screen_model.dart";
import "package:weather_app/screen/weather_of_others/others_screen_widget.dart";


abstract interface class IOthersWidgetModel implements IWidgetModel {
  ValueNotifier<EntityState<List<OtherUser>>> get profileListenable;
  ValueNotifier<EntityState<Comment>> get commentsListenable;
}

class OthersWidgetModel extends WidgetModel<Others, IOthersModel> implements IOthersWidgetModel {
  OthersWidgetModel(OthersModel model) : super(model);

  final _profileEntity = EntityStateNotifier<List<OtherUser>>();
  final _commentsEntity = EntityStateNotifier<Comment>();

  @override
  ValueNotifier<EntityState<List<OtherUser>>> get profileListenable => _profileEntity;

  @override
  ValueNotifier<EntityState<Comment>> get commentsListenable => _commentsEntity;


  @override
  void initWidgetModel() {
    _loadUsers();
    super.initWidgetModel();
  }

  Future<void> _loadUsers() async {
    _profileEntity.loading();
    final users = await model.getAllUsers();
    _profileEntity.content(users);
  }

}

OthersWidgetModel defaultOthersWidgetModelFactory(BuildContext context) {
  return OthersWidgetModel(OthersModel(ProfileRepository(), CommentRepository()));
}