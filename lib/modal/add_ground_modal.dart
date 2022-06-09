import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';

import '../enums/farm_type_operation.dart';

import '../controller/db_controller.dart';

import '../model/ground.dart';

import '../components/outline_text_form.dart';

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
    regionController.text = documentSnapshot['region'];
    specieController.text = documentSnapshot['specie'];
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
                onClick: () {
                  FocusScope.of(context).unfocus();
                  onTextFieldTap(context, typeController);
                },
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
                  final String type = typeController.text.trim();

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
    },
  );
}

void onTextFieldTap(context, TextEditingController typeController) {
  TextEditingController searchTextEditingController = TextEditingController();
  List<SelectedListItem> greeneryTypes = [];
  for (String type in kTypesGreenery) {
    greeneryTypes.add(SelectedListItem(false, type));
  }

  DropDownState(
    DropDown(
      submitButtonText: 'Confirmar seleção',
      submitButtonColor: kDefaultColorGreen,
      searchHintText: 'Digite o tipo da planta',
      bottomSheetTitle: 'Tipos',
      searchBackgroundColor: Colors.black12,
      dataList: greeneryTypes,
      enableMultipleSelection: false,
      searchController: searchTextEditingController,
      selectedItem: (String selected) {
        typeController.text = selected;
      },
    ),
  ).showModal(context);
}
