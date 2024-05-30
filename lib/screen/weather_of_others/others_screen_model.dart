import "dart:convert";
import "package:elementary/elementary.dart";
import "package:weather_app/model/comment.dart";
import "package:weather_app/model/other_user.dart";
import "package:weather_app/model/user.dart";
import "package:weather_app/repository/comment_repository.dart";
import "package:weather_app/repository/profile_repository.dart";

abstract interface class IOthersModel extends ElementaryModel {

  Future<List<OtherUser>> getAllUsers();
  Future<Comment> getFirstCommentByUserId(String id);
}

class OthersModel extends IOthersModel {
  final ProfileRepository _profileRepository;
  final CommentRepository _commentRepository;
  OthersModel(this._profileRepository, this._commentRepository);

  @override
  Future<List<OtherUser>> getAllUsers() async {
    final res = await _profileRepository.getAllUsers();
    final userList = jsonDecode(res.toString()) as List<dynamic>;
    var users = userList.map((v) => OtherUser.fromJson(v)).toList();
    return users;
  }

  @override
  Future<Comment> getFirstCommentByUserId(String id) async {
    var comments = await _commentRepository.getCommentsByUserId(id);
    return comments.first;
  }

}