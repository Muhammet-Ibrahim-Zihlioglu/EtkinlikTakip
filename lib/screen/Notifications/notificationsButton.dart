import 'package:flutter/material.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton(
      {super.key, required this.onPressed, required this.text});
  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 30),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: ElevatedButton(
            child: Text(text),
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                shadowColor: Colors.grey.shade300,
                backgroundColor: Colors.amber)),
      ),
    );
  }
}
