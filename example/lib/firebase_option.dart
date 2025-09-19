import 'package:firebase_core/firebase_core.dart';
import 'dart:io' show Platform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (Platform.isAndroid) {
      return android;
    } else if (Platform.isIOS) {
      return ios;
    } else {
      throw UnsupportedError(
        'DefaultFirebaseOptions are not supported for this platform.',
      );
    }
  }

  // ✅ Android values from google-services.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyA46***************6Rs",
    appId: "1:548****************60c0cf3e",
    messagingSenderId: "548***7707",
    projectId: "nex-all-plugin",
    storageBucket: "nex-all-plug*****torage.app",
    databaseURL: "https://nex-all-p******ebaseio.com",
  );

  // ✅ iOS values (you’ll get them from GoogleService-Info.plist)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIza*******************Q5CdXp7g",
    appId: "1:5487368877**************18c0cf3e",
    messagingSenderId: "548*****707",
    projectId: "nex-all-plugin",
    storageBucket: "nex-all-********orage.app",
    iosClientId: "548736887707-ampdos*********leusercontent.com",
    iosBundleId: "com.example.example", // change to your iOS bundle id
    databaseURL: "https://nex-all-pl********ebaseio.com",
  );
}
