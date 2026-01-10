import 'package:flutter/material.dart';
import 'package:panimithra/l10n/app_localizations.dart';

/// Reusable empty state widget for consistent empty data handling across the app
class EmptyStateWidget extends StatelessWidget {
  final String? message;
  final String? subtitle;
  final VoidCallback? onRefresh;
  final IconData? icon;
  final bool showRefreshButton;

  const EmptyStateWidget({
    super.key,
    this.message,
    this.subtitle,
    this.onRefresh,
    this.icon,
    this.showRefreshButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.inbox_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message ?? l10n.noDataAvailable,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle ?? l10n.noDataMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (showRefreshButton && onRefresh != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onRefresh,
                icon: Icon(Icons.refresh, color: theme.primaryColor),
                label: Text(
                  l10n.refreshButton,
                  style: TextStyle(color: theme.primaryColor),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: theme.primaryColor),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
