import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import '../config.dart';

import '/screens/main_page.dart';

import 'constants.dart';

Future<void> main() async {
  await initConfig();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

//cor verdinha 0xFF35CE8D | bariol
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FarmHub',
      navigatorKey: navigatorKey,
      builder: BotToastInit(), //1. call BotToastInit
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(
          color: kScaffoldBGColor,
        ),
        colorScheme:
            const ColorScheme.dark().copyWith(primary: kDefaultColorGreen),
        hintColor: Colors.white,
        scaffoldBackgroundColor: kScaffoldBGColor,
      ),
      home: const MainPage(),
    );
  }
}
