import 'package:automacao_horta/config.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

import '/screens/main_page.dart';

import 'constants.dart';

Future<void> main() async {
  await initConfig();
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

//cor verdinha 0xFF35CE8D | bariol
class MyApp extends StatelessWidget {
  // TODO: Acrescentar a fonte bariol
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: MainPage(),
    );
  }
}
