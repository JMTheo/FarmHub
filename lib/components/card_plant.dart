import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';

import '../enums/farm_type_operation.dart';
import '../enums/app_screens.dart';

import '../modal/add_ground_modal.dart';
import '../modal/delete_confirm.dart';

import './mini_card.dart';

class CardPlant extends StatefulWidget {
  CardPlant({
    Key? key,
    this.estadoLampada,
    this.umidadeDoSolo,
    this.functionA,
    this.functionL,
    this.groundObj,
    required this.id,
    required this.type,
    required this.specie,
    required this.region,
  }) : super(key: key);

  final DocumentSnapshot? groundObj;
  final String id;
  final String specie;
  final String region;
  final VoidCallback? functionL;
  final VoidCallback? functionA;
  final String type;
  int? umidadeDoSolo;
  bool? estadoLampada;

  @override
  _CardPlantState createState() => _CardPlantState();
}

class _CardPlantState extends State<CardPlant> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      width: 300.0,
      decoration: BoxDecoration(
        color: kDefaultColorGreen,
        border: Border.all(color: kDefaultColorGreen, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //TODO: COLOCAR UMA IMG DEFAULT DE ACORDO COM O TIPO
          //
          // Center(
          //   child: Padding(
          //     padding: const EdgeInsets.only(top: 8.0),
          //     child:
          //     Image.asset(
          //       widget.urlImg,
          //       height: 150.0,
          //       width: 150.0,
          //     ),
          //   ),
          // ),
          Center(
              child: Container(
                  margin: const EdgeInsets.only(top: 60),
                  child: FaIcon(getIconByType(widget.type), size: 100.0))),
          const SizedBox(height: 40.0),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
            child: Text(
              widget.region,
              style: kSubTitle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              widget.specie,
              style: kHighTitle,
            ),
          ),

          Row(
            children: [
              const SizedBox(
                width: 10.0,
              ),
              MiniCard(
                content: '${widget.umidadeDoSolo}%',
              ), //Dado sensor de umidade de solo
              MiniCard(
                content: FontAwesomeIcons.droplet,
                onTap: widget.functionA,
              ),
              MiniCard(
                content: Icons.edit,
                onTap: () async {
                  await addGroundModal('Editar região', context,
                      FarmTypeOperation.update, '', widget.groundObj);
                },
              ),
              MiniCard(
                content: FontAwesomeIcons.trash,
                onTap: () {
                  getModalConfirmDelete(context, widget.id, AppScreens.ground);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  IconData getIconByType(String type) {
    IconData icon = FontAwesomeIcons.leaf;
    switch (type) {
      case 'Fruta':
        icon = FontAwesomeIcons.appleWhole;
        break;
      case 'Vegetal':
        icon = FontAwesomeIcons.carrot;
        break;
      case 'Hortaliça':
        icon = FontAwesomeIcons.seedling;
        break;
      case 'Grão':
        icon = FontAwesomeIcons.wheatAwn;
        break;
    }

    return icon;
  }
}
