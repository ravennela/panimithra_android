import 'package:flutter/material.dart';

/// Mixin to prevent duplicate API calls during loading states
/// 
/// Usage:
/// ```dart
/// class MyScreen extends StatefulWidget {
///   // ...
/// }
/// 
/// class _MyScreenState extends State<MyScreen> with LoadingStateMixin {
///   void _loadData() {
///     if (isLoading) return; // Prevent duplicate calls
///     
///     setLoading(true);
///     try {
///       // Make API call
///       await repository.getData();
///     } finally {
///       setLoading(false);
///     }
///   }
/// }
/// ```
mixin LoadingStateMixin<T extends StatefulWidget> on State<T> {
  bool _isLoading = false;

  /// Check if currently loading
  bool get isLoading => _isLoading;

  /// Set loading state
  void setLoading(bool loading) {
    if (mounted) {
      setState(() {
        _isLoading = loading;
      });
    }
  }

  /// Execute an async operation with automatic loading state management
  /// 
  /// Example:
  /// ```dart
  /// await executeWithLoading(() async {
  ///   await repository.getData();
  /// });
  /// ```
  Future<T?> executeWithLoading<T>(Future<T> Function() operation) async {
    if (_isLoading) return null;

    setLoading(true);
    try {
      return await operation();
    } finally {
      setLoading(false);
    }
  }
}

/// Widget wrapper that disables interactions during loading
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Color? overlayColor;
  final Widget? loadingWidget;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.overlayColor,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: overlayColor ?? Colors.black.withOpacity(0.3),
              child: Center(
                child: loadingWidget ??
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Button that shows loading state and prevents duplicate taps
class LoadingButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;
  final Widget? loadingWidget;

  const LoadingButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.child,
    this.style,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: isLoading
          ? (loadingWidget ??
              const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ))
          : child,
    );
  }
}
