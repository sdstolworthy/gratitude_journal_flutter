import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData gratefulTheme(ThemeData appTheme) {
  final ThemeData theme = ThemeData(brightness: Brightness.light);

  final Color primaryColor = Colors.blue[900];
  final Color accentColor = Colors.blue[600];
  final Color errorColor = Colors.deepOrange[800];
  final Color secondaryColor = Colors.lightBlue[900];
  final MaterialColor primarySwatch = Colors.blue;

  final ColorScheme colorScheme = ColorScheme.fromSwatch(
      backgroundColor: primaryColor,
      accentColor: accentColor,
      brightness: Brightness.light,
      cardColor: secondaryColor,
      errorColor: errorColor,
      primarySwatch: primarySwatch);

  return theme
      .copyWith(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: colorScheme.secondaryVariant),
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: colorScheme.onBackground),
            color: primaryColor),
        backgroundColor: primaryColor,
        cardTheme: CardTheme(color: primaryColor, elevation: 2.0),
        buttonColor: accentColor,
        buttonTheme: ButtonThemeData(
          buttonColor: accentColor,
          textTheme: ButtonTextTheme.primary,
        ),
        colorScheme: colorScheme,
        canvasColor: secondaryColor,
        inputDecorationTheme: appTheme.inputDecorationTheme.copyWith(
            labelStyle:
                TextStyle(color: Colors.white70, fontFamily: 'Raleway')),
        primaryColorLight: colorScheme.onBackground,
        iconTheme: IconThemeData(color: Colors.white70),
        primaryTextTheme: TextTheme(
            button: appTheme.primaryTextTheme.button
                .copyWith(fontFamily: 'Raleway'),
            body1: GoogleFonts.montserrat()
                .copyWith(color: colorScheme.onBackground, fontSize: 16),
            body2: appTheme.primaryTextTheme.body1
                .copyWith(color: colorScheme.onBackground, fontSize: 20),
            headline: GoogleFonts.merriweather()
                .copyWith(color: colorScheme.onBackground, fontSize: 40),
            subhead: GoogleFonts.merriweatherSans()
                .copyWith(fontStyle: FontStyle.italic, fontSize: 18),
            title: appTheme.primaryTextTheme.title
                .apply(fontFamily: 'MontSerratRegular'),
            display1: appTheme.primaryTextTheme.display1
                .copyWith(fontFamily: 'MontserratRegular')),
      )
      .copyWith(
        accentTextTheme: appTheme.accentTextTheme.copyWith(
            headline: GoogleFonts.merriweatherSans().copyWith(
              color: Colors.black,
            ),
            body1: GoogleFonts.montserrat()
                .copyWith(color: Colors.black, fontSize: 16)),
      );
}
