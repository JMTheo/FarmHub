import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
              child: Text('Olá, ${AuthService.to.user?.email}'),
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                const Text('fazenda a'),
                const Text('fazenda b'),
                const Text('fazenda c'),
                TextButton(
                  onPressed: () {
                    //DBController().getUserData(AuthService.to.user?.uid);
                  },
                  child: const Text('Teste'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
