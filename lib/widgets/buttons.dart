import 'package:flutter/material.dart';

class AppButtonStyles {
  static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFD4E157),
    foregroundColor: Colors.black,
    textStyle: const TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Roboto', // Font ailesi
    ),
    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
  );
  // Belirli Buton Özellikleri
  static final Color buttonColor = Color(0xFFD4E157);
  static final double elevation = 6.0;
  static final BorderRadiusGeometry shape = BorderRadius.circular(12.0);
}
