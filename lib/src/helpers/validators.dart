// ignore_for_file:avoid_classes_with_only_static_members

import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';

class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  static bool isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  static String formatDate(DateTime date, Locale locale) {
    if (date == null || (date is! DateTime)) {
      throw TypeError();
    }
    return DateFormat.yMMMMd(locale.languageCode).format(date);
  }
}
