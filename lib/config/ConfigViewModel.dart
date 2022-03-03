import 'package:flutter/material.dart';
import 'package:mega_sena/services/ConfigService.dart';

class ConfigViewModel {

  ConfigService configService;

  ConfigViewModel({ required this.configService });

  ThemeMode get currentTheme => configService.currentThemeValue;

  Stream<ThemeMode> get stream => configService.currentTheme.stream;

  List<ThemeMode> get items => configService.items;

  void changeTheme(ThemeMode theme) async {
    await configService.changeTheme(theme);
  }

}