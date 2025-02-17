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
    apiKey: 'AIzaSyCWXaafeJ_4dOKzwJFm86RTqmaeQnxjp7w',
    appId: '1:1078887520426:web:a3cf07e2ed143e496bd8d3',
    messagingSenderId: '1078887520426',
    projectId: 'carhub-d3ca7',
    authDomain: 'carhub-d3ca7.firebaseapp.com',
    storageBucket: 'carhub-d3ca7.appspot.com',
    measurementId: 'G-LELHJY9Z95',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB_xX9aifSOvOIJeUgYOTqp7LJgav0AkuU',
    appId: '1:1078887520426:android:882af3f638c8c9576bd8d3',
    messagingSenderId: '1078887520426',
    projectId: 'carhub-d3ca7',
    //storageBucket: 'carhub-d3ca7.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAU_uh1y4YrY-HAXipCNpuHeT6HKnv8pwY',
    appId: '1:1078887520426:ios:02469e0617397db16bd8d3',
    messagingSenderId: '1078887520426',
    projectId: 'carhub-d3ca7',
    storageBucket: 'carhub-d3ca7.appspot.com',
    iosBundleId: 'com.example.carHub',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAU_uh1y4YrY-HAXipCNpuHeT6HKnv8pwY',
    appId: '1:1078887520426:ios:02469e0617397db16bd8d3',
    messagingSenderId: '1078887520426',
    projectId: 'carhub-d3ca7',
    storageBucket: 'carhub-d3ca7.appspot.com',
    iosBundleId: 'com.example.carHub',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCWXaafeJ_4dOKzwJFm86RTqmaeQnxjp7w',
    appId: '1:1078887520426:web:dff4958a97d92db26bd8d3',
    messagingSenderId: '1078887520426',
    projectId: 'carhub-d3ca7',
    authDomain: 'carhub-d3ca7.firebaseapp.com',
    storageBucket: 'carhub-d3ca7.appspot.com',
    measurementId: 'G-5JLZ5WDC51',
  );
}
