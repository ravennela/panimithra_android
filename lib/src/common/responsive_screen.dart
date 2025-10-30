import 'package:flutter/widgets.dart';

class MediaQueryHelper {
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

  static TextScaler textScaleFactor(BuildContext context) => MediaQuery.of(context).textScaler;

  static bool isSmallScreen(BuildContext context) => screenWidth(context) < 600;
  static bool isMediumScreen(BuildContext context) => screenWidth(context) >= 600 && screenWidth(context) < 1024;
  static bool isLargeScreen(BuildContext context) => screenWidth(context) >= 1024;
}
