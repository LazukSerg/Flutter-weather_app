import "dart:convert";
import "package:elementary/elementary.dart";
import "package:weather_app/model/comment.dart";
import "package:weather_app/model/other_user.dart";
import "package:weather_app/model/user.dart";
import "package:weather_app/model/weather.dart";
import "package:weather_app/repository/comment_repository.dart";
import "package:weather_app/repository/profile_repository.dart";

abstract interface class IOtherUserModel extends ElementaryModel {

  Future<OtherUser> getProfile(String uid);
  Future<List<Comment>> getComments(String uid);

}

class OtherUserModel extends IOtherUserModel {
  final ProfileRepository _profileRepository;
  final CommentRepository _commentRepository;
  OtherUserModel(this._profileRepository, this._commentRepository);

  @override
  Future<OtherUser> getProfile(String uid) async {
    final user = await _profileRepository.getOtherProfile(uid);
    return user;
  }

  @override
  Future<List<Comment>> getComments(String uid) async {
    var comments = await _commentRepository.getCommentsByUserIdMock(uid);
    return comments;
  }
}