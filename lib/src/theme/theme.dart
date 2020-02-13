//ignore_for_file:avoid_classes_with_only_static_members

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColorScheme {
  AppColorScheme(this.identifier, this.colorScheme);

  final String identifier;
  final ColorScheme colorScheme;

  static AppColorScheme blueScheme = AppColorScheme(
      'blue',
      ColorScheme.fromSwatch(
          backgroundColor: Colors.blue[900],
          accentColor: Colors.blue[600],
          brightness: Brightness.light,
          cardColor: Colors.lightBlue[900],
          errorColor: Colors.deepOrange[800],
          primarySwatch: Colors.blue));

  static AppColorScheme yellowScheme = AppColorScheme(
      'yellow',
      ColorScheme.fromSwatch(
          backgroundColor: Colors.yellow[900],
          accentColor: Colors.yellow[600],
          brightness: Brightness.light,
          cardColor: Colors.amber[900],
          errorColor: Colors.deepOrange[800],
          primarySwatch: Colors.yellow));

  static AppColorScheme greenScheme = AppColorScheme(
      'green',
      ColorScheme.fromSwatch(
          backgroundColor: Colors.green[900],
          accentColor: Colors.green[600],
          brightness: Brightness.light,
          cardColor: Colors.lightGreen[900],
          errorColor: Colors.deepOrange[800],
          primarySwatch: Colors.green));

  static AppColorScheme brownScheme = AppColorScheme(
      'brown',
      ColorScheme.fromSwatch(
          backgroundColor: Colors.brown[900],
          accentColor: Colors.brown[600],
          brightness: Brightness.light,
          cardColor: Colors.brown[100],
          errorColor: Colors.deepOrange[800],
          primarySwatch: Colors.brown));

  static List<AppColorScheme> availableSchemes = <AppColorScheme>[
    blueScheme,
    yellowScheme,
    greenScheme,
    brownScheme
  ];
}

ThemeData gratefulTheme(ThemeData appTheme, {ColorScheme colorScheme}) {
  final ThemeData theme = ThemeData(brightness: Brightness.light);

  colorScheme ??= AppColorScheme.blueScheme.colorScheme;

  try {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: colorScheme.background));
  } catch (e) {
    print(e);
  }

  return theme
      .copyWith(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: colorScheme.secondaryVariant),
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: colorScheme.onBackground),
            color: colorScheme.background),
        backgroundColor: colorScheme.background,
        cardTheme: CardTheme(color: colorScheme.primary, elevation: 2.0),
        buttonColor: colorScheme.secondary,
        buttonTheme: ButtonThemeData(
          buttonColor: colorScheme.secondary,
          textTheme: ButtonTextTheme.primary,
        ),
        colorScheme: colorScheme,
        canvasColor: colorScheme.secondary,
        inputDecorationTheme: appTheme.inputDecorationTheme.copyWith(
            labelStyle:
                TextStyle(color: Colors.white70, fontFamily: 'Raleway')),
        primaryColorLight: colorScheme.onBackground,
        iconTheme: IconThemeData(color: colorScheme.onBackground.withOpacity(0.8)),
        primaryTextTheme: TextTheme(
            button: appTheme.primaryTextTheme.button
                .copyWith(fontFamily: 'Raleway'),
            body1: GoogleFonts.montserrat()
                .copyWith(color: colorScheme.onBackground, fontSize: 16),
            body2: appTheme.primaryTextTheme.body1
                .copyWith(color: colorScheme.onBackground, fontSize: 20),
            headline: GoogleFonts.merriweather()
                .copyWith(color: colorScheme.onBackground, fontSize: 40),
            subhead: GoogleFonts.merriweatherSans().copyWith(
                fontStyle: FontStyle.italic,
                fontSize: 18,
                color: colorScheme.onBackground),
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
