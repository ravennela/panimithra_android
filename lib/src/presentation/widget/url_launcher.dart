
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  UrlLauncherHelper._(); // private constructor

  /// Launch any URL (http, https)
  static Future<void> launchWebUrl(
    String url, {
    required BuildContext context,
  }) async {
    final Uri uri = Uri.parse(url);

    if (!await canLaunchUrl(uri)) {
      _showError(context, 'Could not open the link');
      return;
    }

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  /// Launch phone dialer
  static Future<void> launchPhone(
    String phoneNumber, {
    required BuildContext context,
  }) async {
    final Uri uri = Uri.parse('tel:$phoneNumber');

    if (!await canLaunchUrl(uri)) {
      _showError(context, 'Could not open dialer');
      return;
    }

    await launchUrl(uri);
  }

  /// Launch email app
  static Future<void> launchEmail(
    String email, {
    String? subject,
    String? body,
    required BuildContext context,
  }) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    );

    if (!await canLaunchUrl(uri)) {
      _showError(context, 'Could not open email app');
      return;
    }

    await launchUrl(uri);
  }

  /// Launch Google Maps with coordinates
  static Future<void> launchMap(
    double latitude,
    double longitude, {
    required BuildContext context,
  }) async {
    final Uri uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    if (!await canLaunchUrl(uri)) {
      _showError(context, 'Could not open map');
      return;
    }

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  /// Private error handler
  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
