import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

import '../../services/auth_service.dart';

import '../../components/custom_elevated_button.dart';
import '../../components/outline_text_form.dart';

import '../../constants.dart';
import '../../main.dart';

import 'forgot_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

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
              'FarmHub',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  OutlineTextForm(
                    iconData: Icons.email,
                    hintTxt: 'Digite o seu e-mail',
                    hideText: false,
                    txtController: emailController,
                    validator: (value) => EmailValidator.validate(value!)
                        ? null
                        : "Por favor, coloque um e-mail válido.",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  OutlineTextForm(
                    hintTxt: 'Senha',
                    iconData: Icons.lock,
                    hideText: true,
                    textInputAction: TextInputAction.go,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    txtController: passwordController,
                    validator: (value) => (value != null && value.length < 6)
                        ? 'A senha deve contar no mínimo 6 caracteres'
                        : null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomElevetedButton(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          sigIn();
                        }
                      },
                      btnLabel: 'Entrar'),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    child: const Text(
                      'Esqueceu a senha?',
                      style: TextStyle(
                        color: kDefaultColorGreen,
                        fontSize: 15.0,
                      ),
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ForgotPassWordPage())),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Ainda não cadastrado?'),
                      TextButton(
                        onPressed: () {
                          AuthService.to.toggle();
                        },
                        child: const Text('Criar uma conta',
                            style: TextStyle(color: kDefaultColorGreen)),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future sigIn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    AuthService.to.login(emailController.text.trim().toLowerCase(),
        passwordController.text.trim());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    });
  }
}
