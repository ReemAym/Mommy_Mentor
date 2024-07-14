import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button(
      {super.key,
      required this.text,
      required this.background_color,
      required this.text_color,
      required this.onTap});
  final String? text;
  final Color? background_color;
  final Color? text_color;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 50,
      // width: 200,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15), //shadow color
            spreadRadius: 1, //spread radius
            blurRadius: 5, // Larger blur radius forshadow
            offset: const Offset(0, 3), // shadow offset
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(background_color),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Set the border radius
            ),
          ),
        ),
        child: Text(
          text!,
          style: TextStyle(fontSize: 23, color: text_color),
        ),
      ),
    );
  }
}
