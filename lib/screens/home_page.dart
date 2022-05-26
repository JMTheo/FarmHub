import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: <Widget>[
          const Center(
            child: Text('Olá, [NOME DO USUARIO]'),
          ),
          const SizedBox(
            height: 20.0,
          ),
          ListView(
            children: const <Widget>[
              Text('fazenda 1'),
              Text('fazenda 1'),
              Text('fazenda 1'),
            ],
          )
        ],
      ),
    );
  }
}
