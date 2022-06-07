import 'package:flutter/material.dart';

class AddGround extends StatelessWidget {
  const AddGround({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicição do campo'),
      ),
      body: const Center(
        child: Text('FORM'),
      ),
    );
  }
}
