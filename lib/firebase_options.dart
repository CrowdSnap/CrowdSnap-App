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
      return web;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDwTxruuPQ4LEObxWhLfOLxLJcl071EUJc',
    appId: '1:971504465078:web:2f71ef78e500621ec02217',
    messagingSenderId: '971504465078',
    projectId: 'crowd-snap',
    authDomain: 'crowd-snap.firebaseapp.com',
    storageBucket: 'crowd-snap.appspot.com',
    measurementId: 'G-BKQ0502C3X',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBBrA6xyQMdfI9XtW8w_a3M5XYik5RJ8n0',
    appId: '1:971504465078:android:a66fb56cad4b9375c02217',
    messagingSenderId: '971504465078',
    projectId: 'crowd-snap',
    storageBucket: 'crowd-snap.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAA4h-gwhdR6r94TP8-_FnMC4V-CFvJmDg',
    appId: '1:971504465078:ios:1b41fa1efade655ac02217',
    messagingSenderId: '971504465078',
    projectId: 'crowd-snap',
    storageBucket: 'crowd-snap.appspot.com',
    iosBundleId: 'com.example.crowdSnap',
  );
}
