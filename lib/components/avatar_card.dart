import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
              leading: const FaIcon(
                FontAwesomeIcons.user,
                size: 40.0,
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
