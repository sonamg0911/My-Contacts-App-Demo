import 'package:flutter/material.dart';

class Alerts {
  static showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
