import 'package:flutter/material.dart';

class TextFieldComponent {
  static Widget normalTextField({required context, Key? key, TextEditingController? controller, InputDecoration? decoration}) {
    return Container(
      color: Colors.transparent,
      height: 45,
      child: TextFormField(
        key: key,
        controller: controller,
        decoration: decoration,
      ),
    );
  }

  static Widget passwordTextField({required context, Key? key, TextEditingController? controller, InputDecoration? decoration}) {
    return Container(
      color: Colors.transparent,
      height: 45,
      child: TextFormField(
        key: key,
        controller: controller,
        decoration: decoration,
        obscureText: true
      ),
    );
  }
}