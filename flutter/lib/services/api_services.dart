import 'package:dio/dio.dart';
import '../core/config/app_config.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: AppConfig.apiTimeout,
    ),
  );

  Future<Response> getRequest(String endpoint) async {
    try {
      final response =
          await _dio.get('$endpoint?version=${AppConfig.appVersion}');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Add other methods as needed
}
