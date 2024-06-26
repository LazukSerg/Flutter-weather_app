// import 'dart:async';

// import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:ui';

import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:weather_app/model/comment.dart';
import 'package:weather_app/model/user.dart';
import 'package:weather_app/weather_form.dart';
import 'package:weather_app/screen/home_screen/home_screen_wm.dart';
import 'package:weather_app/model/weather.dart';

class Home extends ElementaryWidget<IHomeWidgetModel> {
  Home({
    super.key
  }): super(defaultHomeWidgetModelFactory);

  final commentController = TextEditingController();
  static Weather? currentWeather;
  User? user;
  var viewComments = false;

  void setViewComments(IHomeWidgetModel wm) {
    viewComments = true;
    wm.viewComments();
  }

  @override
  Widget build(IHomeWidgetModel wm) {
    return ListView(
              children: <Widget> [
                Container(
                  height: 180.0, 
                  child: Row(
                    children: [
                      Expanded(flex: 1,
                        child: EntityStateNotifierBuilder<User>(
                            listenableEntityState: wm.profileListenable,
                            loadingBuilder: (context, data) => const Center(child: CircularProgressIndicator()),
                            errorBuilder: (context, e, data) => const Center(child: Text("Error")),
                            builder: (context, User? data) {
                              user = data;
                              
                              if (data == null) return const SizedBox();
                              setViewComments(wm);
                              return Column(
                                children: <Widget> [
                                  Expanded(flex:3, child: Container(width: double.maxFinite, alignment: Alignment.center, child: getImage(data.photo) )),
                                  Expanded(flex:1, child: Container(width: double.maxFinite, alignment: Alignment.center, color: const Color.fromARGB(255, 254, 222, 124), child: Text(data.name))),
                                  
                                ]
                              );
                            }
                        )
                      ),
                      
                      Expanded(flex:2,
                        child: WeatherForm(wm: wm),
                      ),
                    ]
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16), 
                  child:  TextField(
                      maxLines: 3,
                      controller: commentController,
                      decoration: InputDecoration( 
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        border: OutlineInputBorder(),
                        hintText: 'Новый комментарий',
                      )
                    ),
                ),
                ElevatedButton(
                      onPressed: () {
                          var comment = Comment(
                            commentController.text,
                            currentWeather!.point,
                            '${currentWeather!.temperature > 0 ? '+' : ''}${currentWeather!.temperature}',
                            currentWeather!.description,
                            currentWeather!.icon
                          );
                          wm.addComment(comment);
                      },
                      child: const Text("Опубликовать")
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
                                  IconButton(
                                    onPressed: () {
                                      wm.deleteComment(element);
                                    },
                                    
                                    icon: Icon(Icons.delete)
                                  ),
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