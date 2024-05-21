import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/model/user.dart' as weather;
import 'package:weather_app/screen/auth_screen/auth_widget.dart';
import 'package:weather_app/screen/home_screen/home_screen_wm.dart';
import 'package:weather_app/screen/profile_screen/profile_screen_wm.dart';
import 'package:weather_app/storage/user_storage.dart';

class Profile extends ElementaryWidget<IProfileWidgetModel> {
  Profile({
    super.key
  }): super(defaultProfileWidgetModelFactory);

  final myController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  File? photo;

  @override
  Widget build(IProfileWidgetModel wm) {
    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    Size size = view.physicalSize / view.devicePixelRatio;
    double width = size.width;
    double height = size.height;
    return ListView(
              children: <Widget> [
                EntityStateNotifierBuilder<weather.User>(
                            listenableEntityState: wm.profileListenable,
                            loadingBuilder: (context, data) => const Center(child: CircularProgressIndicator()),
                            errorBuilder: (context, e, data) => const Center(child: Text("Error")),
                            builder: (context, weather.User? data) {
                              if (data == null) return const SizedBox();
                              return Container(
                                height: 300.0, 
                                width: width,
                                child:Column(
                                  children: <Widget> [
                                    Expanded(flex:4, child: Container(width: double.maxFinite, alignment: Alignment.center, child: getImage(data.photo) 
                                    )),
                                    Expanded(flex:1, child: Container(width: double.maxFinite, alignment: Alignment.center, color: const Color.fromARGB(255, 254, 222, 124), child: Text(data.name))),
                                    
                                  ]
                                )
                              );
                            }
                ),

                ElevatedButton(
                    onPressed: () {
                      wm.updatePhoto();

                    },
                    child: const Text("Изменить аватар")
                  ),

                Row(children: [
                  Expanded(
                    child: TextField(
                      maxLines: 1,
                      controller: myController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(),
                        hintText: 'Новое имя',
                      )
                    ),
                  ),
                            
                  ElevatedButton(
                      onPressed: () {
                        wm.updateName(myController.text);
                      },
                      child: const Text("Изменить")
                  ),  
                ]),
                ElevatedButton(
                  
                      onPressed: () {
                        _dialogBuilder();
                        // FirebaseAuth.instance.signOut();
                      },
                      child: const Text("Выйти из аккаунта")
                ), 


                // ElevatedButton(
                //       onPressed: () {
                        
                //         abc();
                //       },
                //       child: const Text("Изменить")
                //   ), 
              ]
            );
    
  }

  //  Future<void> abc() async {
  //   SharedPreferences _prefs =  await SharedPreferences.getInstance();
  //   var store = UserStorage(_prefs);
  //   store.getAll();
  // }

  Image getImage(String photo) {
    if(photo.startsWith("http")) {
        return Image.network(photo);
    } else {
      return Image.memory(base64Decode(photo));
    }
  }

  Future<void> _dialogBuilder() {
    return showDialog<void>(
      context: getGlobalKey().currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Выход'),
          content: const Text(
            'Вы точно хотите выйти?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Да'),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return AuthPage(title: "Вход");
                  }
                ));
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Нет'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }

}