import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nexever_social_auth/social_login_functions/app_logs.dart';
import '../login_method.dart';

/// A class that implements [LoginMethod] to handle Google login.
class GoogleLogin extends LoginMethod {
  /// An instance of [FirebaseAuth] to handle authentication with Firebase.
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  /// Signs in with Google and returns a [Future] containing a tuple.
  ///
  /// The tuple contains:
  /// - [UserCredential?]: The credentials of the user if the login was successful, or `null` if it failed.
  /// - [dynamic]: The error if the login failed, or an empty string if it succeeded.
  Future<(UserCredential?, dynamic)> signInWithGoogle() async {
    try {
      var data = await googleAccountCall();
      var res = await firebaseDataCall(data.$1, data.$2);
      return (res, "");
    } catch (error, st) {
      logError(error: error.toString(), stackTrace: st, text: 'Google Login');
      return (null, error);
    }
  }

  /// Calls Google sign-in and returns a [Future] containing a tuple.
  ///
  /// The tuple contains:
  /// - [AuthCredential]: The authentication credentials.
  /// - [GoogleSignInAccount]: The Google account information.
  ///
  /// Throws an error if unable to connect with Google.
  ///


  List<String> scopes = <String>[
    'https://www.googleapis.com/auth/contacts.readonly',
  ];


  final _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleSignInInitialized = false;

  Future<void> _initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize();
      _isGoogleSignInInitialized = true;
    } catch (e) {
      print('Failed to initialize Google Sign-In: $e');
    }
  }

  /// Always check Google sign in initialization before use
  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isGoogleSignInInitialized) {
      await _initializeGoogleSignIn();
    }
  }

  Future<(AuthCredential, GoogleSignInAccount)> googleAccountCall() async {
    try {
      await _ensureGoogleSignInInitialized();
      // FIXED: Call authenticate() only once with scopes included
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: scopes,
      );
      // FIXED: Added missing await
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // FIXED: Return the same googleUser instance (no second authenticate call)
      return (credential, googleUser);

    } on GoogleSignInException catch (e) {
      print('Google Sign In error:\n$e');
      throw "Something went wrong or may be google auth setup pending.";
    } catch (error) {
      print('Unexpected Google Sign-In error: $error');
      throw "Something went wrong";
    }
  }


  /// Calls Firebase to sign in with the provided credentials and returns a [Future] containing [UserCredential].
  ///
  /// Updates the user's display name, email, and photo URL with the Google account information.
  ///
  /// Throws an error if something goes wrong during the Firebase sign-in.
  Future<UserCredential> firebaseDataCall(
      AuthCredential credential, GoogleSignInAccount googleUser) async {
    try {
      var _res = await firebaseAuth.signInWithCredential(credential);
      _res.user?.updateDisplayName(googleUser.displayName ?? '');
      _res.user?.verifyBeforeUpdateEmail(googleUser.email ?? "");
      _res.user?.updatePhotoURL(googleUser.photoUrl ?? "");
      if (_res.user?.email == null) {
        var _res = await firebaseAuth.signInWithCredential(credential);
        _res.user?.verifyBeforeUpdateEmail(googleUser.email ?? "");
      }
      return _res;
    } catch (error, st) {
      logError(error: error.toString(), stackTrace: st, text: 'Google Login');
      throw "Something went wrong";
    }
  }

  /// Implements the [login] method from [LoginMethod].
  ///
  /// Calls [signInWithGoogle] to handle the Google login process.
  @override
  Future<(UserCredential?, dynamic)> login() async {
    return await signInWithGoogle();
  }
}
