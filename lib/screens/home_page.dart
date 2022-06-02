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
        children: const <Widget>[
          Center(
            child: Text('Olá, [nome do usuario]'),
          ),
          SizedBox(
            height: 20.0,
          ),
          //TODO: Prototipar a home
        ],
      ),
    );
  }

  Future getUserData(User user) async {}
}
