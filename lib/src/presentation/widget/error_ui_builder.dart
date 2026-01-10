import 'package:flutter/material.dart';
import 'package:panimithra/l10n/app_localizations.dart';
import 'package:panimithra/src/presentation/widget/error_state_widget.dart';
import 'package:panimithra/src/presentation/widget/empty_state_widget.dart';
import 'package:panimithra/src/presentation/widget/no_internet_widget.dart';
import 'package:panimithra/src/common/error_message_mapper.dart';

/// Centralized error UI builder for consistent error handling across the app
/// 
/// This class provides a single source of truth for how errors should be displayed
/// ensuring consistency across all screens.
class ErrorUIBuilder {
  /// Builds appropriate error UI based on error type
  /// 
  /// Returns:
  /// - NoInternetWidget for network errors
  /// - ErrorStateWidget for general errors
  /// - Handles session expired errors specially
  static Widget buildErrorUI({
    required BuildContext context,
    required dynamic error,
    required VoidCallback onRetry,
    IconData? customIcon,
  }) {
    // Check for network errors
    if (ErrorMessageMapper.isNetworkError(error)) {
      return NoInternetWidget(onRetry: onRetry);
    }

    // Check for unauthorized/session expired errors
    if (ErrorMessageMapper.isUnauthorizedError(error)) {
      final l10n = AppLocalizations.of(context)!;
      return ErrorStateWidget(
        message: l10n.sessionExpiredMessage,
        icon: Icons.lock_clock_outlined,
        onRetry: onRetry,
      );
    }

    // General error
    final message = ErrorMessageMapper.getErrorMessage(context, error);
    return ErrorStateWidget(
      message: message,
      icon: customIcon,
      onRetry: onRetry,
    );
  }

  /// Builds empty state UI
  static Widget buildEmptyState({
    required BuildContext context,
    String? message,
    String? subtitle,
    VoidCallback? onRefresh,
    IconData? icon,
  }) {
    return EmptyStateWidget(
      message: message,
      subtitle: subtitle,
      onRefresh: onRefresh,
      icon: icon,
    );
  }

  /// Builds loading UI
  static Widget buildLoadingUI(BuildContext context, {String? message}) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            message ?? l10n.loadingPleaseWait,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Shows error toast for non-critical errors (form validation, etc.)
  /// Use this ONLY for temporary notifications, NOT for screen-level errors
  static void showErrorToast(
    BuildContext context,
    dynamic error, {
    Duration duration = const Duration(seconds: 3),
  }) {
    final message = ErrorMessageMapper.getErrorMessage(context, error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Shows success toast
  static void showSuccessToast(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
