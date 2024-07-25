library nexever_social_auth;

import 'package:firebase_auth/firebase_auth.dart';
export 'package:firebase_auth/firebase_auth.dart';
import 'package:nexever_social_auth/social_login_functions/login_method.dart';
import 'package:nexever_social_auth/social_login_functions/state/login_states.dart';

class LoginManager {
  final LoginMethod loginMethod;
  final LoginState loginState;
  LoginManager({required this.loginMethod, required this.loginState});

  Future<(UserCredential?, dynamic)> login() async {
    (UserCredential?, dynamic) data = await loginMethod.login();
    if (data.$2.toString().isNotEmpty) {
      loginState.error(data.$2);
    } else {
      loginState.success(data.$1!, data.$2);
    }
    return data;
  }
}
