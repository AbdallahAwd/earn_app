import 'package:flutter/material.dart';

class DefTextformfield extends StatelessWidget {
  final String hintText;
  final Widget icon;
  final bool isObsecure;
  final TextEditingController controller;
  // ignore: prefer_typing_uninitialized_variables
  final validator;
  final ValueChanged<String>? onSubmit;
  const DefTextformfield(
      {Key? key,
      required this.hintText,
      required this.icon,
      required this.validator,
      this.onSubmit,
      required this.controller,
      this.isObsecure = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObsecure,
      decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xffD9D9D9),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide.none),
          prefixIcon: icon,
          hintText: hintText),
      validator: validator,
      onFieldSubmitted: onSubmit,
    );
  }
}
