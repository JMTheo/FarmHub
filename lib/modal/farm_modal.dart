import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../enums/FarmTypeOperation.dart';

import '../controller/db_controller.dart';

import '../model/farm.dart';

getModal(context, FarmTypeOperation type,
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
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome da fazenda'),
              ),
              TextField(
                controller: userController,
                decoration: const InputDecoration(
                  labelText: 'Usuários',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
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

                  if (documentSnapshot!.id.isNotEmpty) {
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
