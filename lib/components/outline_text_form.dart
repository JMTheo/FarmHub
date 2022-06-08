import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OutlineTextForm extends StatelessWidget {
  const OutlineTextForm({
    required this.hintTxt,
    required this.iconData,
    required this.hideText,
    this.onClick,
    this.validator,
    this.txtController,
    this.autoValidateMode,
    this.textInputAction,
    this.keyType,
    this.inputFormat,
  });

  final VoidCallback? onClick;
  final bool hideText;
  final String hintTxt;
  final IconData iconData;
  final String? Function(String?)? validator;
  final TextEditingController? txtController;
  final AutovalidateMode? autoValidateMode;
  final TextInputAction? textInputAction;
  final TextInputType? keyType;
  final List<TextInputFormatter>? inputFormat;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: txtController,
      onTap: onClick,
      validator: validator,
      obscureText: hideText,
      keyboardType: keyType,
      textInputAction: textInputAction,
      autovalidateMode: autoValidateMode,
      inputFormatters: inputFormat,
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
