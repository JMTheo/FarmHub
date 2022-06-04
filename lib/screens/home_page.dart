import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                AuthService.to.logout();
              },
              icon: const Icon(Icons.person)),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text('Olá, ${AuthService.to.user?.uid}'),
            ),
          ),
          Expanded(
              child: ListView(
            children: const <Widget>[
              Text('fazenda a'),
              Text('fazenda b'),
              Text('fazenda c'),
            ],
          ))
        ],
      ),
    );
  }
}
