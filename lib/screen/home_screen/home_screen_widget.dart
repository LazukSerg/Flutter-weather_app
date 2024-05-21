// import 'dart:async';

// import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:ui';

import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:weather_app/model/user.dart';
import 'package:weather_app/weather_form.dart';
import 'package:weather_app/screen/home_screen/home_screen_wm.dart';
import 'package:weather_app/model/weather.dart';

class Home extends ElementaryWidget<IHomeWidgetModel> {
  Home({
    super.key
  }): super(defaultHomeWidgetModelFactory);

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
                              if (data == null) return const SizedBox();
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
                  
              ]),
              ),
                
                    Container(
                      height: 300.0,
                      color: Colors.cyan,
                    ),
                    Container(
                      height: 300.0,
                      color: const Color.fromARGB(255, 212, 21, 0),
                    ),
                    Container(
                      height: 300.0,
                      color: Color.fromARGB(255, 224, 21, 255),
                    )
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