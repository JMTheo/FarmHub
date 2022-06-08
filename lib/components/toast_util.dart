import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants.dart';
import '../enums/toast_option.dart';

class ToastUtil {
  ToastUtil({required this.text, required this.type});

  final String text;
  final ToastOption type;

  dynamic getToast() {
    Color bgColor;
    Color txtColor;

    switch (type) {
      case ToastOption.success:
        bgColor = kSuccessToast['bgColor']!;
        txtColor = kSuccessToast['txtColor']!;
        break;
      case ToastOption.warning:
        bgColor = kWarningToast['bgColor']!;
        txtColor = kWarningToast['txtColor']!;
        break;
      case ToastOption.error:
        bgColor = kErrorToast['bgColor']!;
        txtColor = kErrorToast['txtColor']!;
        break;
      default:
        bgColor = Colors.blue;
        txtColor = Colors.white;
        break;
    }

    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: bgColor,
      textColor: txtColor,
      fontSize: 16.0,
    );
  }
}
