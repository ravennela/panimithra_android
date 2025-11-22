import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (Platform.isIOS) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyAhdFHGu2gOsL3AfkzGMCMpWgRbscs1TL8',
        appId:
            "1:638972832538:ios:49160d22a05cb812505aa3", //1:638972832538:ios:49160d22a05cb812505aa3
        messagingSenderId: "638972832538",
        projectId: "metro-india",
      );
    } else {
      return const FirebaseOptions(
        apiKey: 'AIzaSyDaE2KbbRxQqAX9tmVCmJXAzjzQv_Jh560',
        // from "api_key" → "current_key"
        appId:
            '1:564205773146:android:58f63b95aae2fe70acd363', //1:638972832538:android:a21dfaf3959700cf505aa3
        // from "mobilesdk_app_id" for your package
        messagingSenderId: '564205773146',
        // same as "project_info.project_number"
        projectId: 'panimithra-e575e',
        // "project_info.project_id"
        storageBucket: 'panimithra-e575e.firebasestorage.app',
      );
    }
  }
}
