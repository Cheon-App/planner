// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import '../test_utils.dart';
import 'package:cheon/validators.dart';

void main() {
  group('validators.dart |', () {
    test('validateName() only returns a message if the name is invalid', () {
      const String name = 'name';

      // tests with a valid name
      expect(validateName(name), isNull);
      // tests with an empty string
      expect(validateName(emptyString), isNotNull);
    });

    test('validateEmail() only returns a message if the email is invalid', () {
      const String validEmail = '##@##';
      const String missingAt = '##';
      const String missingBefore = '@#';
      const String missingAfter = '#@';

      // tests with a valid email
      expect(validateEmail(validEmail), isNull);
      // tests with an empty string
      expect(validateEmail(emptyString), isNotNull);
      // tests with an email missing the @ symbol
      expect(validateEmail(missingAt), isNotNull);
      // tests with an email missing text before the @ symbol
      expect(validateEmail(missingBefore), isNotNull);
      // tests with an email missing text after the @ symbol
      expect(validateEmail(missingAfter), isNotNull);
    });

    test('validatePassword() only returns a message if the password is invalid',
        () {
      const String validPassword = '1-3-5-7-';
      const String tooShort = '1-3-5-7';

      // tests with a valid password
      expect(validatePassword(validPassword), isNull);
      // tests with a password with less than 8 characters
      expect(validatePassword(tooShort), isNotNull);
      // tests with an empty password
      expect(validatePassword(emptyString), isNotNull);
    });

    test('validateEmpty() only returns a message if the text is empty', () {
      const String validText = 'not_empty';

      // tests with valid text
      expect(validateEmpty(text: validText, name: 'name'), isNull);
      // tests with an empty string
      expect(validateEmpty(text: emptyString, name: 'name'), isNotNull);
    });
  });
}
