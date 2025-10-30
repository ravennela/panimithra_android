
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastHelper {
  static void showToast({
    required BuildContext context,
    required String type, // success, warning, error, info
    required String title,
    String? subtitle,
  }) {
    final toastStyles = {
      'success': {
        'icon': Icons.check_circle,
        'bgColor': Colors.green.shade100,
        'borderColor': Colors.green
      },
      'warning': {
        'icon': Icons.warning_amber_rounded,
        'bgColor': Colors.orange.shade100,
        'borderColor': Colors.orange
      },
      'error': {
        'icon': Icons.error_outline,
        'bgColor': Colors.red.shade100,
        'borderColor': Colors.red
      },
      'info': {
        'icon': Icons.info_outline,
        'bgColor': Colors.blue.shade100,
        'borderColor': Colors.blue
      },
    };

    if (!toastStyles.containsKey(type)) return;

    toastification.show(
      borderSide: BorderSide(
        strokeAlign: 2,
        color: toastStyles[type]!['borderColor'] as Color,
      ),
      context: context,
      // title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      // title: subtitle != null ? Text(subtitle,style: const TextStyle(fontWeight: FontWeight.bold)) : null,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      description: subtitle != null ? Text(subtitle) : null,
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 3),
      showProgressBar: true,
      style: ToastificationStyle.flatColored,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      primaryColor: toastStyles[type]!['borderColor'] as Color,
      backgroundColor: toastStyles[type]!['bgColor'] as Color,
      icon: Icon(toastStyles[type]!['icon'] as IconData,
          color: toastStyles[type]!['borderColor'] as Color),
      closeOnClick: true,
      pauseOnHover: true,
      borderRadius: BorderRadius.circular(8),
      padding: const EdgeInsets.all(12),
    );
  }
}
