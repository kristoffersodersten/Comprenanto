import 'package:dio/dio.dart';

class CacheInterceptor extends Interceptor {
  final Map<String, Response> _cache = {};
  final Duration cacheDuration;

  CacheInterceptor({this.cacheDuration = const Duration(hours: 1)});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final cachedResponse = _cache[options.uri.toString()];
    if (cachedResponse != null &&
        DateTime.now().difference(cachedResponse.extra['timestamp'] as DateTime) < cacheDuration) {
      handler.resolve(cachedResponse);
      return;
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    response.extra['timestamp'] = DateTime.now();
    _cache[response.requestOptions.uri.toString()] = response;
    handler.next(response);
  }
}