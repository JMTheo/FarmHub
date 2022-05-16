import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

import '/screens/home_page.dart';
import '/screens/login_page.dart';

import 'constants.dart';

void main() {
  runApp(MyApp());
}

//cor verdinha 0xFF35CE8D | bariol
class MyApp extends StatelessWidget {
  // TODO: Acrescentar a fonte bariol
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iPlant',
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

      initialRoute: '/login',
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => const LoginPage(title: 'Login'),
      },
    );
  }
}
