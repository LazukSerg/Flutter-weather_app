import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/model/comment.dart';
import 'package:weather_app/storage/user_storage.dart';

class CommentRepository {

  static String comments = '[{"id":"1","comments":[{"text":"aaa","point":"Moscow","temperature":"+33","description":"clear sky","icon":"04n"},{"text":"aaa","point":"Dubai","temperature":"+13","description":"clear sky","icon":"50n"},{"text":"aaa","point":"Kaliningrad","temperature":"+25","description":"clear sky","icon":"04n"}]},'+
   '{"id":"2","comments":[{"text":"bbb","point":"Paris","temperature":"+13","description":"clear sky","icon":"11d"}]},' +
   '{"id":"3","comments":[{"text":"ccc","point":"Tula","temperature":"-50","description":"clear sky","icon":"13d"},{"text":"ccc","point":"Voronesh","temperature":"-10","description":"clear sky","icon":"13n"}]}]';

  
  Future<List<Comment>> getCommentsByUserId(String uid) async {
    SharedPreferences _prefs =  await SharedPreferences.getInstance();
    var store = UserStorage(_prefs);
    var commentsString = store.getUserComments(uid);

    List<Comment> rs;
    if(commentsString == null) {
      rs = [];
      return rs;
    } else {
      var b = jsonDecode(commentsString) as List<dynamic>;
      var a = _decodeData(b);
      return a;
    }
  }

  Future<List<Comment>> getCommentsByUserIdMock(String uid) async {
    var commentsList = jsonDecode(comments) as List<dynamic>;
    var map = commentsList.firstWhere((element) => (element as Map<String, dynamic>).entries.firstWhere((element) => element.key == "id").value == uid); //as Map<String, dynamic>;
    List<Comment> rs = _decodeData(map.entries.firstWhere((element) => element.key == "comments").value);
    return rs;
  }

  Future<void> addComment(Comment comment, String uid) async {
    SharedPreferences _prefs =  await SharedPreferences.getInstance();
    var store = UserStorage(_prefs);
    var json = store.getUserComments(uid);
    List<Comment> comments;
    if(json == null) {
      print("У пользователя отсутствуют комментарии");
      comments = [];
    } else {
      var b = jsonDecode(json) as List<dynamic>;
      comments = _decodeData(b);
    }
    
    comments.add(comment);
    String commentsJson = jsonEncode(comments);
    print(commentsJson);
    store.saveUserComments('$commentsJson', uid);
  }

  Future<void> deleteComment(Comment comment, String uid) async {
    SharedPreferences _prefs =  await SharedPreferences.getInstance();
    var store = UserStorage(_prefs);
    var json = store.getUserComments(uid);
    List<Comment> comments;
    var b = jsonDecode(json!) as List<dynamic>;
    comments = _decodeData(b);
    
    comments.remove(comment);
    String commentsJson = jsonEncode(comments);
    print(commentsJson);
    store.saveUserComments('$commentsJson', uid);
  }


List<Comment> _decodeData(List<dynamic> list) {
    try {
      var commentList = list.map((v) => Comment.fromJson(v)).toList();
      return commentList;
    } catch (error) {
      return [];
    }
  }
}