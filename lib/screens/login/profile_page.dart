import 'package:automacao_horta/controller/db_controller.dart';
import 'package:automacao_horta/screens/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: <Widget>[
        IconButton(
            onPressed: () {
              AuthService.to.logout();
              Get.to(() => const LoginPage());
            },
            icon: const Icon(Icons.person)),
      ]),
      body: Center(
          child: Text(
              'Esqueleto da tela de perfil, email: ${DBController.to.userData.value.email.toString()}')),
    );
  }
}
