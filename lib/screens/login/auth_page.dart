import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../services/auth_service.dart';

import './login_page.dart';
import './register_page.dart';

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) =>
      Obx(() => AuthService.to.userIsAuthenticated.value
          ? const RegisterPage(title: 'Registro')
          : const LoginPage());
}
