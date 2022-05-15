import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:automacao_horta/components/mini_card.dart';
import 'package:automacao_horta/constants.dart';

class CardPlant extends StatefulWidget {
  CardPlant({
    required this.urlImg,
    required this.apelidoPlanta,
    required this.especiePlanta,
    required this.estadoLampada,
    this.umidadeDoSolo,
    this.functionA,
    this.functionL,
  });

  final String urlImg;
  final String apelidoPlanta;
  final String especiePlanta;
  final VoidCallback? functionL;
  final VoidCallback? functionA;
  int? umidadeDoSolo;
  bool estadoLampada;

  @override
  _CardPlantState createState() => _CardPlantState();
}

class _CardPlantState extends State<CardPlant> {
  _mudarLuz() {
    return widget.estadoLampada
        ? FontAwesomeIcons.solidLightbulb
        : FontAwesomeIcons.lightbulb;
  }

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
          Center(
            child: Image.asset(
              widget.urlImg,
              height: 200.0,
              width: 200.0,
            ),
          ),
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
                content: widget.umidadeDoSolo.toString() + '%',
              ), //Dado sensor de umidade de solo
              MiniCard(
                content: FontAwesomeIcons.droplet,
                onTap: widget.functionA,
              ),
              MiniCard(
                content: _mudarLuz(),
                onTap: widget.functionL,
              ),
              MiniCard(
                content: FontAwesomeIcons.question,
                onTap: () {
                  print('Interrogação');
                },
              ), //Ir para página da planta
            ],
          )
        ],
      ),
    );
  }
}
