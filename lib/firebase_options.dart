// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return macos;
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
    apiKey: 'AIzaSyCqtdSf5PFJ5VubRmBr7BqRMhQ7l3X9JX8',
    appId: '1:821070755382:web:a2b5c5514afa892eb00a97',
    messagingSenderId: '821070755382',
    projectId: 'flutter-habittracker',
    authDomain: 'flutter-habittracker.firebaseapp.com',
    storageBucket: 'flutter-habittracker.appspot.com',
    measurementId: 'G-Y3XRC2GEKN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCrcDp_e7fLmXU1qyCllw1nvS2NJ5Kwm1g',
    appId: '1:821070755382:android:97cc3e56d78d4947b00a97',
    messagingSenderId: '821070755382',
    projectId: 'flutter-habittracker',
    storageBucket: 'flutter-habittracker.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA6nbv7a0LEnJ5YkaLCYEUlPCrdHiDLJOE',
    appId: '1:821070755382:ios:4080bbf7faefd378b00a97',
    messagingSenderId: '821070755382',
    projectId: 'flutter-habittracker',
    storageBucket: 'flutter-habittracker.appspot.com',
    iosClientId: '821070755382-vimvcui85ivv9i32ss243ugmupolan7i.apps.googleusercontent.com',
    iosBundleId: 'com.example.habituo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA6nbv7a0LEnJ5YkaLCYEUlPCrdHiDLJOE',
    appId: '1:821070755382:ios:4080bbf7faefd378b00a97',
    messagingSenderId: '821070755382',
    projectId: 'flutter-habittracker',
    storageBucket: 'flutter-habittracker.appspot.com',
    iosClientId: '821070755382-vimvcui85ivv9i32ss243ugmupolan7i.apps.googleusercontent.com',
    iosBundleId: 'com.example.habituo',
  );

}