import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final validator;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade600),
                borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: Color.fromARGB(255, 33, 25, 184),
                ),
                borderRadius: BorderRadius.circular(30)),
            fillColor: Colors.grey.shade300,
            filled: true,
            hintText: hintText,
            hintStyle:
                TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
          ),
        ),
      ),
    );
  }
}
