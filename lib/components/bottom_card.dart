import 'package:flutter/material.dart';
import 'package:automacao_horta/constants.dart';

class BottomCard extends StatelessWidget {
  const BottomCard({required this.titulo, required this.valor});

  final String valor;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: double.infinity,
        margin: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: kActiveCardColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
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
      ),
    );
  }
}
