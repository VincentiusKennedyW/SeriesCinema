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
    apiKey: 'AIzaSyAmFOimFMcl6aUb7Ay4fuLLbUZyd4DInVw',
    appId: '1:665853452644:web:31ffed8e0c658fc77cda71',
    messagingSenderId: '665853452644',
    projectId: 'ditonton-e2b69',
    authDomain: 'ditonton-e2b69.firebaseapp.com',
    storageBucket: 'ditonton-e2b69.appspot.com',
    measurementId: 'G-DWZDJJJ7QY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD4jCYJU0a-7lMGjF9E4SJ2htqJqDpg10Y',
    appId: '1:665853452644:android:66a5eae3908befa47cda71',
    messagingSenderId: '665853452644',
    projectId: 'ditonton-e2b69',
    storageBucket: 'ditonton-e2b69.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD35wuFIJM5DyDZfh-r4ni5OvR7m4RB9XY',
    appId: '1:665853452644:ios:87a47767f762489a7cda71',
    messagingSenderId: '665853452644',
    projectId: 'ditonton-e2b69',
    storageBucket: 'ditonton-e2b69.appspot.com',
    iosBundleId: 'com.dicoding.ditonton',
  );
}