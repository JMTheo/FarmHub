import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/custom_elevated_button.dart';
import '../../components/outline_text_form.dart';

import '../../services/auth_service.dart';

import '../../constants.dart';
import '../../main.dart';

import 'auth_page.dart';

class ForgotPassWordPage extends StatefulWidget {
  const ForgotPassWordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPassWordPage> createState() => _ForgotPassWordPageState();
}

class _ForgotPassWordPageState extends State<ForgotPassWordPage> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Esqueci a senha',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Column(
              children: <Widget>[
                OutlineTextForm(
                  hintTxt: 'Digite o seu e-mail',
                  iconData: Icons.email,
                  hideText: false,
                  txtController: emailController,
                  textInputAction: TextInputAction.next,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => (value == null || value.isEmail)
                      ? null
                      : "Por favor, coloque um e-mail válido.",
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomElevetedButton(
                  btnLabel: 'Recuperar senha',
                  onTap: () {
                    resetPassword();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Lembrou a senha?'),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AuthPage()));
                      },
                      child: const Text(
                        'Entrar',
                        style: TextStyle(color: kDefaultColorGreen),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future resetPassword() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    await AuthService.to
        .forgotPassword(emailController.text.trim().toLowerCase());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    });
  }
}
