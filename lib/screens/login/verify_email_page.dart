import 'dart:async';

import 'package:automacao_horta/screens/home_page.dart';
import 'package:automacao_horta/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/db_controller.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    DBController.to.getUserData(AuthService.to.user!.uid);

    AuthService.to.getVerificationStatus();

    if (!AuthService.to.isEmailVerified.value) {
      AuthService.to.sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Obx(
        () => AuthService.to.isEmailVerified.value
            ? HomePage(
                stream: DBController.to
                    .getFarms(DBController.to.userData.value.email!),
              )
            : Scaffold(
                appBar: AppBar(
                  title: const Text('Verifique o email'),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'O e-mail de verificação foi enviado para o seu e-mail cadastrado',
                        style: TextStyle(fontSize: 20.0),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50.0),
                        ),
                        icon: const Icon(
                          Icons.email,
                          size: 32.0,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Reenviar e-mail de verificação',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: AuthService.to.canResendEmail.value
                            ? AuthService.to.sendVerificationEmail
                            : null,
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextButton(
                        onPressed: () => AuthService.to.logout(),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(fontSize: 24.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      );

  Future checkEmailVerified() async {
    await AuthService.to.checkEmailVerified();

    if (AuthService.to.isEmailVerified.value) timer?.cancel();
  }
}
