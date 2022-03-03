import 'package:flutter/material.dart';

class Utils {
  static Color getColorAccordingTheme(BuildContext context,
      {Color toLightTheme = Colors.black, Color toDarkTheme = Colors.white}) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return toDarkTheme;
    }
    return toLightTheme;
  }
}
