import 'package:flutter/material.dart';

Widget buildProgressStep({required bool isActive, required bool isCompleted}) {
  return Container(
    width: 50,
    height: 8,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: isCompleted
          ? const Color(0xFF1565C0)
          : isActive
              ? const Color(0xFF64B5F6)
              : const Color(0xFFBBDEFB),
    ),
  );
}

Widget buildProgressLine({required bool isActive}) {
  return Expanded(
    child: Container(
      height: 2,
      color: isActive ? const Color(0xFF64B5F6) : const Color(0xFFBBDEFB),
    ),
  );
}

IconData getIconData(String categoryName) {
  final name = categoryName.toLowerCase();
  if (name.contains('plumb')) return Icons.plumbing;
  if (name.contains('electric')) return Icons.electrical_services;
  if (name.contains('carpen')) return Icons.handyman;
  if (name.contains('clean')) return Icons.cleaning_services;
  if (name.contains('paint')) return Icons.format_paint;
  if (name.contains('hvac') || name.contains('ac')) return Icons.ac_unit;
  return Icons.category;
}

Color getIconColor(String categoryName) {
  final name = categoryName.toLowerCase();
  if (name.contains('plumb')) return const Color(0xFF2196F3);
  if (name.contains('electric')) return const Color(0xFFFF9800);
  if (name.contains('carpen')) return const Color(0xFFFDD835);
  if (name.contains('clean')) return const Color(0xFF26A69A);
  if (name.contains('paint')) return const Color(0xFF9C27B0);
  if (name.contains('hvac') || name.contains('ac')) {
    return const Color(0xFF00BCD4);
  }
  return const Color(0xFF607D8B);
}

Color getBackgroundColor(String categoryName) {
  final name = categoryName.toLowerCase();
  if (name.contains('plumb')) return const Color(0xFFE3F2FD);
  if (name.contains('electric')) return const Color(0xFFFFF3E0);
  if (name.contains('carpen')) return const Color(0xFFFFFDE7);
  if (name.contains('clean')) return const Color(0xFFE0F2F1);
  if (name.contains('paint')) return const Color(0xFFF3E5F5);
  if (name.contains('hvac') || name.contains('ac')) {
    return const Color(0xFFE0F7FA);
  }
  return const Color(0xFFECEFF1);
}

Color getStatusColor(String status) {
  final statusLower = status.toLowerCase();
  if (statusLower.contains('active')) return const Color(0xFF4CAF50);
  if (statusLower.contains('archive')) return const Color(0xFFFFA726);
  if (statusLower.contains('disable') || statusLower.contains('inactive')) {
    return const Color(0xFFEF5350);
  }
  return const Color(0xFF9E9E9E);
}

String getStatusText(String status) {
  final statusLower = status.toLowerCase();
  if (statusLower.contains('active')) return 'Active';
  if (statusLower.contains('archive')) return 'Archived';
  if (statusLower.contains('disable') || statusLower.contains('inactive')) {
    return 'Disabled';
  }
  return status;
}

String planHelper(int duration) {
  String plan = "";
  if (duration == 30) {
    plan = "Month";
  }
  if (duration == 90) {
    plan = "Quaterly";
  }
  if (duration == 180) {
    plan = "Half Yearly";
  }
  if (duration == 365) {
    plan = "Annual Plan";
  }
  return plan;
}
