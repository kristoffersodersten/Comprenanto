import 'package:your_project_name/services/api_service.dart'; // Update with your actual project name

class MiddlewareService {
  final ApiService _apiService; // Use ApiService instead of Dio
  final _cache = <String, dynamic>{};

  MiddlewareService() : _apiService = ApiService();

  Future<void> fetchData(String endpoint) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(endpoint);
      _cache[endpoint] = response;
    } catch (e) {
      print('Failed to fetch data: $e');
      rethrow;
    }
  }

  dynamic getCachedData(String key) {
    return _cache[key];
  }

  void clearCache() {
    _cache.clear();
  }
}
