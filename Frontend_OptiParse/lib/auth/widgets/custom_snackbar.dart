import 'package:flutter/material.dart';

class CustomSnackBar {
  final String message;

  CustomSnackBar({required this.message});

  void show(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.black, // Default background color
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
