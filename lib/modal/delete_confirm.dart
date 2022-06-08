import 'package:flutter/material.dart';

import '../enums/app_screens.dart';
import '../enums/toast_option.dart';

import '../controller/db_controller.dart';

import '../components/toast_util.dart';

getModalConfirmDelete(context, String id, AppScreens screen) {
  String identifier = '';

  if (screen == AppScreens.farm) {
    identifier = 'fazenda';
  } else {
    identifier = 'região';
  }

  showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text('Excluir $identifier'),
            content: Text('Deseja realmente excluir essa $identifier'),
            actions: [
              TextButton(
                  onPressed: () {
                    ToastUtil(
                      text: 'Exclusão cancelada!',
                      type: ToastOption.success,
                    ).getToast();
                    Navigator.pop(context, 'Cancel');
                  },
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () {
                    if (screen == AppScreens.farm) {
                      DBController.to.deleteFarm(id);
                    } else {
                      DBController.to.deleteGround(id);
                    }

                    Navigator.pop(context, 'Confirmar');
                  },
                  child: const Text('Confirmar'))
            ],
          ));
}
