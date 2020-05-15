class UserError implements Exception {
  factory UserError(String error) {
    switch (error) {
      case emailAlreadyInUse:
        return UserError._('An account with this email already exists.');
        break;
      case invalidEmail:
        return UserError._('The email provided is invalid.');
        break;
      case invalidName:
        return UserError._('The name provided is invalid.');
        break;
      case weakPassword:
        return UserError._('The password provided isn\'t strong enough.');
        break;
      default:
        return null;
    }
  }

  UserError._(this.message);

  final String message;

  static const String emailAlreadyInUse = 'ERROR_EMAIL_ALREADY_IN_USE';
  static const String invalidEmail = 'ERROR_INVALID_EMAIL';
  static const String invalidName = 'ERROR_INVALID_NAME';
  static const String weakPassword = 'ERROR_WEAK_PASSWORD';
}
