import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

import '../components/custom_elevated_button.dart';
import '../components/outline_text_form.dart';
import '../constants.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
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
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlineTextForm(
                          hintTxt: 'Nome',
                          iconData: Icons.person,
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
                    hintTxt: 'Digite o seu e-mail',
                    iconData: Icons.email,
                    validator: (value) => EmailValidator.validate(value!)
                        ? null
                        : "Por favor, coloque um e-mail válido.",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  OutlineTextForm(
                    hintTxt: 'Digite a sua senha',
                    iconData: Icons.email,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Por favor, digite a sua senha'
                        : null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomElevetedButton(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {}
                      },
                      btnLabel: 'Cadastrar-se'),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Já cadastrado?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const LoginPage(title: 'Login'),
                            ),
                          );
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
            )
          ],
        ),
      ),
    );
  }
}