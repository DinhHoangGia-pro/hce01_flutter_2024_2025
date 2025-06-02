import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError('Unsupported platform');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyBYJVBy1wbcM0RxOvXLlZE1ESNAEYXuqRk",
      authDomain: "hce01-b7830.firebaseapp.com",
      projectId: "hce01-b7830",
      storageBucket: "hce01-b7830.firebasestorage.app",
      messagingSenderId: "400765339439",
      appId: "1:400765339439:web:def2ccbe392156c14f03da",
      measurementId: "G-VSXLXZBLSD");

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyBYJVBy1wbcM0RxOvXLlZE1ESNAEYXuqRk",
    appId: "1:400765339439:android:7b3834a7ce15421b4f03da",
    messagingSenderId: "400765339439",
    projectId: "hce01-b7830",
    storageBucket: "hce01-b7830.firebasestorage.app",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyBYJVBy1wbcM0RxOvXLlZE1ESNAEYXuqRk",
    appId: "1:400765339439:ios:placeholder_ios_app_id", // Cập nhật nếu cần
    messagingSenderId: "400765339439",
    projectId: "hce01-b7830",
    storageBucket: "hce01-b7830.firebasestorage.app",
    iosBundleId: "edu.hce01.ios", // Thay đổi nếu dùng iOS
  );
}
