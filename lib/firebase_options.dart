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
    apiKey: 'AIzaSyA0KBROij8Lu-v6esI9eNn5jj40CNm0zUY',
    appId: '1:663054481134:web:d290b44f2038c3d32d25ff',
    messagingSenderId: '663054481134',
    projectId: 'gachaangpao',
    authDomain: 'gachaangpao.firebaseapp.com',
    storageBucket: 'gachaangpao.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC2uAEUYBqdwiQhfey_hehfoO4qXtmP75U',
    appId: '1:663054481134:android:95eabe519cbec7442d25ff',
    messagingSenderId: '663054481134',
    projectId: 'gachaangpao',
    storageBucket: 'gachaangpao.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBCkr4XnNtLckr0yxl1dy95fV6qfY3Fa08',
    appId: '1:663054481134:ios:9a6192637affa1bb2d25ff',
    messagingSenderId: '663054481134',
    projectId: 'gachaangpao',
    storageBucket: 'gachaangpao.appspot.com',
    iosBundleId: 'com.example.gachaangpao',
  );
}
