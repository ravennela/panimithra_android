import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:panimithra/l10n/app_localizations.dart';
import 'package:panimithra/src/common/exception.dart';

/// Utility class for mapping exceptions to user-friendly localized messages
class ErrorMessageMapper {
  /// Maps an exception to a user-friendly localized message
  static String getErrorMessage(BuildContext context, dynamic error) {
    final l10n = AppLocalizations.of(context)!;

    if (error is SocketException) {
      return l10n.noInternetMessage;
    }

    if (error is NetworkException) {
      return l10n.noInternetMessage;
    }

    if (error is TimeoutException) {
      return l10n.networkTimeout;
    }

    if (error is UnauthorizedException) {
      return l10n.sessionExpiredMessage;
    }

    if (error is ValidationException) {
      return l10n.validationError;
    }

    if (error is ServerException) {
      return l10n.serverError;
    }

    if (error is DioException) {
      return _mapDioException(context, error);
    }

    // Default fallback
    return l10n.unexpectedError;
  }

  /// Maps DioException to user-friendly localized message
  static String _mapDioException(BuildContext context, DioException error) {
    final l10n = AppLocalizations.of(context)!;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return l10n.networkTimeout;

      case DioExceptionType.connectionError:
        return l10n.noInternetMessage;

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null) {
          return _mapStatusCode(context, statusCode, error);
        }
        return l10n.serverError;

      case DioExceptionType.cancel:
        return l10n.unexpectedError;

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return l10n.noInternetMessage;
        }
        return l10n.unexpectedError;

      default:
        return l10n.unexpectedError;
    }
  }

  /// Maps HTTP status codes to user-friendly localized messages
  static String _mapStatusCode(
      BuildContext context, int statusCode, DioException error) {
    final l10n = AppLocalizations.of(context)!;

    switch (statusCode) {
      case 400:
      case 422:
        // Try to extract validation message from response
        final responseData = error.response?.data;
        if (responseData is Map && responseData.containsKey('message')) {
          return responseData['message'].toString();
        }
        if (responseData is Map && responseData.containsKey('error')) {
          return responseData['error'].toString();
        }
        return l10n.validationError;

      case 401:
      case 403:
        return l10n.sessionExpiredMessage;

      case 404:
        return l10n.noDataAvailable;

      case 500:
      case 502:
      case 503:
      case 504:
        return l10n.serverError;

      default:
        return l10n.unexpectedError;
    }
  }

  /// Checks if the error is a network connectivity issue
  static bool isNetworkError(dynamic error) {
    if (error is SocketException) return true;
    if (error is NetworkException) return true;
    if (error is DioException) {
      return error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.error is SocketException;
    }
    return false;
  }

  /// Checks if the error is an unauthorized error (session expired)
  static bool isUnauthorizedError(dynamic error) {
    if (error is UnauthorizedException) return true;
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      return statusCode == 401 || statusCode == 403;
    }
    return false;
  }
}
