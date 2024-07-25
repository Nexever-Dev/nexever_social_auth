
A Flutter plugin for integrating social login functionalities into your app.

## Features

- **Google Sign-In**: Enable users to log in using their Google accounts.
- **Facebook Login**: Allow users to authenticate with their Facebook credentials.
- **Apple Sign-In**: Provide a seamless sign-in experience for Apple users.

## Getting started

### Prerequisites
- Dart
- Flutter

### Installation
Add the following dependency to your pubspec.yaml file:

```yaml
dependencies:
  nex_common_logs: <latest-version>
```

## Usage

```dart
import 'package:nexever_social_auth/nexever_social_auth.dart';
import 'package:nexever_social_auth/social_login_functions/functions/apple_login.dart';
import 'package:nexever_social_auth/social_login_functions/functions/facebook_login.dart';
import 'package:nexever_social_auth/social_login_functions/functions/google_login.dart';
import 'package:nexever_social_auth/social_login_functions/state/login_states.dart';

class Authcontroller implements LoginState{
  @override
  void error(error) {
    // TODO: implement error
  }

  @override
  void success(UserCredential creds, String loginType) {
    // TODO: implement success
  }

  googleLogin(){
    LoginManager(loginMethod:GoogleLogin() , loginState:this );
  }
  faceBookLogin(){
    LoginManager(loginMethod:FaceBookLogin() , loginState:this );
  }
  appleLogin(){
    LoginManager(loginMethod:AppleLogin() , loginState:this );
  }

}

```

# nexever_social_auth
