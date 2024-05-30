// import 'dart:async';

// import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:ui';

import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/model/comment.dart';
import 'package:weather_app/model/other_user.dart';
import 'package:weather_app/model/user.dart';
import 'package:weather_app/screen/other_user/other_user_screen_wm.dart';
import 'package:weather_app/weather_form.dart';
import 'package:weather_app/screen/home_screen/home_screen_wm.dart';
import 'package:weather_app/model/weather.dart';

class OtherUserPage extends ElementaryWidget<IOtherUserWidgetModel> {
  OtherUserPage({
    super.key, required this.uid
    
  }) : super(defaultOtherUserWidgetModelFactory);

  String uid;
  static String? glogalUid = null;
  final commentController = TextEditingController();
  OtherUser? user;
  var viewComments = false;

  void setViewComments(IOtherUserWidgetModel wm, String uid) {
    viewComments = true;
    wm.viewComments(uid);
  }

  @override
  Widget build(IOtherUserWidgetModel wm) {
    return 
    Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(getGlobalKey().currentContext!).colorScheme.inversePrimary,
        ),
        body: 
            ListView(
              children: <Widget> [
                Container(
                  color: Color.fromARGB(255, 247, 246, 243),
                  height: 180.0, 
                  child: Row(
                    children: [
                      Expanded(flex: 1,
                        child: EntityStateNotifierBuilder<OtherUser>(
                            listenableEntityState: wm.profileListenable,
                            loadingBuilder: (context, data) => const Center(child: CircularProgressIndicator()),
                            errorBuilder: (context, e, data) => const Center(child: Text("Error")),
                            builder: (context, OtherUser? data) {
                              user = data;
                              
                              if (data == null) return const SizedBox();
                              setViewComments(wm, data.id);
                              return Column(
                                children: <Widget> [
                                  Expanded(flex:3, child: Container(width: double.maxFinite, alignment: Alignment.center, child: getImage(data.photo) )),
                                  Expanded(flex:1, child: Container(width: double.maxFinite, alignment: Alignment.center, color: const Color.fromARGB(255, 254, 222, 124), child: Text(data.name))),
                                  
                                ]
                              );
                            }
                        )
                      ),
                      
                    ]
                  ),
                ),
                 
                EntityStateNotifierBuilder<List<Comment>>(
                        listenableEntityState: wm.commentsListenable,
                        loadingBuilder: (context, data) => const Center(child: CircularProgressIndicator()),
                        errorBuilder: (context, e, data) => const Center(child: Text("Error")),
                        builder: (context, List<Comment>? data) {
                          if (data == null) return const SizedBox();
                          List<Widget> list = [];
                          data.forEach((element) => list.add(
                            Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 207, 213, 241),
                                border: Border(
                                  bottom: BorderSide(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  width: 1,
                                  ))),
                              height: 150.0,
                              width: double.maxFinite, 
                              alignment: Alignment.center, 
                              child: Row(
                                children: <Widget> [
                                  (viewComments) ? Expanded(flex: 3, child: getImage(user!.photo)) : SizedBox(),
                                  SizedBox(width:5),
                                  Expanded(flex: 6, child: Column(children: [
                                    SizedBox(height: 15,),
                                    Expanded(flex:2, child: Text(element.point)),
                                    Expanded(flex:3, child: Row(
                                      children: [
                                        SizedBox(width: 25,),
                                        Expanded(flex:2, child: Text(element.temperature, style: TextStyle(fontSize: 16.0))),
                                        Expanded(flex:3, child: Image.network('https://openweathermap.org/img/wn/${element.icon}@2x.png')),
                                        SizedBox(width: 25,),
                                      ],
                                    )),
                                    SizedBox(width: 15,),
                                    Expanded(flex:2, child: Text(element.description))
                                  ],)),
                                  Expanded(flex: 6, child: Text(element.text)),
                                  SizedBox(width: 5)
                                ],
                              )
                               )));
                          return Column(
                            children: list
                          );
                        }
                ),
              ],
  
            )
    );
          
  }

  Image getImage(String photo) {
    if(photo.startsWith("http")) {
        return Image.network(photo);
    } else {
      return Image.memory(base64Decode(photo));
    }
  }
}