import 'package:flutter/material.dart';

class SavedButton extends StatelessWidget {
  final Function()? onTap;

  const SavedButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        margin: const EdgeInsets.symmetric(horizontal: 120),
        decoration: BoxDecoration(
          color: Color.fromARGB(230, 19, 10, 113),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            "Kaydet",
            style: TextStyle(
              color: Color.fromARGB(255, 194, 213, 207),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
