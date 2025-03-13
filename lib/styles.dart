import 'package:flutter/material.dart';

class AppStyles {
  ///
  static const TextStyle heading =
      TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static const TextStyle bodyText = TextStyle(fontSize: 16);
  static final ButtonStyle elevatedButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), // Optional: rounded corners
    ),
  );

  /// TextInput decoration
  static InputDecoration textFieldDecoration(String hintText) {
    return InputDecoration(
      filled: true,
      fillColor: const Color.fromARGB(255, 30, 30, 30),
      contentPadding: EdgeInsets.all(15),
      hintText: hintText,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        borderSide: BorderSide(color: Colors.blue),
      ),
    );
  }

  static ThemeData darkModeTheme() {
    return ThemeData(
      scaffoldBackgroundColor: const Color.fromARGB(255, 18, 18, 18),
      brightness: Brightness.dark,
    );
  }
}
