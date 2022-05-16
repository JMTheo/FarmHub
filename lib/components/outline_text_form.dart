import 'package:flutter/material.dart';

class OutlineTextForm extends StatelessWidget {
  OutlineTextForm(
      {required this.hintTxt, required this.iconData, required this.validator});

  final String hintTxt;
  final IconData iconData;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: hintTxt,
        prefixIcon: Icon(iconData),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
