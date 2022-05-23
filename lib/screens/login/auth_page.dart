import 'package:automacao_horta/screens/login/login_page.dart';
import 'package:automacao_horta/screens/login/register_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) => isLogin
      ? LoginPage(title: 'login', onClickedSignUp: toggle)
      : RegisterPage(title: 'Registro', onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
