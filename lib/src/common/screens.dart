import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'; // To check for the platform (web vs mobile)

class Screens {
  // Get screen height
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Get status bar height
  static double statusbarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  // Get screen width
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Check if it's a mobile device (e.g., width is less than 728)
  static bool isMobile(BuildContext context) {
    if (kIsWeb) {
      // For web, consider larger breakpoints (tablet vs. desktop)
      return MediaQuery.of(context).size.width < 1024.0; // Example breakpoint for web
    } else {
      // For mobile, use the same breakpoint for mobile devices
      return MediaQuery.of(context).size.width < 728.0;
    }
  }

  // Check if it's portrait orientation
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  // Check if it's landscape orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // Hide system bars (only works for mobile)
  static void hideSystemBars() {
    if (!kIsWeb) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    }
  }

  // Show system bars (only works for mobile)
  static void showSystemBars() {
    if (!kIsWeb) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    }
  }

  // Calculate logo size based on orientation (adjust for web and mobile)
  static double logoSize(BuildContext context) {
    if (Screens.isPortrait(context)) {
      return Screens.height(context) * 0.05;
    } else {
      return Screens.width(context) * 0.05;
    }
  }

  // Set orientation to portrait (works on mobile)
  static void setPortrait() {
    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
      );
    }
  }

  // Set orientation to landscape (works on mobile)
  static void setLandscape() {
    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
      );
    }
  }

  // Reset orientation to default (works on mobile)
  static void resetOrientation() {
    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations([]);
    }
  }
}
