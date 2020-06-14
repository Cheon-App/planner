// Package imports:
import 'package:meta/meta.dart';

/// Returns a message if the name provided is empty
String validateName(String name) {
  if (name.isEmpty) return 'Name Required';
  return null;
}

/// Returns a message if the email is empty or is missing an @ symbol
String validateEmail(String email, {bool isRequired = true}) {
  if (isRequired && email.isEmpty) {
    return 'Email Required';
  } else if (isRequired == false && email.isEmpty) {
    return null;
  } else {
    if ('@'.allMatches(email).length != 1) return 'Invalid Email Address';
    if (email.split('@').length != 2 ||
        email.split('@')[0].isEmpty ||
        email.split('@')[1].isEmpty) return 'Invalid Email Address';
    return null;
  }
}

/// Returns a message if the password has less than 8 characters or is empty
String validatePassword(String password) {
  if (password.isEmpty) return 'Password Required';
  if (password.length < 8) return 'Password must be at least 8 characters long';
  return null;
}

/// Returns a message if the provided text is empty
String validateEmpty({@required String name, @required String text}) {
  if (text.isEmpty) return '$name Required';
  return null;
}
