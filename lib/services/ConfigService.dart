import 'package:flutter/material.dart';
import 'package:mega_sena/services/database/MegaSenaDB.dart';
import 'package:mega_sena/shared/extension/ThemeExtension.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sembast/sembast.dart';


class ConfigService {
  static const String THEME_KEY = '@mega_senha/theme';
  static final ConfigService _instance = ConfigService._internal();

  ConfigService._internal();

  factory ConfigService() => _instance;

  MegaSenaDB megaSenaDB = MegaSenaDB();
  StoreRef store = StoreRef.main();
  BehaviorSubject<ThemeMode> currentTheme =
      BehaviorSubject.seeded(ThemeMode.system);

  ThemeMode get currentThemeValue => currentTheme.value!;

  final List<ThemeMode> items = [
    ThemeMode.system,
    ThemeMode.dark,
    ThemeMode.light
  ];

  Future<ThemeMode> loadThemeFromDb() async {
    Database database = await megaSenaDB.open();
    String? value = await store.record(THEME_KEY).get(database) as String?;
    ThemeMode theme = ThemeModeExtension.getFromName(value);
    currentTheme.add(theme);
    return theme;
  }

  Future<void> changeTheme(ThemeMode theme) async {
    Database database = await megaSenaDB.open();
    await store.record(THEME_KEY).put(database, theme.name);
    currentTheme.add(theme);
  }

  void dispose() {
    currentTheme.close();
  }
}
