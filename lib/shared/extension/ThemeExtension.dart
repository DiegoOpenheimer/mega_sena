import 'package:flutter/material.dart';

extension ThemeModeExtension on ThemeMode {
  static Map<ThemeMode, String> values = {
    ThemeMode.system: 'Sistema',
    ThemeMode.dark: 'Escuro',
    ThemeMode.light: 'Claro',
  };

  String get name => ThemeModeExtension.values[this] ?? ThemeMode.system.name;

  static ThemeMode getFromName(String? name) {
    switch (name?.toLowerCase()) {
      case 'escuro':
        return ThemeMode.dark;
      case 'claro':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }
}