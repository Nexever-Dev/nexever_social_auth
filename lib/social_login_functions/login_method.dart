import 'package:firebase_auth/firebase_auth.dart';

/// An abstract class that defines a method for logging in.
abstract class LoginMethod {
 /// Attempts to log in and returns a [Future] containing a tuple.
 ///
 /// The tuple contains:
 /// - [UserCredential?]: The credentials of the user if the login was successful, or `null` if it failed.
 /// - [dynamic]: The error if the login failed, or `null` if it succeeded.
 Future<(UserCredential?, dynamic)> login();
}
