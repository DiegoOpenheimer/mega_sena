import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mega_sena/home/HomeWidget.dart';
import 'package:mega_sena/services/ConfigService.dart';
import 'package:mega_sena/shared/theme/AppTheme.dart';

Future<void> init() async {
  await ConfigService().loadThemeFromDb();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await init();
  runApp(MegaSenaApp());
}

class MegaSenaApp extends StatelessWidget {
  final ConfigService _configService = ConfigService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _configService.currentTheme.stream,
      builder: (context, _) {
        return buildMaterialApp(context);
      },
    );
  }

  MaterialApp buildMaterialApp(BuildContext context) {
    return MaterialApp(
        title: 'Mega sena',
        darkTheme: AppTheme.dark,
        themeMode: _configService.currentThemeValue,
        theme: AppTheme.light(context),
        routes: <String, WidgetBuilder>{'/': (context) => HomeWidget()});
  }
}
