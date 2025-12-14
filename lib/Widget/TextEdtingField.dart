import 'package:doctor_apps/Theme/Theme.dart';
import 'package:flutter/material.dart';

class TextEditingField extends StatelessWidget {
  String title;
  String hintText;
  TextEditingController? controller;
  Icon icon;

  TextEditingField({
    super.key,
    required this.title,
    this.controller,
    required this.icon,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        fillColor: LightTheme.backgroundColors,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(14),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        labelText: title,
        hintText: hintText,
        hintStyle: TextStyle(color: LightTheme.subTitleColors),
        prefixIcon: icon,
      ),
    );
  }
}
