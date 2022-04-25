import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert' as convert;
import 'package:flutter_html/flutter_html.dart';

//import 'dart:html';
import 'grow.dart';
import 'weather.dart';

var openweatherurl;
var site;
var output1;
var output2;
var output3;
var output4;
var output5;
var houseHp;
var houseacSlrdQy;
var housecutemp;
var houseCo2;
var openweathercutemp;
var openweathertempMax;
var openweathertempMin;
var openweatherwdspeed;
var Get;
var code;
var windspeed;

void main() {
  runApp(const MyApp());
}

class GrowsData {
  GrowsData(this.day, this.acc);

  final String day;
  final double acc;
}

getWeather() async {
  // url = Uri.https('api.openwe athermap.org', '/data/2.5/weather',
  //     {'id': '1835841', 'appid': 'd88d65f0066783c65a0fad51dc404e25'});
  var houseurl = Uri.parse('http://221.162.66.211:49155/farmdatas');
  http.Response hsresponse = await http.get(houseurl);
  print(hsresponse);
  var hsdata1 =
      await convert.jsonDecode(hsresponse.body) as Map<String, dynamic>;
  print(hsdata1);
  housecutemp = hsdata1["main"]["inTp"] - 273;
  housecutemp = housecutemp.floor().toString();
  houseHp = hsdata1["main"]["inHp"];
  houseHp = houseHp.floor().toString();
  houseCo2 = hsdata1["main"]["inCo2"];
  houseCo2 = houseCo2.floor().toString();
  houseacSlrdQy = hsdata1["main"]["acSlrdQy"];
  houseacSlrdQy = houseacSlrdQy.floor().toString();
}

getAcc() async {
  var houseurl = Uri.parse('http://221.162.66.211:49155/nutrient_day');
  http.Response hsresponse = await http.get(houseurl);
  print(hsresponse);
  var hsdata1 =
      await convert.jsonDecode(hsresponse.body) as Map<String, dynamic>;

  output1 = hsdata1["main"]["day_4"];
  // output1 = houseacSlrdQy.floor().toString();
  output2 = hsdata1["main"]["day_3"];
  //output2 = houseacSlrdQy.floor().toString();
  output3 = hsdata1["main"]["day_2"];
  //output3 = houseacSlrdQy.floor().toString();
  output4 = hsdata1["main"]["day_1"];
  //output4 = houseacSlrdQy.floor().toString();
  output5 = hsdata1["main"]["day_0"];
  //output5 = houseacSlrdQy.floor().toString();
}

