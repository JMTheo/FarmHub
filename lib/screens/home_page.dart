import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: <Widget>[
          const Expanded(
            child: Center(
              child: Text('Olá, [nome do usuario]'),
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

  Future getUserData(User user) async {}
}
