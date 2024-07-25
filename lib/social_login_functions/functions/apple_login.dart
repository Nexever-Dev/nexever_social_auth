import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexever_social_auth/social_login_functions/app_logs.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../login_method.dart';

/// A class that implements [LoginMethod] to handle Apple login.
class AppleLogin extends LoginMethod {
  /// Signs in with Apple and returns a [Future] containing a tuple.
  ///
  /// The tuple contains:
  /// - [UserCredential?]: The credentials of the user if the login was successful, or `null` if it failed.
  /// - [dynamic]: The error if the login failed, or an empty string if it succeeded.
  Future<(UserCredential?, dynamic)> signInWithApple() async {
    var firebaseAuth = FirebaseAuth.instance;
    try {
      var redirectURL =
          'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple';
      var clientID = 'de.lunaone.flutter.signinwithappleexample.service';
      final appleIdCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
              clientId: clientID, redirectUri: Uri.parse(redirectURL)));
      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: appleIdCredential.identityToken,
        accessToken: appleIdCredential.authorizationCode,
      );
      var res = await firebaseAuth.signInWithCredential(credential);

      return (res, "");
    } catch (e, st) {
      logError(error: e.toString(), stackTrace: st, text: 'APPLE Login');
      return (null, "Something went wrong");
    }
  }

  /// Implements the [login] method from [LoginMethod].
  ///
  /// Calls [signInWithApple] to handle the Apple login process.
  @override
  Future<(UserCredential?, dynamic)> login() async {
    return await signInWithApple();
  }
}
