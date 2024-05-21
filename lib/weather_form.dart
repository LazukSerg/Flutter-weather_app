import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/screen/home_screen/home_screen_wm.dart';
import 'package:weather_app/model/weather.dart';

class WeatherForm extends StatefulWidget {
  WeatherForm({super.key, required this.wm});

  final IHomeWidgetModel wm;
  var flag = false;

  @override
  State<WeatherForm> createState() => _WeatherFormState();
}

class _WeatherFormState extends State<WeatherForm> {
  final myController = TextEditingController();

  void onFlag(String city) {
      setState(() {
        widget.flag = true;
        widget.wm.setCity(city);
      });
  }

  @override
  void dispose() {
    myController.dispose();
    widget.flag = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
              Expanded(flex: 1, 
                child: TextField(
                
                  maxLines: 1,
                  controller: myController,
                  decoration: InputDecoration(
                    prefixIcon:
                      Icon(Icons.search),
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(),
                    hintText: 'Введите город',
                  )
                )
              ),
                          
              Expanded(flex: 1, 
                child: ElevatedButton(
                  onPressed: () {
                    onFlag(myController.text);
                  },
                  child: const Text("Найти")
                )
              ),

              (widget.flag) ? 
              Expanded(flex: 2,
                child: EntityStateNotifierBuilder<Weather>(
                  listenableEntityState: widget.wm.weatherListenable,
                  loadingBuilder: (context, data) => const Center(child: CircularProgressIndicator()),
                  errorBuilder: (context, e, data) => const Center(child: Text("Error")),
                  builder: (context, Weather? data) {
                    if (data == null) return const SizedBox();
                    return 
                        Column(children: [
                            Expanded(flex: 5, 
                              child: Container(
                                width: double.maxFinite, 
                                color: Color.fromARGB(255, 189, 229, 255),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${data.temperature > 0 ? '+' : ''}${data.temperature}', style: TextStyle(fontSize: 40.0)),
                                    Image.network('https://openweathermap.org/img/wn/${data.icon}@2x.png') 
                                  ],
                                )
                              )
                            ),
                            Expanded(flex: 3, 
                              child: Container(
                                width: double.maxFinite, 
                                alignment: Alignment.center, 
                                color: Color.fromARGB(255, 189, 229, 255), 
                                child: Text(data.description)
                              )
                            )
                          ],
                        );
                  }
                ),
              ) : const Expanded(flex:2, child: SizedBox())
            ]
          );
  }
}