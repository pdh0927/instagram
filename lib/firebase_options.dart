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
    apiKey: 'AIzaSyCvpklFkBiW9ooKro5MguF5ZDjFCkWZ1G4',
    appId: '1:464379158612:web:25dffc20d59ba0e0980dc1',
    messagingSenderId: '464379158612',
    projectId: 'fluttergram-cbcb0',
    authDomain: 'fluttergram-cbcb0.firebaseapp.com',
    storageBucket: 'fluttergram-cbcb0.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAt4aPZwx0slq-KQI07omzFHHYXnSqaCuY',
    appId: '1:464379158612:android:e47d7aa00244ffe1980dc1',
    messagingSenderId: '464379158612',
    projectId: 'fluttergram-cbcb0',
    storageBucket: 'fluttergram-cbcb0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDNzRD5tXOy1kgIOV8YXV9T12UeCxlDCI8',
    appId: '1:464379158612:ios:2e2199cae5e21793980dc1',
    messagingSenderId: '464379158612',
    projectId: 'fluttergram-cbcb0',
    storageBucket: 'fluttergram-cbcb0.appspot.com',
    iosClientId: '464379158612-2mo51g783tn9tki7firfiatgdjur98dh.apps.googleusercontent.com',
    iosBundleId: 'com.dh.instagram',
  );
}
