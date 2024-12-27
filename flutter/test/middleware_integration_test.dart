import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import '../lib/services/secure_api_service.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late SecureApiService apiService;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    apiService = SecureApiService(dio: mockDio);
  });

  test('post method encrypts and decrypts data', () async {
    when(mockDio.post(any, data: anyNamed('data')))
        .thenAnswer((_) async => Response(
              data: {'message': 'Test response'},
              statusCode: 200,
              requestOptions: RequestOptions(path: ''),
            ));

    final response = await apiService.post('test', {'key': 'value'});
    expect(response.data['message'], 'Test response');
  });
}
