import 'package:firebase_auth/firebase_auth.dart';
import 'login_method.dart';
import 'state/login_states.dart';

/// A class to manage the login process.
class LoginManager {
  /// The method used for logging in.
  final LoginMethod loginMethod;

  /// The state of the login process.
  final LoginState loginState;

  /// Constructs a [LoginManager] with the specified [loginMethod] and [loginState].
  LoginManager({required this.loginMethod, required this.loginState});

  /// Performs the login process.
  ///
  /// Uses the [loginMethod] to attempt a login and updates the [loginState]
  /// based on the outcome.
  ///
  /// Returns a [Future] that completes with a tuple containing:
  /// - [UserCredential?]: The credentials of the user if the login was successful, or `null` if it failed.
  /// - [dynamic]: The error if the login failed, or `null` if it succeeded.
  Future<(UserCredential?, dynamic)> login() async {
    // Attempt to log in using the specified login method
    (UserCredential?, dynamic) data = await loginMethod.login();

    // Check if there was an error during login
    if (data.$2.toString().isNotEmpty) {
      // If there was an error, update the login state with the error
      loginState.error(data.$2);
    } else {
      // If login was successful, update the login state with the user credentials
      loginState.success(data.$1!, data.$2);
    }

    // Return the login data (user credentials and error)
    return data;
  }
}
