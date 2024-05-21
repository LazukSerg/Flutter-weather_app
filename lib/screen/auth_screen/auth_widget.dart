import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/screen/home_screen/home_screen_widget.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/storage/user_storage.dart';
class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required this.title});

  final String title;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  TextEditingController nameRegisterController = TextEditingController();
  TextEditingController emailRegisterController = TextEditingController();
  TextEditingController passwordRegisterController = TextEditingController();
  TextEditingController emailAuthController = TextEditingController();
  TextEditingController passwordAuthController = TextEditingController();


  

  @override
  Widget build(BuildContext context) {
    


    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    Size size = view.physicalSize / view.devicePixelRatio;
    double width = size.width;
    double height = size.height;
    return Container(
      height: height,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title)
        ),
        body: ListView(
              children: <Widget> [Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Регистрация"),
            TextFormField(
              controller: nameRegisterController,
              decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Введите имя',
                    )
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: emailRegisterController,
              decoration: InputDecoration(
                      prefixIcon:
                        Icon(Icons.email),
                      border: OutlineInputBorder(),
                      hintText: 'Введите email',
                    )
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: passwordRegisterController,
              decoration: InputDecoration(
                      prefixIcon:
                        Icon(Icons.password),
                      border: OutlineInputBorder(),
                      hintText: 'Введите пароль',
                    )
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: () => register(), child: Text("Зарегистрироваться")),
            SizedBox(
              height: 20,
            ),
            Text("Авторизация"),
            TextFormField(
              controller: emailAuthController,
              decoration: InputDecoration(
                      prefixIcon:
                        Icon(Icons.email),
                      border: OutlineInputBorder(),
                      hintText: 'Введите email',
                    )
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: passwordAuthController,
              decoration: InputDecoration(
                      prefixIcon:
                        Icon(Icons.password),
                      border: OutlineInputBorder(),
                      hintText: 'Введите пароль',
                    )
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: () => auth(), child: Text("Войти"))
          ],
        )])
      )
    );
  }

  Future<void> register() async {
    SharedPreferences _prefs =  await SharedPreferences.getInstance();
    var store = UserStorage(_prefs);
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailRegisterController.text, 
        password: passwordRegisterController.text);

      var deafultPhotoUrl = "https://i.postimg.cc/fyHVRyr0/q-ICe-UTuyvi9kresq-OO8o-OEGi43-Hb-8-UFr-Ch-KTcu4-ZA9-U-Mh-KP-pold-X9ntm-F8j-PRG14o-Fi2aqye-Juoa6pxdj-VHRU.jpg";
      FirebaseAuth.instance.currentUser!.updateDisplayName(nameRegisterController.text);
      FirebaseAuth.instance.currentUser!.updatePhotoURL(deafultPhotoUrl);
      
      store.saveUserName(nameRegisterController.text);
      store.saveUserEmail(credential.user!.email.toString());
      store.saveUserPhoto(deafultPhotoUrl, credential.user!.uid);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return MyHomePage(title: "Погода",);
        }
      ));
    } on FirebaseAuthException catch(e) {
      if(e.code == "email-already-in-use") {
        AlertDialog alert = createAlert("Такой пользователь уже существует");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      } else if(e.code == "weak-password") {
        AlertDialog alert = createAlert("Слабый пароль");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> auth() async {
    SharedPreferences _prefs =  await SharedPreferences.getInstance();
    var store = UserStorage(_prefs);
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAuthController.text, 
        password: passwordAuthController.text
      );
      print(credential.user);
      store.saveUserName(credential.user!.displayName.toString());
      store.saveUserEmail(credential.user!.email.toString());
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return MyHomePage(title: "Погода",);
        }
      ));
    } on FirebaseAuthException catch(e) {
      if(e.code == "invalid-credential") {
        AlertDialog alert = createAlert("Неправильный email или пароль");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  AlertDialog createAlert(String text) {
    return AlertDialog(
      title: Text("Ошибка"),
      content: Text(text),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () { 
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }


}