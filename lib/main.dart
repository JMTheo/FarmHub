import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

import 'package:automacao_horta/screens/home.dart';

import 'constants.dart';

void main() {
  runApp(MyApp());
}

//cor verdinha 0xFF35CE8D | bariol
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iPlant',
      builder: BotToastInit(), //1. call BotToastInit
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: kDefaultColorGreen,
          ),
          textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.white)),
          scaffoldBackgroundColor: const Color(0XFF0A0E21)),

      home: Home(),
    );
  }
}
