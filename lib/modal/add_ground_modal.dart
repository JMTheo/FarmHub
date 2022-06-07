import 'package:automacao_horta/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../enums/FarmTypeOperation.dart';

import '../components/outline_text_form.dart';
import '../controller/db_controller.dart';

import '../model/ground.dart';

addGroundModal(
    String title, context, FarmTypeOperation typeOperation, String? farmID,
    [DocumentSnapshot? documentSnapshot]) {
  final formKey = GlobalKey<FormState>();
  final regionController = TextEditingController();
  final specieController = TextEditingController();
  final typeController = TextEditingController();
  final String buttonText = typeOperation == FarmTypeOperation.create
      ? 'Criar região'
      : 'Atualizar região';

  if (documentSnapshot != null) {
    regionController.text = documentSnapshot['specie'];
    specieController.text = documentSnapshot['region'];
    typeController.text = documentSnapshot['type'];
  }

  return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: kHighTitle),
                kSpaceBoxModal,
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
                kSpaceBoxModal,
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
                kSpaceBoxModal,
                OutlineTextForm(
                  hintTxt: 'Selecione o tipo',
                  iconData: FontAwesomeIcons.list,
                  hideText: false,
                  txtController: typeController,
                  textInputAction: TextInputAction.next,
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Campo obrigatório.'
                      : null,
                ),
                kSpaceBoxModal,
                ElevatedButton(
                  child: Text(buttonText),
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    final String region = regionController.text.trim();
                    final String specie = specieController.text.trim();
                    final String type =
                        typeController.text.trim().toLowerCase();

                    Ground ground = Ground(
                        farm: '', type: type, region: region, specie: specie);

                    if (documentSnapshot != null) {
                      ground.id = documentSnapshot.id;
                      ground.farm = documentSnapshot['farm'];
                    } else {
                      ground.farm = farmID!;
                    }

                    if (typeOperation == FarmTypeOperation.create) {
                      DBController.to.addGround(ground);
                    } else {
                      DBController.to.updateGround(ground);
                    }

                    regionController.text = '';
                    specieController.text = '';
                    typeController.text = '';
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ),
          ),
        );
      });
}
