import 'package:flutter/material.dart';

import '../constants.dart';

class CustomElevetedButton extends StatelessWidget {
  const CustomElevetedButton(
      {Key? key, required this.onTap, required this.btnLabel})
      : super(key: key);

  final VoidCallback onTap;
  final String btnLabel;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
        primary: kDefaultColorGreen,
        onPrimary: Colors.black,
      ),
      child: Text(
        btnLabel,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
