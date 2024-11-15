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
        return windows;
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
    apiKey: 'AIzaSyDWhasbi2cb3RjsU3X_u9PvCNXfhgq8Xek',
    appId: '1:923581115363:web:f7344a66fa3c13b5a6ced6',
    messagingSenderId: '923581115363',
    projectId: 'projetclothes-96047',
    authDomain: 'projetclothes-96047.firebaseapp.com',
    storageBucket: 'projetclothes-96047.appspot.com',
    measurementId: 'G-4R02KBJR5L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyADmtcDXskcDuWP1HsXRyHqCxj_67K7ec0',
    appId: '1:923581115363:android:9a6f01d26453b3f8a6ced6',
    messagingSenderId: '923581115363',
    projectId: 'projetclothes-96047',
    storageBucket: 'projetclothes-96047.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAUaB-er6vwU0vfPX_oAzJymokzt5_RLbw',
    appId: '1:923581115363:ios:082545d16f622f4ca6ced6',
    messagingSenderId: '923581115363',
    projectId: 'projetclothes-96047',
    storageBucket: 'projetclothes-96047.appspot.com',
    iosBundleId: 'com.example.projetClothes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAUaB-er6vwU0vfPX_oAzJymokzt5_RLbw',
    appId: '1:923581115363:ios:082545d16f622f4ca6ced6',
    messagingSenderId: '923581115363',
    projectId: 'projetclothes-96047',
    storageBucket: 'projetclothes-96047.appspot.com',
    iosBundleId: 'com.example.projetClothes',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDWhasbi2cb3RjsU3X_u9PvCNXfhgq8Xek',
    appId: '1:923581115363:web:7bdc33a22cf1b346a6ced6',
    messagingSenderId: '923581115363',
    projectId: 'projetclothes-96047',
    authDomain: 'projetclothes-96047.firebaseapp.com',
    storageBucket: 'projetclothes-96047.appspot.com',
    measurementId: 'G-VWFJ2VH9H8',
  );

}