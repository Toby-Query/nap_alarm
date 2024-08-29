import 'package:flutter/material.dart';

Widget topRow(Size size, String text, bool isActive) {
  return Container(
    padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.02, vertical: size.height * 0.008),
    margin: EdgeInsets.symmetric(
      horizontal: size.width * 0.01,
      vertical: size.height * 0.007,
    ),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: isActive
            ? [Colors.purple, Colors.red]
            : [const Color(0xFF2d2f41), const Color(0xFF2d2f41)],
        // begin: Alignment.centerLeft,
        // end: Alignment.centerRight,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        //fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
  );
}
