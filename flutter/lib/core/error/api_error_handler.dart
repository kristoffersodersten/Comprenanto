import 'package:dio/dio.dart';
import '../models/app_error.dart';
import 'dart:io';
import '../utils/logger.dart';

class ApiErrorHandler {
  static AppError handle(DioException error) {
    AppLogger.error('API Error', error, error.stackTrace);

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppError(
          title: 'Connection Timeout',
          message: 'Please check your internet connection and try again.',
          type: ErrorType.timeout,
        );
      case DioExceptionType.unknown:
      case DioExceptionType.cancel:
        if (error.error is SocketException) {
          return AppError(
            title: 'No Internet Connection',
            message: 'Please check your internet connection and try again.',
            type: ErrorType.network,
          );
        }
        return AppError(
          title: 'Unhandled Error',
          message: 'An unhandled error occurred.',
          type: ErrorType.unknown,
        );
      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);
      default:
        return AppError(
          title: 'Unexpected Error',
          message: 'An unexpected error occurred. Please try again.',
          type: ErrorType.unknown,
        );
    }
  }

  static AppError _handleResponseError(Response? response) {
    final statusCode = response?.statusCode ?? 0;
    final data = response?.data;

    switch (statusCode) {
      case 401:
        return AppError(
          title: 'Authentication Error',
          message: 'Please log in again to continue.',
          type: ErrorType.auth,
        );

      case 403:
        return AppError(
          title: 'Access Denied',
          message: 'You don\'t have permission to access this feature.',
          type: ErrorType.auth,
        );

      case 404:
        return AppError(
          title: 'Not Found',
          message: 'The requested resource was not found.',
          type: ErrorType.api,
        );

      case 429:
        return AppError(
          title: 'Too Many Requests',
          message: 'Please wait a moment before trying again.',
          type: ErrorType.api,
        );

      default:
        return AppError(
          title: 'Server Error',
          message: data?['message'] ?? 'An unexpected error occurred.',
          type: ErrorType.api,
        );
    }
  }
} 