import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static TextTheme getTextThemeDark() {
    TextStyle style = TextStyle(color: Colors.white);
    return TextTheme(
      bodyText1: style,
      bodyText2: style,
      button: style,
      caption: style,
      headline1: style,
      headline2: style,
      headline3: style,
      headline4: style,
      headline5: style,
      headline6: style,
    );
  }

  static get dark => ThemeData.dark().copyWith(
        textTheme: GoogleFonts.ptSansTextTheme(getTextThemeDark()),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );

  static light(BuildContext context) => ThemeData(
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.ptSansTextTheme(),
        primaryTextTheme: TextTheme(
          headline6: TextStyle(color: Colors.black),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green),
          ),
        ),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          color: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        colorScheme: ColorScheme.light(
          secondary: Colors.lightGreen,
          primary: Colors.green,
        ),
        primaryColor: Colors.green,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.green[50],
          showUnselectedLabels: true,
        ),
        sliderTheme: SliderThemeData(
          overlayShape: SliderComponentShape.noOverlay
        )
      );
}
