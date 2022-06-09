import 'package:flutter/material.dart';

import '../constants.dart';

import './section_card.dart';

class BottomCard extends StatelessWidget {
  const BottomCard({Key? key, required this.titulo, required this.valor})
      : super(key: key);

  final String valor;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      childWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            valor,
            style: kNumbersTextStyle,
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            titulo,
            style: kLabelTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
