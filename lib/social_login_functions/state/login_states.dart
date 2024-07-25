import 'package:firebase_auth/firebase_auth.dart';

/// A class representing the state of a login operation.
class LoginState {
  /// Called when the login operation is successful.
  ///
  /// [creds] contains the user credentials obtained after a successful login.
  /// [loginType] is a string that specifies the type of login (e.g., "email", "google", "facebook").
  void success(UserCredential creds, String loginType) {}

  /// Called when the login operation fails.
  ///
  /// [error] contains the error information related to the failed login attempt.
  void error(var error) {}
}
