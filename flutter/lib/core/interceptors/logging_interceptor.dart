import 'package:dio/dio.dart';
import '../utils/logger.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.debug('API Request: ${options.method} ${options.path}');
    AppLogger.debug('Headers: ${options.headers}');
    AppLogger.debug('Data: ${options.data}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.debug('API Response: ${response.statusCode}');
    AppLogger.debug('Data: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      'API Error: ${err.type} - ${err.message}',
      err,
      err.stackTrace,
    );
    handler.next(err);
  }
}

class RetryInterceptor extends Interceptor {
  final int retryCount;
  final int retryDelayMs;
  final List<int> retryStatusCodes;

  RetryInterceptor({
    this.retryCount = 3,
    this.retryDelayMs = 1000,
    this.retryStatusCodes = const [408, 500, 502, 503, 504],
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final currentRetry = options.extra['retryCount'] as int? ?? 0;

    if (_shouldRetry(err, currentRetry)) {
      await Future.delayed(Duration(milliseconds: retryDelayMs));
      
      options.extra['retryCount'] = currentRetry + 1;
      
      try {
        final response = await Dio().fetch(options);
        return handler.resolve(response);
      } catch (e) {
        return super.onError(err, handler);
      }
    }

    return super.onError(err, handler);
  }

  bool _shouldRetry(DioException error, int currentRetry) {
    if (currentRetry >= retryCount) return false;

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return true;
    }

    final statusCode = error.response?.statusCode;
    if (statusCode != null && retryStatusCodes.contains(statusCode)) {
      return true;
    }

    return false;
  }
} 