import 'package:flutter/material.dart';

import '../constants.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({Key? key, required this.childWidget}) : super(key: key);

  final Widget childWidget;

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
      child: childWidget,
    ));
  }
}
