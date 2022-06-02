import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';

import '../../components/custom_elevated_button.dart';
import '../../components/outline_text_form.dart';
import '../../components/toast_util.dart';

import '../../constants.dart';
import '../../enums/ToastOptions.dart';
import '../../main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    Key? key,
    required this.title,
    required this.onClickedSignIn,
  }) : super(key: key);
  final String title;
  final Function() onClickedSignIn;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final cpfController = TextEditingController();
  final db = FirebaseFirestore.instance;

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
              'Cadastro',
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
                  Row(
                    children: [
                      Expanded(
                        child: OutlineTextForm(
                          hintTxt: 'Nome',
                          iconData: Icons.person,
                          hideText: false,
                          txtController: nameController,
                          textInputAction: TextInputAction.next,
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Campo obrigatório.'
                              : null,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: OutlineTextForm(
                          hintTxt: 'Sobrenome',
                          iconData: Icons.person,
                          hideText: false,
                          txtController: surnameController,
                          textInputAction: TextInputAction.next,
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Campo obrigatório.'
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  OutlineTextForm(
                    hintTxt: 'Digite o seu cpf',
                    iconData: Icons.person,
                    hideText: false,
                    txtController: cpfController,
                    keyType: TextInputType.number,
                    inputFormat: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    textInputAction: TextInputAction.next,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        (value == null || value.isEmpty || value.length != 11)
                            ? null
                            : "Por favor, coloque apenas digitos.",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
                  OutlineTextForm(
                    hintTxt: 'Digite a sua senha',
                    iconData: Icons.lock,
                    hideText: true,
                    txtController: passwordController,
                    textInputAction: TextInputAction.go,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => (value != null && value.length < 6)
                        ? 'A senha deve contar no mínimo 6 caracteres'
                        : null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomElevetedButton(
                    btnLabel: 'Cadastrar-se',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        signUp();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Já cadastrado?'),
                      TextButton(
                        onPressed: widget.onClickedSignIn,
                        child: const Text(
                          'Entrar',
                          style: TextStyle(color: kDefaultColorGreen),
                        ),
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

  //TODO: Externarm em um service, refatorar em Provider e deixar um controller abstraindo tudo
  Future addUser(String uid) async {
    final user = <String, String>{
      "name": nameController.text.trim(),
      "surname": surnameController.text.trim(),
      "uid_auth": uid,
    };

    db.collection("users").add(user).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
  }

  Future signUp() async {
    FocusManager.instance.primaryFocus?.unfocus();

    //Verifica se o formulário foi preenchido.
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final User? user = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: emailController.text.trim().toLowerCase(),
                  password: passwordController.text.trim()))
          .user;

      if (user != null) {
        addUser(user.uid);
      }
    } on FirebaseAuthException catch (e) {
      //weak-password
      //email-already-in-use
      switch (e.code) {
        case 'weak-password':
          ToastUtil(
            text: 'A senha deve conter ao menos 6 caracteres',
            type: ToastOption.error,
          ).getToast();
          break;
        case 'email-already-in-use':
          ToastUtil(
            text: 'Email já está cadastrado',
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    });
  }
}
