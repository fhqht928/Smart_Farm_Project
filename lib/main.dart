import 'package:flutter/material.dart';

import 'package:weather_icons/weather_icons.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:html';

import 'grow.dart';

var url;
var site;
var temp;
var tempMax;
var tempMin;
var weatherMain;
var Get;
var code;
var data1;
var windspeed;

void main() {
  runApp(const MyApp());
}

void webViewOpen(String site) {
  ui.platformViewRegistry.registerViewFactory(
      site,
      (int viewId) => IFrameElement()
        ..width = '640'
        ..height = '360'
        ..src = 'https://www.' + site + '.com'
        ..style.border = 'none');
}

void getWeather() async {
  url = Uri.https('api.openweathermap.org', '/data/2.5/weather',
      {'id': '1835841', 'appid': 'd88d65f0066783c65a0fad51dc404e25'});
  http.Response response;

  response = await http.get(url);
  data1 = convert.jsonDecode(response.body) as Map<String, dynamic>;
  temp = data1["main"]["temp"] - 273;
  tempMax = data1["main"]["temp_max"] - 273;
  tempMin = data1["main"]["temp_min"] - 273;
  weatherMain = data1["weather"][0]["main"];
  code = 800; //data1["weather"][0]["id"];
  windspeed = data1["wind"]["speed"];
  print(temp);
  print(tempMax);
  print(tempMin);
  print(weatherMain);
  print(code);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    getWeather();
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
      site = 'nexon';
      webViewOpen(site);
      return Scaffold(
        appBar: AppBar(
          title: const Text('SmartFarm'),
        ),
        body: Center(
          child: HtmlElementView(viewType: site),
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
      site = 'ventusky';
      webViewOpen(site);
      return Scaffold(
          appBar: AppBar(
            title: const Text('SmartFarm'),
          ),
          body: SafeArea(
            child: HtmlElementView(viewType: site),
          ),

/*
                children: <Widget>[
             Image.asset("Images/ui2.png",width: size.width*0.5,height: size.height*0.2,),
                   Column(
                      children:
                      <Widget>[
                        //BoxedIcon(WeatherIcons.sunset,size: 50),
                        //const BoxedIcon(WeatherIcons.time_1,size: 50),
                        Padding(
                          padding: EdgeInsets.only(top: size.height*0.05,right: size.width*0.5),
                          child: Column(
                            children: <Widget>[
                              Center(child: Text('현재 온도 : ${temp.floor().toString()}',style: TextStyle(fontFamily: 'Binggrae',fontWeight: FontWeight.w500,fontSize: 10))),
                              Center(child: Text('최고 온도 : ${tempMax.floor().toString()}',style: TextStyle(fontFamily: 'Binggrae',fontWeight: FontWeight.w500,fontSize: 10))),
                              Center(child: Text('최저 온도 : ${tempMin.floor().toString()}',style: TextStyle(fontFamily: 'Binggrae',fontWeight: FontWeight.w500,fontSize: 10))),
                              Center(child:Text('바람 세기 : ${windspeed.toString()}',style: TextStyle(fontFamily: 'Binggrae',fontWeight: FontWeight.w500,fontSize:10))),
                              Center(child:Text(weatherMain.toString(),style: TextStyle(fontFamily: 'Binggrae',fontWeight: FontWeight.w500,fontSize: 10))),
                              code == 800
                                  ? BoxedIcon(WeatherIcons.day_sunny)
                                  : code / 100 == 8||
                                  code / 100 == 2
                                  ? BoxedIcon(WeatherIcons.cloud)
                                  :code / 100 == 3||
                                  code / 100 == 5
                                  ? BoxedIcon(WeatherIcons.day_sunny_overcast)
                                  : code / 100== 6
                                  ? BoxedIcon(WeatherIcons.night_alt_cloudy_windy)
                                  : BoxedIcon(WeatherIcons.cloud_up)
                            ],
                          ),
                        ),
                      ]
                  ),
          ],
          ),
*/

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
      return Scaffold(
        appBar: AppBar(
          title: const Text('SmartFarm'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[Text(_selectedIndex.toString())],
          ),
        ),
        bottomNavigationBar:  BottomNavigationBar(
          items: bottomBar,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      );
    }
  }
}
