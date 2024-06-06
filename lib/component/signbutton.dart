import 'package:flutter/material.dart';

class SignButton extends StatelessWidget {
  final Function()? onTap;
  final validator;

  const SignButton({super.key, required this.onTap, this.validator});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        margin: const EdgeInsets.symmetric(horizontal: 120),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 94, 39, 176),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            "Giriş Yap",
            style: TextStyle(
              color: Colors.grey[400],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
