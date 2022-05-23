import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

import '../../enums/ToastOptions.dart';

import '../../components/toast_util.dart';
import '../../components/custom_elevated_button.dart';
import '../../components/outline_text_form.dart';

import '../../constants.dart';
import '../../main.dart';

import 'forgot_password.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
    required this.title,
    required this.onClickedSignUp,
  }) : super(key: key);
  final String title;
  final VoidCallback onClickedSignUp;

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
              'iPlant',
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
                        onPressed: widget.onClickedSignUp,
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

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim().toLowerCase(),
        password: passwordController.text.trim(),
      );
      ToastUtil(type: ToastOption.success, text: 'Sucesso ao logar!');
    } on FirebaseAuthException catch (e) {
      //Tratamento de erro
      switch (e.code) {
        case 'too-many-requests':
          ToastUtil(
            text:
                'Muitas tentativas para realizar o login, aguarde um monento!',
            type: ToastOption.error,
          ).getToast();
          break;
        case 'user-not-found':
        case 'wrong-password':
          ToastUtil(
            text: 'Email ou senha incorretos!',
            type: ToastOption.error,
          ).getToast();
          break;
        default:
          ToastUtil(
            type: ToastOption.error,
            text: 'Erro inesperado, contate o adiministrador do aplicativo',
          ).getToast();
          print('Erro ao realizar login: ${e.code}');
          break;
      }
    }
    //navigatorKey.currentState!.popUntil((route) => true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    });
  }
}
