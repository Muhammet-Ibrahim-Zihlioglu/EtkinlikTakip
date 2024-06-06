import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final Function()? onTap;
  const RegisterButton({super.key, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: const Center(
          child: Text(
            "Kayıt Ol",
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Color.fromARGB(255, 94, 39, 176),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
