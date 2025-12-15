import 'package:doctor_apps/Theme/Theme.dart';
import 'package:flutter/material.dart';

class TextEditingField extends StatelessWidget {
  final String title;
  final String hintText;
  final Icon icon;
  final TextEditingController? controller;
  final bool obscureText;
  final FormFieldValidator<String>? validator;

  const TextEditingField({
    super.key,
    required this.title,
    required this.icon,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        fillColor: LightTheme.backgroundColors,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(14),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: LightTheme.primaryColors, width: 2),
        ),
        labelText: title,
        hintText: hintText,
        hintStyle: TextStyle(color: LightTheme.subTitleColors),
        prefixIcon: icon,
      ),
    );
  }
}
