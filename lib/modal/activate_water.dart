import 'package:automacao_horta/controller/iot_controller.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

import '../components/outline_text_form.dart';

getWaterModal(context, String farmID) {
  final TextEditingController secondsController = TextEditingController();

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
            const Text('Irrigação', style: kHighTitle),
            kSpaceBox,
            OutlineTextForm(
              hintTxt: 'Digite o tempo em segundos',
              iconData: FontAwesomeIcons.faucetDrip,
              hideText: false,
              keyType: TextInputType.number,
              inputFormat: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              txtController: secondsController,
              textInputAction: TextInputAction.send,
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Campo obrigatório.'
                  : null,
            ),
            kSpaceBox,
            ElevatedButton(
              child: const Text('Enviar sinal'),
              onPressed: () async {
                int ms = int.parse(secondsController.text.trim());
                IoTController.to.releaseWater(farmID, ms);

                secondsController.text = '';
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    },
  );
}
