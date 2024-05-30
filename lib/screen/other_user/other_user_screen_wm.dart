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
import "package:weather_app/screen/other_user/other_user_page_screen_widget.dart";
import "package:weather_app/screen/other_user/other_user_screen_model.dart";


abstract interface class IOtherUserWidgetModel implements IWidgetModel {
  ValueNotifier<EntityState<OtherUser>> get profileListenable;
  ValueNotifier<EntityState<List<Comment>>> get commentsListenable;
  setId(String uid);
  viewComments(String uid);
}

class OtherUserWidgetModel extends WidgetModel<OtherUserPage, IOtherUserModel> implements IOtherUserWidgetModel {
  OtherUserWidgetModel(OtherUserModel model, String uid) : _uid = uid, super(model);

  final _profileEntity = EntityStateNotifier<OtherUser>();
  final _commentsEntity = EntityStateNotifier<List<Comment>>();
  String _uid;

  @override
  ValueNotifier<EntityState<OtherUser>> get profileListenable => _profileEntity;

  @override
  ValueNotifier<EntityState<List<Comment>>> get commentsListenable => _commentsEntity;

  @override
  setId(String uid){
    _uid = uid;
  } 


  @override
  void initWidgetModel() {
    _loadProfile(_uid);
    _loadComments(_uid);
    super.initWidgetModel();
  }

  @override
  void viewComments(String uid) {
    _loadComments(uid);
  }

  Future<void> _loadProfile(String uid) async {
    _profileEntity.loading();
    final profile = await model.getProfile(uid);
    _profileEntity.content(profile);
  }

  Future<void> _loadComments(String uid) async {
    _commentsEntity.loading();
    final comments = await model.getComments(uid);
    _commentsEntity.content(comments);
  }

}

OtherUserWidgetModel defaultOtherUserWidgetModelFactory(BuildContext context) {
  return OtherUserWidgetModel(OtherUserModel(ProfileRepository(), CommentRepository()), OtherUserPage.glogalUid!);
}