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
    apiKey: 'AIzaSyDyY2BiG2q8LbMuS_TXwn16q-7UsP2Iy4Y',
    appId: '1:647259899313:web:9b6261981055df5a032990',
    messagingSenderId: '647259899313',
    projectId: 'moapp-final-864fc',
    authDomain: 'moapp-final-864fc.firebaseapp.com',
    storageBucket: 'moapp-final-864fc.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBdUvacDUhEDM5t7iYQT8qzNmf1QMgdKZg',
    appId: '1:647259899313:android:f7598542638541f4032990',
    messagingSenderId: '647259899313',
    projectId: 'moapp-final-864fc',
    storageBucket: 'moapp-final-864fc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBjOcO7uUT6PeXiiB27S3yAzOLQ_igVFXQ',
    appId: '1:647259899313:ios:5a76a6212654b116032990',
    messagingSenderId: '647259899313',
    projectId: 'moapp-final-864fc',
    storageBucket: 'moapp-final-864fc.appspot.com',
    androidClientId: '647259899313-flt355mktm79dabt5p5dgh6hr83vn992.apps.googleusercontent.com',
    iosClientId: '647259899313-uac24csi12rujj669td58880uf2m4hsq.apps.googleusercontent.com',
    iosBundleId: 'com.example.mdc100Series',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBjOcO7uUT6PeXiiB27S3yAzOLQ_igVFXQ',
    appId: '1:647259899313:ios:5a76a6212654b116032990',
    messagingSenderId: '647259899313',
    projectId: 'moapp-final-864fc',
    storageBucket: 'moapp-final-864fc.appspot.com',
    androidClientId: '647259899313-flt355mktm79dabt5p5dgh6hr83vn992.apps.googleusercontent.com',
    iosClientId: '647259899313-uac24csi12rujj669td58880uf2m4hsq.apps.googleusercontent.com',
    iosBundleId: 'com.example.mdc100Series',
  );
}
