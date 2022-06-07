import 'package:automacao_horta/controller/db_controller.dart';
import 'package:automacao_horta/enums/FarmTypeOperation.dart';
import 'package:automacao_horta/modal/add_ground_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:automacao_horta/components/mini_card.dart';
import 'package:automacao_horta/constants.dart';

class CardPlant extends StatefulWidget {
  CardPlant({
    Key? key,
    this.urlImg,
    this.estadoLampada,
    this.umidadeDoSolo,
    this.functionA,
    this.functionL,
    this.groundObj,
    required this.id,
    required this.apelidoPlanta,
    required this.especiePlanta,
  }) : super(key: key);

  final DocumentSnapshot? groundObj;
  final String id;
  final String apelidoPlanta;
  final String especiePlanta;
  final VoidCallback? functionL;
  final VoidCallback? functionA;
  final String? urlImg;
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
          const SizedBox(height: 80.0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              widget.apelidoPlanta,
              style: kSubTitle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 5, 0, 0),
            child: Text(
              widget.especiePlanta,
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
              //TODO: Acrescentar modal de confirmação
              MiniCard(
                content: FontAwesomeIcons.trash,
                onTap: () {
                  DBController.to.deleteGround(widget.id);
                },
              ),
              MiniCard(
                content: Icons.edit,
                onTap: () async {
                  await addGroundModal('Editar região', context,
                      FarmTypeOperation.update, '', widget.groundObj);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
