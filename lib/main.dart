import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:weather_app/screen/auth_screen/auth_widget.dart';
import 'package:weather_app/screen/profile_screen/profile_screen_widget.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weather_app/screen/home_screen/home_screen_widget.dart';

final navigatorKey = GlobalKey<NavigatorState>();

GlobalKey<NavigatorState> getGlobalKey() {
  return navigatorKey;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      home: AuthPage(title: "Вход"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedIndex = 1;
  
  void onNavBarItemTap(int index) {
  
      setState(() {
        _selectedIndex = index;
      });
  }

  List<Widget> createPages(BuildContext context) {
      final List<Widget> pages = <Widget>[
            
        // ListView(children: [
        //   Container(height: 100.0, color: Color.fromARGB(255, 144, 9, 240),),
        //   Container(height: 100.0, child: Row(
        //   children: <Widget> [
            
        //                     Expanded(flex: 2, child: Container(color: Colors.amber, child:Column(
        //                       children: <Widget> [
        //                         /*Expanded(child: */Container(color: const Color.fromARGB(255, 254, 222, 124), child: Text("data")),
        //                         /*Expanded(child: */Container(color: Colors.blue, child: Text("123"))]
                              
        //                     ))),
        //                     Expanded(flex: 1, child: Container(color: const Color.fromARGB(255, 128, 197, 254), child: Column(
        //                         // mainAxisAlignment: MainAxisAlignment.center,
        //                         // mainAxisSize: MainAxisSize.min,
        //                         children: [
        //                           Expanded(child: Container(color: Color.fromARGB(255, 255, 24, 170), child: Text('data.temperature}'))),
        //                         Expanded(child: Container(color: Color.fromARGB(255, 78, 232, 145), child: Image.network('https://openweathermap.org/img/wn/04n@2x.png')))
        //                         ],
        //                       ),))
        //   ],
        // ))]),
        Profile(),
        Home(),

        Icon(
          Icons.people,
          size: 150,
        ),
      ];
      return pages;
  }

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
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: createPages(context).elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.man),
              label: 'Профиль',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Главная',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline_outlined),
              label: 'Погода других',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: onNavBarItemTap,
        )
      )
    );
  }
}
