import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:nexever_social_auth/social_login_functions/app_logs.dart';
import '../login_method.dart';
import '../model/facebook.dart';

/// A class that implements [LoginMethod] to handle Facebook login.
class FaceBookLogin extends LoginMethod {
  /// Signs in with Facebook and returns a [Future] containing a tuple.
  ///
  /// The tuple contains:
  /// - [UserCredential?]: The credentials of the user if the login was successful, or `null` if it failed.
  /// - [dynamic]: The error if the login failed, or an empty string if it succeeded.
  Future<(UserCredential?, dynamic)> signInWithFaceBook() async {
    var facebookAuth = FacebookAuth.instance;
    var firebaseAuth = FirebaseAuth.instance;
    try {
      await facebookAuth.logOut();
      final LoginResult result = await facebookAuth.login();
      var credential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      var res = await firebaseAuth.signInWithCredential(credential);
      var details = await getFacebookAccountDetails(result.accessToken!.token);
      res.user!.updatePhotoURL(details.picture!.data!.url ?? '');
      return (res, "");
    } catch (e, st) {
      logError(error: e.toString(), stackTrace: st, text: 'FACEBOOK Login');
      return (null, "Something went wrong");
    }
  }

  /// Fetches Facebook account details using the provided access token.
  ///
  /// Returns a [Future] containing [FacebookAccountData].
  ///
  /// Throws an error if fetching the account details fails.
  Future<FacebookAccountData> getFacebookAccountDetails(
      String accessToken) async {
    try {
      var response = await http.get(
        Uri.parse(
            "https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=$accessToken"),
      );
      return FacebookAccountData.fromJson(jsonDecode(response.body));
    } on TimeoutException catch (e, st) {
      throw 'Time out';
    } catch (e, st) {
      logError(
          error: e.toString(), stackTrace: st, text: 'FACEBOOK Account Login');
      rethrow;
    }
  }

  /// Implements the [login] method from [LoginMethod].
  ///
  /// Calls [signInWithFaceBook] to handle the Facebook login process.
  @override
  Future<(UserCredential?, dynamic)> login() async {
    return await signInWithFaceBook();
  }
}
