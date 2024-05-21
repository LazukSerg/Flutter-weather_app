import "dart:convert";
import "dart:io";

import "package:elementary/elementary.dart";
import "package:elementary_helper/elementary_helper.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:weather_app/model/user.dart";
import "package:weather_app/repository/profile_repository.dart";
import "package:weather_app/screen/profile_screen/profile_screen_model.dart";
import "package:weather_app/screen/profile_screen/profile_screen_widget.dart";


abstract interface class IProfileWidgetModel implements IWidgetModel {
  ValueNotifier<EntityState<User>> get profileListenable;
  void updateName(String newName);
  void updatePhoto();
}

class ProfileWidgetModel extends WidgetModel<Profile, IProfileModel> implements IProfileWidgetModel {
  ProfileWidgetModel(ProfileModel model) : super(model);

  final _profileEntity = EntityStateNotifier<User>();
  final ImagePicker picker = ImagePicker();

  @override
  ValueNotifier<EntityState<User>> get profileListenable => _profileEntity;

  @override
  void initWidgetModel() {
    _loadProfile();
    super.initWidgetModel();
  }

  @override
  void updateName(String newName) {
    var previousUser = _profileEntity.value.data;
    var newUser = User(newName, previousUser!.email, previousUser!.photo);
    model.updateName(newName);
    _profileEntity.content(newUser);
  }

  Future<void> updatePhoto() async {
    var previousUser = _profileEntity.value.data;
    final res = await picker.pickImage(source: ImageSource.gallery);
    if(res != null) {
      var photo = File(res.path);
      Uint8List imageBytes = photo. readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      var newUser = User(previousUser!.name, previousUser!.email, base64Image);
      model.updatePhoto(base64Image);
      _profileEntity.content(newUser);
    }
  }


  Future<void> _loadProfile() async {
    _profileEntity.loading();
    final profile = await model.getProfile();
    _profileEntity.content(profile);
  }

}

ProfileWidgetModel defaultProfileWidgetModelFactory(BuildContext context) {
  return ProfileWidgetModel(ProfileModel(ProfileRepository()));
}