getOpenWeather() async {
  openweatherurl = Uri.https('api.openweathermap.org', '/data/2.5/weather',
      {'id': '1835841', 'appid': 'd88d65f0066783c65a0fad51dc404e25'});
  http.Response owresponse = await http.get(openweatherurl);
  print(owresponse);
  var owdata1 =
      await convert.jsonDecode(owresponse.body) as Map<String, dynamic>;
  print(owdata1);
  openweathercutemp = owdata1["main"]["temp"] - 273;
  openweathercutemp = openweathercutemp.floor().toString();
  openweathertempMax = owdata1["main"]["temp_max"] - 273;
  openweathertempMax = openweathertempMax.floor().toString();
  openweathertempMin = owdata1["main"]["temp_min"] - 273;
  openweathertempMin = openweathertempMin.floor().toString();
  openweatherwdspeed = owdata1["wind"]["speed"];
  openweatherwdspeed = openweatherwdspeed.floor().toString();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getAcc();
    getWeather();
    getOpenWeather();
    return MaterialApp(
      title: 'SmartFarm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DashboardPage(title: 'SmartFarmProject'),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  WebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    var bottomBar = const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
        backgroundColor: Colors.red,
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage("Images/grow.png"), size: 24),
        label: 'Grow',
        backgroundColor: Colors.green,
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage("Images/weather.png"), size: 24),
        label: 'weather',
        backgroundColor: Colors.purple,
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage("Images/settings.png"), size: 24),
        label: 'Settings',
        backgroundColor: Colors.pink,
      ),
    ];
    final Size size = MediaQuery.of(context).size;
    if (_selectedIndex == 1) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('SmartFarm'),
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(children: <Widget>[
                  //Image.asset("Images/ui2.png",width: size.width*0.5,height: size.height*0.2,),
                  Padding(
                    padding: EdgeInsets.only(
                        top: size.height * 0.05, left: size.width * 0.1),
                    child: Text("급액량"),
                  ),

                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: size.height * 0.01, left: size.width * 0.08),
                        child: Container(
                          height: 100,
                          width: 150,
                          child: SfCartesianChart(
                              // Initialize category axis
                              primaryXAxis: CategoryAxis(),
                              series: <LineSeries<GrowsData, String>>[
                                LineSeries<GrowsData, String>(
                                    // Bind data source
                                    dataSource: <GrowsData>[
                                      GrowsData('4일전', output1),
                                      GrowsData('3일전', output2),
                                      GrowsData('2일전', output3),
                                      GrowsData('1일전', output4),
                                      GrowsData('현재', output5)
                                    ],
                                    xAxisName: '날짜',
                                    yAxisName: 'cc',
                                    xValueMapper: (GrowsData grow, _) =>
                                        grow.day,
                                    yValueMapper: (GrowsData grows, _) =>
                                        grows.acc)
                              ]),
                        ),
                      ),
                    ],
                  ),
                ]),
                Column(
                  children: <Widget>[
                    Center(
                        child: Padding(
                      padding: EdgeInsets.only(
                          top: size.height * 0.01, left: size.width * 0.2),
                      child: Text("질병"),
                    )),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: size.height * 0.01, left: size.width * 0.2),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.network(
                            "http://221.162.66.211:49155/yoloimage/yolo_res_mqtt.png",
                            fit: BoxFit.cover,
                            width: 800,
                            height: 800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: size.height * 0.05, left: size.width * 0.17),
                    child: Text("온도"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: size.height * 0.01, left: size.width * 0.17),
                    child: Text(
                        '외부 : ${openweathercutemp} ˚C \n내부 : ${housecutemp} ˚C',
                        style: TextStyle(
                            fontFamily: 'Binggrae',
                            fontWeight: FontWeight.w500,
                            fontSize: 24)),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: size.height * 0.05, left: size.width * 0.2),
                    child: Text("생장현황"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: size.height * 0.01, left: size.width * 0.2),
                    child: Image.asset("Images/ui2.png", scale: 1.5),
                  )
                ],
              )
            ]),
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: size.height * 0.05, left: size.width * 0.2),
                      child: Text("상세 습도"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: size.height * 0.05, left: size.width * 0.2),
                      child: Text(houseHp.toString()),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: size.height * 0.05, left: size.width * 0.33),
                      child: Text("Co2량"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: size.height * 0.05, left: size.width * 0.33),
                      child: Text(houseCo2.toString()),
                    ),
                  ],
                )
              ],
            ),
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: size.height * 0.05, left: size.width * 0.2),
                      child: Text("일사량"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: size.height * 0.05, left: size.width * 0.2),
                      child: Text(houseacSlrdQy.toString()),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: bottomBar,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      );
    }

    if (_selectedIndex == 2) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('SmartFarm'),
          ),
          body: Center(child: AndroidWebviewOpen()),
          bottomNavigationBar: BottomNavigationBar(
            items: bottomBar,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          ));
    }
    if (_selectedIndex == 3) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('SmartFarm'),
        ),
        body: Center(
          child: Column(
            children: const <Widget>[Grow()],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: bottomBar,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      );
    } else {
      getWeather();
      getOpenWeather();
      return Scaffold(
        appBar: AppBar(
          title: const Text('SmartFarm'),
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                // BoxedIcon(WeatherIcons.sunset,size: 50),
                // const BoxedIcon(WeatherIcons.time_1,size: 50),
                Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            top: size.height * 0.05, left: size.width * 0.1),
                        child: Text('온도',
                            style: TextStyle(
                                fontFamily: 'Binggrae',
                                fontWeight: FontWeight.w500,
                                fontSize: 40))),
                    Padding(
                        padding: EdgeInsets.only(
                            top: size.height * 0.01, left: size.width * 0.1),
                        child: Text(
                            '외부 : ${openweathercutemp} ˚C \n내부 : ${housecutemp} ˚C',
                            style: TextStyle(
                                fontFamily: 'Binggrae',
                                fontWeight: FontWeight.w500,
                                fontSize: 24)))
                  ],
                ),

                Row(children: <Widget>[
                  Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                              top: size.height * 0.03, left: size.width * 0.3),
                          child: Text("Co2",
                              style: TextStyle(
                                  fontFamily: 'Binggrae',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 40))),
                      Padding(
                        padding: EdgeInsets.only(
                            top: size.height * 0.03, left: size.width * 0.3),
                        child: Text('${houseCo2.toString()} ppm',
                            style: TextStyle(
                                fontFamily: 'Binggrae',
                                fontWeight: FontWeight.w500,
                                fontSize: 24)),
                      )
                    ],
                  ),
                ]),
              ],
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Column(children: [
                    Padding(
                        padding: EdgeInsets.only(
                            top: size.height * 0.05, left: size.width * 0.15),
                        child: Text('습도',
                            style: TextStyle(
                                fontFamily: 'Binggrae',
                                fontWeight: FontWeight.w500,
                                fontSize: 40))),
                    Padding(
                        padding: EdgeInsets.only(
                            top: size.height * 0.01, left: size.width * 0.15),
                        child: Text(houseHp.toString(),
                            style: TextStyle(
                                fontFamily: 'Binggrae',
                                fontWeight: FontWeight.w500,
                                fontSize: 24))),
                  ]),
                  Column(children: [
                    Padding(
                        padding: EdgeInsets.only(
                            top: size.height * 0.05, left: size.width * 0.4),
                        child: Text('풍속',
                            style: TextStyle(
                                fontFamily: 'Binggrae',
                                fontWeight: FontWeight.w500,
                                fontSize: 40))),
                    Padding(
                        padding: EdgeInsets.only(
                            top: size.height * 0.01, left: size.width * 0.4),
                        child: Text("${openweatherwdspeed.toString()} m/s",
                            style: TextStyle(
                                fontFamily: 'Binggrae',
                                fontWeight: FontWeight.w500,
                                fontSize: 24))),
                  ]),
                ],
              ),
            ),
            Center(
              child: Row(children: [
                Column(
                  children: [
                    SizedBox(
                        width: 400,
                        height: 400,
                        child: Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(),
                                child: Column(children: [
                                  Expanded(
                                      child: Image.network(
                                    "http://221.162.66.211:49155/yoloimage/yolo_res_mqtt.png",
                                    fit: BoxFit.cover,
                                    width: 800,
                                    height: 800,
                                  ))
                                ])))),
                  ],
                )
              ]),
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: bottomBar,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      );
    }
  }
}
