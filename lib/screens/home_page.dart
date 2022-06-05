import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/db_controller.dart';
import '../services/auth_service.dart';

import 'detailed_plant.dart';

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
              child: Obx(() => Text(
                  'Olá, ${DBController.to.userData.value.name.toString()} ${DBController.to.userData.value.surname.toString()}')),
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
                    Get.to(DetailedPlantPage());
                  },
                  child: const Text('Ir para fazenda x'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
