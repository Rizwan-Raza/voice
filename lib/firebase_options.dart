// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCar5OGH_6kHHDbOVO-MuXLQnTCP3V_hIs',
    appId: '1:255193871076:android:0f9a06560ff6dc6f0132f1',
    messagingSenderId: '255193871076',
    projectId: 'voice-prescription-1293c',
    storageBucket: 'voice-prescription-1293c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBx7ZWxHmfL6QnWEWkwrmq0o_MaH2VMtxI',
    appId: '1:255193871076:ios:d0108d1aecb93e5f0132f1',
    messagingSenderId: '255193871076',
    projectId: 'voice-prescription-1293c',
    storageBucket: 'voice-prescription-1293c.appspot.com',
    androidClientId: '255193871076-j5j9ggt2j2s09461d2aiokmis2t9ap2g.apps.googleusercontent.com',
    iosClientId: '255193871076-1f53b8ad0p1j16funlacoa47391uoujn.apps.googleusercontent.com',
    iosBundleId: 'com.example.voice',
  );
}
