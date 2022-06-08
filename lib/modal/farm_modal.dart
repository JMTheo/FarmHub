import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';

import '../enums/farm_type_operation.dart';

import '../controller/db_controller.dart';

import '../model/farm.dart';

import '../components/outline_text_form.dart';

getFarmModal(context, FarmTypeOperation type, String title,
    [DocumentSnapshot? documentSnapshot]) {
  final TextEditingController nameController = TextEditingController();
  TextEditingController userController = TextEditingController();
  final String buttonText =
      type == FarmTypeOperation.create ? 'Criar fazenda' : 'Atualizar fazenda';
  if (documentSnapshot != null) {
    nameController.text = documentSnapshot['name'];
    userController.text = documentSnapshot['canAccess'].join(',');
  } else {
    userController.text = '${DBController.to.userData.value.email!},';
  }

  DBController.to.getAllUser();
  DBController.to.getUsersAccessFarm(documentSnapshot!.id);

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
              onClick: () {
                FocusScope.of(context).unfocus();
                onTextFieldTap(context, userController);
              },
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Campo obrigatório.'
                  : null,
            ),
            kSpaceBox,
            ElevatedButton(
              child: Text(buttonText),
              onPressed: () async {
                final String name = nameController.text;
                String userEmail = DBController.to.userData.value.email!;
                DBController.to.selectedUsersList.addIf(
                  !DBController.to.selectedUsersList.contains(userEmail),
                  userEmail,
                );
                Farm farm = Farm(
                    name: name,
                    canAccess: DBController.to.selectedUsersList,
                    owner: DBController.to.userData.value.email!,
                    fullName:
                        '${DBController.to.userData.value.name} ${DBController.to.userData.value.surname}');

                farm.id = documentSnapshot.id;

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
    },
  );
}

void onTextFieldTap(context, TextEditingController userControllerTXT) {
  TextEditingController searchTextEditingController = TextEditingController();

  DropDownState(
    DropDown(
      submitButtonText: 'Confirmar seleção',
      submitButtonColor: kDefaultColorGreen,
      searchHintText: 'Digite o email do usuário',
      bottomSheetTitle: 'Usuários',
      searchBackgroundColor: Colors.black12,
      dataList: DBController.to.allUsersList,
      enableMultipleSelection: true,
      searchController: searchTextEditingController,
      selectedItems: (List<dynamic> selectedList) {
        for (var element in selectedList) {
          DBController.to.selectedUsersList.add(element);
        }
      },
    ),
  ).showModal(context);
}
