import 'package:automacao_horta/components/section_card.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class BottomCard extends StatelessWidget {
  const BottomCard({required this.titulo, required this.valor});

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
            height: 50,
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
