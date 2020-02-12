import 'package:faker/faker.dart';
import 'package:flutter/widgets.dart';

class User {
  User(
      {@required this.firstName,
      @required this.lastName,
      @required this.email,
      @required this.photoUrl});

  User.fromJson(Map<String, dynamic> parsedJson)
      : firstName = parsedJson['firstName'] as String,
        lastName = parsedJson['lastName'] as String,
        email = parsedJson['email'] as String,
        photoUrl = parsedJson['photoUrl'] as String;

  User.random()
      : firstName = faker.person.firstName(),
        lastName = faker.person.lastName(),
        email = faker.internet.email(),
        photoUrl = 'https://via.placeholder.com/70';

  final String email;
  final String firstName;
  final String lastName;
  final String photoUrl;

  String get fullName {
    return '$firstName $lastName';
  }
}
