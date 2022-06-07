import 'package:automacao_horta/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../enums/FarmTypeOperation.dart';

import '../controller/db_controller.dart';

import '../model/ground.dart';

addGroundModal(context, FarmTypeOperation typeOperation, String? farmID,
    [DocumentSnapshot? documentSnapshot]) {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: regionController,
                decoration: const InputDecoration(labelText: 'Região'),
              ),
              TextField(
                controller: specieController,
                decoration: const InputDecoration(
                  labelText: 'Espécie',
                ),
              ),
              TextField(
                controller: typeController,
                decoration: const InputDecoration(
                  labelText: 'Tipo',
                ),
              ),
              kSpaceBox,
              ElevatedButton(
                child: Text(buttonText),
                onPressed: () async {
                  final String region = regionController.text.trim();
                  final String specie = specieController.text.trim();
                  final String type = typeController.text.trim().toLowerCase();

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
        );
      });
}
