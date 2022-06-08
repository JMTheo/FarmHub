import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../controller/db_controller.dart';

import './section_card.dart';

class AvatarCard extends StatelessWidget {
  const AvatarCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SectionCard(
          childWidget: Center(
            child: ListTile(
              leading: const CircleAvatar(
                radius: 25.0,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage("assets/img/fruits/apple.png"),
              ),
              title: Obx(() => Text(
                    "${DBController.to.userData.value.name.toString()} ${DBController.to.userData.value.surname.toString()}",
                    style: const TextStyle(fontSize: 25.0),
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
