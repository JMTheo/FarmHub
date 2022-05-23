import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

import '../../components/custom_elevated_button.dart';
import '../../components/outline_text_form.dart';
import '../../components/toast_util.dart';

import '../../enums/ToastOptions.dart';

import 'auth_page.dart';

import '../../constants.dart';
import '../../main.dart';

class ForgotPassWordPage extends StatefulWidget {
  ForgotPassWordPage({Key? key}) : super(key: key);

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
                  validator: (value) => EmailValidator.validate(value!)
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

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim().toLowerCase());
      ToastUtil(
        text: 'Email para resetar a senha enviado!',
        type: ToastOption.success,
      ).getToast();

      WidgetsBinding.instance?.addPostFrameCallback((_) {
        navigatorKey.currentState!.popUntil((route) => route.isFirst);
      });
    } on FirebaseAuthException catch (e) {
      ToastUtil(
        text: 'Erro ao resertar a senha: ${e.message}',
        type: ToastOption.success,
      ).getToast();
      Navigator.of(context).pop();
    }
  }
}
