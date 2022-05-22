import 'package:flutter/material.dart';

class OutlineTextForm extends StatelessWidget {
  OutlineTextForm({
    required this.hintTxt,
    required this.iconData,
    required this.validator,
    required this.hideText,
    this.txtController,
    this.autoValidateMode,
    this.textInputAction,
  });

  final bool hideText;
  final String hintTxt;
  final IconData iconData;
  final String? Function(String?)? validator;
  final TextEditingController? txtController;
  final AutovalidateMode? autoValidateMode;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: txtController,
      validator: validator,
      obscureText: hideText,
      textInputAction: textInputAction,
      autovalidateMode: autoValidateMode,
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
