import 'dart:convert';

import 'package:grateful/src/models/preferences/user_preference.dart';

class UserLanguageSettings extends UserPreference {
  final String locale;
  UserLanguageSettings({
    this.locale,
  });

  UserLanguageSettings copyWith({
    String locale,
  }) {
    return UserLanguageSettings(
      locale: locale ?? this.locale,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'locale': locale,
    };
  }

  static UserLanguageSettings fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserLanguageSettings(
      locale: map['locale'],
    );
  }

  String toJson() => json.encode(toMap());

  static UserLanguageSettings fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() => 'UserLanguageSettings locale: $locale';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UserLanguageSettings && o.locale == locale;
  }

  @override
  int get hashCode => locale.hashCode;
}
