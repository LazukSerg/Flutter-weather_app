import 'dart:convert';
import 'dart:ui';

import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:weather_app/model/comment.dart';
import 'package:weather_app/model/other_user.dart';
import 'package:weather_app/model/user.dart';
import 'package:weather_app/screen/home_screen/home_screen_widget.dart';
import 'package:weather_app/screen/other_user/other_user_page_screen_widget.dart';
import 'package:weather_app/screen/weather_of_others/others_screen_wm.dart';
import 'package:weather_app/weather_form.dart';
import 'package:weather_app/screen/home_screen/home_screen_wm.dart';
import 'package:weather_app/model/weather.dart';

class Others extends ElementaryWidget<IOthersWidgetModel> {
  Others({
    super.key
  }): super(defaultOthersWidgetModelFactory);

  @override
  Widget build(IOthersWidgetModel wm) {
    return ListView(
              children: <Widget> [
                EntityStateNotifierBuilder<List<OtherUser>>(
                        listenableEntityState: wm.profileListenable,
                        loadingBuilder: (context, data) => const Center(child: CircularProgressIndicator()),
                        errorBuilder: (context, e, data) => const Center(child: Text("Error")),
                        builder: (context, List<OtherUser>? data) {
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
                                  Expanded(flex: 1, child: getImage(element!.photo)),
                                  SizedBox(width:5),
                                  Expanded(flex: 2, child: Text(element.name)),
                                  SizedBox(width: 30,),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) {
                                          OtherUserPage.glogalUid = element.id;
                                          return OtherUserPage(uid: element.id);
                                        }
                                      ));
                                    },
                                    child: const Text("В профиль")
                                  ), 
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