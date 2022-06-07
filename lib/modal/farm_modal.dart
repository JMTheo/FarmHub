import 'package:automacao_horta/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../enums/FarmTypeOperation.dart';

import '../components/outline_text_form.dart';
import '../controller/db_controller.dart';

import '../model/farm.dart';

getModal(context, FarmTypeOperation type, String title,
    [DocumentSnapshot? documentSnapshot]) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final String buttonText =
      type == FarmTypeOperation.create ? 'Criar fazenda' : 'Atualizar fazenda';
  if (documentSnapshot != null) {
    nameController.text = documentSnapshot['name'];
    userController.text = documentSnapshot['canAccess'].join(',');
  } else {
    userController.text = '${DBController.to.userData.value.email!},';
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: kHighTitle),
              kSpaceBox,
              OutlineTextForm(
                hintTxt: 'Nome da fazenda',
                iconData: FontAwesomeIcons.tractor,
                hideText: false,
                txtController: nameController,
                textInputAction: TextInputAction.next,
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Campo obrigatório.'
                    : null,
              ),
              kSpaceBoxModal,
              OutlineTextForm(
                hintTxt: 'Usuários',
                iconData: FontAwesomeIcons.user,
                hideText: false,
                txtController: userController,
                textInputAction: TextInputAction.next,
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Campo obrigatório.'
                    : null,
              ),
              kSpaceBox,
              ElevatedButton(
                child: Text(buttonText),
                onPressed: () async {
                  final String name = nameController.text;
                  final String users = userController.text;
                  List<String> usersList = users.split(',');
                  usersList.addIf(
                      !usersList
                          .contains(DBController.to.userData.value.email!),
                      DBController.to.userData.value.email!);
                  Farm farm = Farm(
                      name: name,
                      canAccess: usersList,
                      owner: DBController.to.userData.value.email!,
                      fullName:
                          '${DBController.to.userData.value.name} ${DBController.to.userData.value.surname}');

                  if (documentSnapshot != null) {
                    farm.id = documentSnapshot.id;
                  }

                  if (type == FarmTypeOperation.create) {
                    DBController.to.addFarm(farm);
                  } else {
                    DBController.to.updateFarm(farm);
                  }

                  nameController.text = '';
                  userController.text = '';
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      });
}
