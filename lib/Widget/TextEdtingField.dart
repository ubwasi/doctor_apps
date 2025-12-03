import 'package:doctor_apps/Theme/Theme.dart';
import 'package:flutter/material.dart';
class TextEditingField extends StatelessWidget {
  String title;
  String hintText;
  Icon icon;
  TextEditingField({super.key,required this.title,required this.icon,required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        fillColor: LightTheme.backgroundColors,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(14)
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(14)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none
        ),
        labelText: title,
        hintText: hintText,
        hintStyle: TextStyle(color: LightTheme.subTitleColors),
        prefixIcon: icon
      ),
    );
  }
}
