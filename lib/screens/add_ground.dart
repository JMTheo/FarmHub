import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../components/custom_elevated_button.dart';
import '../components/outline_text_form.dart';
import '../constants.dart';

class AddGround extends StatefulWidget {
  const AddGround({Key? key}) : super(key: key);

  @override
  State<AddGround> createState() => _AddGroundState();
}

class _AddGroundState extends State<AddGround> {
  final _formKey = GlobalKey<FormState>();
  final regionController = TextEditingController();
  final specieController = TextEditingController();
  final typeController = TextEditingController();

  @override
  void dispose() {
    regionController.dispose();
    specieController.dispose();
    typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicição do campo'),
      ),
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
                  OutlineTextForm(
                    hintTxt: 'Região',
                    iconData: FontAwesomeIcons.map,
                    hideText: false,
                    txtController: regionController,
                    textInputAction: TextInputAction.next,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Campo obrigatório.'
                        : null,
                  ),
                  kSpaceBox,
                  OutlineTextForm(
                    hintTxt: 'Espécie',
                    iconData: FontAwesomeIcons.leaf,
                    hideText: false,
                    txtController: specieController,
                    textInputAction: TextInputAction.next,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Campo obrigatório.'
                        : null,
                  ),
                  kSpaceBox,
                  OutlineTextForm(
                    hintTxt: 'Selecione o tipo',
                    iconData: FontAwesomeIcons.list,
                    hideText: false,
                    txtController: typeController,
                    textInputAction: TextInputAction.next,
                  ),
                  kSpaceBox,
                  CustomElevetedButton(
                    btnLabel: 'Cadastrar-se',
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        print('form ok');
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
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
